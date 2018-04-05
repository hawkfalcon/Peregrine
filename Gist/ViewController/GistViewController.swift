import Cocoa
import p2_OAuth2
import ProgressKit

class GistViewController: NSViewController {
    
/* TODO:
     - better failure states
     - add file / drag
     - file dropdown
        - set filename
        - filetype
     - open share on gist
     - settings
 */
    
    @IBOutlet weak var username: UsernameButton!
    @IBOutlet weak var loginButton: TrackedButton!
    @IBOutlet weak var loginLabel: BasicText!
    
    @IBOutlet weak var descriptionField: TextField!
    @IBOutlet weak var secretButton: SwitchButton!
    @IBOutlet weak var pasteButton: FileButton!
    @IBOutlet weak var gistButton: GistButton!
    @IBOutlet weak var activityIndicator: ShootingStars!
    
    @IBOutlet var textView: TextView!
    @IBOutlet var background: NSView!
    
    var loader = GitHubLoader()
        
    var loggedIn = UserDefaults.standard.bool(forKey: "loggedInKey") {
        didSet {
            DispatchQueue.main.async {
                UserDefaults.standard.set(self.loggedIn, forKey: "loggedInKey")
            }
        }
    }

    override func viewDidLoad() {
        textView.delegate = self
        loginButton.delegate = self

        setupView()
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
    }
    
    func setupView() {
        background.layer?.backgroundColor = .gistGray

        if loggedIn {
            login()
        }
    }
    
    @IBAction func buttonPress(_ sender: NSButton) {
        createGist()
    }
    
    @IBAction func login(_ sender: NSButton?) {
        if self.loggedIn {
            forgetTokens()
            return
        }
        else {
            login()
        }
    }
    
    @IBAction func usernamePress(_ sender: UsernameButton) {
        sender.selected = !sender.selected
    }
    
    @IBAction func filebuttonPressed(_ sender: FileButton) {
        sender.layer?.borderColor = .gistGray
        textView.string = getClipboard()
        
        loader.getGists() { dict, error in
            print(dict)
            // TODO: Remove my gists...
        }
    }
    
    func getClipboard() -> String {
        let clipboard = NSPasteboard.general
        guard let content = clipboard.string(forType: .string) else {
            return ""
        }
        return content
    }
    
    func setClipboard(link: String, description: String) {
        let clipboard = NSPasteboard.general
        clipboard.clearContents()
        clipboard.setString(link, forType: .string)
        
        addLinkToTable(link: link, description: description)
    }
    
    func addLinkToTable(link: String, description: String) {
        let link = Link(url: URL(string: link)!, description: description)

        UserDefaults.standard.addToList(key: Link.key, value: link)
        NotificationCenter.default.post(name: .AddItem, object: nil)
    }
    
    func createGist() {
        self.gistButton.isEnabled = false
        self.gistButton.title = ""
        self.activityIndicator.animate = true

        let content = textView.string
        let filename = "gist"
        let description = descriptionField.stringValue
        let secret = secretButton.state == .on
        loader.postGist(content: content, filename: filename, description: description,
            secret: secret, oauth: !username.selected) { dict, error in
                if let _ = error {
                    self.username?.title = "Error"
                }
                else if let gistUrl = dict?["html_url"] as? String {
                    self.setClipboard(link: gistUrl, description: description)
                }
                
                self.activityIndicator.animate = false
                self.gistButton.isEnabled = true
                self.textView.string = ""
                self.descriptionField.stringValue = ""
                self.gistButton.attributedTitle = self.gistButton.whiteTitle
        }
    }
    
    func login() {
        username?.title = "Fetching GitHub"
        loginButton?.isEnabled = false
        
        // Configure OAuth2 callback
        loader.oauth2.authConfig.authorizeContext = view.window
//        NotificationCenter.default.removeObserver(self, name: .OAuthCallback, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleRedirect(_:)), name: .OAuthCallback, object: nil)
//
        // Request user data
        loader.requestUserdata() { dict, error in
            if let error = error {
                self.username?.title = "Error"
                self.show(error)
            }
            else {
                if let imgURL = dict?["avatar_url"] as? String {
                    if let url = URL(string: imgURL), let data = try? Data(contentsOf: url) {
                        self.loginButton.image = NSImage(data: data)
                    }
                }
                if let username = dict?["name"] as? String {
                    self.username?.title = "\(username)"
                }
                
                self.loggedIn = true
                self.loginButton?.isEnabled = true
                self.username?.isHidden = false
            }
        }
    }
    
    func forgetTokens() {
        self.loggedIn = false

        loader.oauth2.forgetTokens()
        self.username?.title = "Log In"
        
        loginButton.image = NSImage(named: NSImage.Name("GitHub-White"))
        self.username?.isHidden = false
    }
    
    // MARK: - Authorization
//    @objc func handleRedirect(_ notification: Notification) {
//        if let url = notification.object as? URL {
//            self.username?.title = "Loading"
//            do {
//                try loader.oauth2.handleRedirectURL(url)
//            }
//            catch let error {
//                show(error)
//            }
//        }
//        else {
//            show(NSError(domain: NSCocoaErrorDomain, code: 0, userInfo:
//                [NSLocalizedDescriptionKey: "Invalid URL"]
//            ))
//        }
//    }
    
    // MARK: - Error Handling
    
    // Create error to display
    func show(_ error: Error) {
        if let error = error as? OAuth2Error {
            let err = NSError(domain: "OAuth2Error", code: 0, userInfo:
                [NSLocalizedDescriptionKey: error.description]
            )
            display(err)
        }
        else {
            display(error as NSError)
        }
    }
    
    // Alert or log the given NSError
    func display(_ error: NSError) {
        if let window = self.view.window {
            NSAlert(error: error).beginSheetModal(for: window, completionHandler: nil)
        }
        else {
            NSLog("Error authorizing: \(error.description)")
        }
    }
}

extension UserDefaults {
    func getList(key: String) -> [Link] {
        if let data = self.value(forKey: key) as? Data {
            if let links = try? PropertyListDecoder()
                .decode(Array<Link>.self, from: data) {
                return links
            }
        }
        return []
    }
    
    func addToList(key: String, value: Link) {
        var links = getList(key: key)
        links.insert(value, at: 0)
        self.set(try? PropertyListEncoder().encode(links), forKey: key)
    }
}

extension GistViewController: HoverableDelegate {
    func hoverStart() {
        loginLabel.stringValue = "Log " + (loggedIn ? "Out" : "In")
    }
    
    func hoverStop() {
        loginLabel.stringValue = ""
    }
}

extension GistViewController: NSTextViewDelegate {
    /*func textViewDidChangeSelection(_ notification: Notification) {
    }

    func textDidBeginEditing(_ notification: Notification) {
    }
 
    func textDidEndEditing(_ notification: Notification) {
    }*/
 
    func textDidChange(_ notification: Notification) {
        guard let textView = notification.object as? TextView else { return }
        pasteButton.isHidden = textView.string != ""
    }
}
