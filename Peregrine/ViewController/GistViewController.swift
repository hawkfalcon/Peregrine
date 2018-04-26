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
    @IBOutlet weak var profile: ProfileButton!
    
    @IBOutlet weak var descriptionField: TextField!
    @IBOutlet weak var secretButton: SegmentButton!
    @IBOutlet weak var importButton: TrackedButton!
    @IBOutlet weak var gistButton: GistButton!
    @IBOutlet weak var activityIndicator: ShootingStars!
    
    @IBOutlet weak var filestack: NSStackView!
    @IBOutlet weak var fileField: TextField!
    @IBOutlet var textView: TextView!
    
    @IBAction func toggle(_ sender: TrackedButton) {
        filestack.isHidden = !filestack.isHidden
    }
    var loader = GitHubLoader()
        
    var loggedIn = UserDefaults.standard.bool(forKey: "loggedInKey") {
        didSet {
            profile.logIn = loggedIn
            DispatchQueue.main.async {
                UserDefaults.standard.set(self.loggedIn, forKey: "loggedInKey")
            }
        }
    }

    override func viewDidLoad() {
        textView.delegate = self
        setupView()
        
        super.viewDidLoad()
    }

    func setupView() {
        filestack.isHidden = true
        gistButton.isEnabled = false
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
        }
        else {
            login()
        }
    }
    
    @IBAction func loginUsername(_ sender: UsernameButton) {
        if sender.title == sender.logIn {
            login()
        }
    }
    
    @IBAction func filebuttonPressed(_ sender: NSButton) {
        browseFile()
    }
    
    func addLinkToTable(link: String, description: String, filename: String) {
        var desc = description
        if description == "" && filename != "" {
            desc = filename
        }
        let link = Link(url: URL(string: link)!, description: desc)

        UserDefaults.standard.addToList(key: Link.key, value: link)
        NotificationCenter.default.post(name: .AddItem, object: nil)
    }
    
    func createGist() {
        self.gistButton.isEnabled = false
        self.gistButton.title = ""
        self.activityIndicator.animate = true

        let content = textView.string
        let filename = fileField.stringValue
        let description = descriptionField.stringValue
        let secret = secretButton.selectedSegment == 0
        loader.postGist(content: content, filename: filename, description: description,
            secret: secret) { dict, error in
                if let _ = error {
                    self.username?.title = "Error"
                }
                else if let gistUrl = dict?["html_url"] as? String {
                    self.openTableView()
                    self.addLinkToTable(link: gistUrl, description: description, filename: filename)
                }
                
                self.activityIndicator.animate = false
                self.textView.string = ""
                self.descriptionField.stringValue = ""
                self.fileField.stringValue = ""
                self.gistButton.attributedTitle = self.gistButton.blackTitle
        }
    }
    
    func login() {
        username?.title = "Loading..."
        loginButton?.isEnabled = false
        
        // Configure OAuth2 window
        loader.oauth2.authConfig.authorizeContext = view.window
        
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
        self.username?.title = username.logIn
        
        loginButton.image = NSImage(named: NSImage.Name("GitHub-White"))
        self.username?.isHidden = false
    }

    
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
    
    func openTableView() {
        if let parent = self.parent as? SplitViewController {
            if let listViewItem = parent.splitViewItems.last {
                listViewItem.isCollapsed = false
            }
        }
    }
    
    func browseFile() {
        let panel = NSOpenPanel()
        
        panel.title = "Choose a file to import"
        panel.showsResizeIndicator = true
        panel.showsHiddenFiles = false
        panel.canChooseDirectories = false
        panel.canCreateDirectories = true
        panel.allowsMultipleSelection = false
        //dialog.allowedFileTypes = ["txt"]
        
        let window = self.view.window!
        panel.beginSheetModal(for: window) { (response) in
            if response == .OK {
            if let result = panel.url {
                do {
                    let contents = try String(contentsOf: result)
                    self.textView.string = contents
                    self.fileField.stringValue = result.lastPathComponent
                    self.gistButton.isEnabled =  true
                }
                catch _ {
                    // Error handling
                }
            }
        } else {
            // Cancelled
        }
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

extension GistViewController: NSTextViewDelegate {
    /*func textViewDidChangeSelection(_ notification: Notification) {
    }

    func textDidBeginEditing(_ notification: Notification) {
    }
 
    func textDidEndEditing(_ notification: Notification) {
    }*/
 
    func textDidChange(_ notification: Notification) {
        gistButton.isEnabled = textView.string != ""
    }
}
