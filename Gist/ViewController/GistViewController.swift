import Cocoa
import OAuth2

class GistViewController: NSViewController {
    
    @IBOutlet weak var username: UsernameButton!
    @IBOutlet weak var loginButton: TrackedButton!
    @IBOutlet weak var loginLabel: NSTextField!
    
    @IBOutlet weak var descriptionField: NSTextField!
    @IBOutlet weak var secretButton: SwitchButton!
    @IBOutlet weak var pasteButton: NSButton!

    @IBOutlet var textField: NSTextView!
    @IBOutlet var background: NSView!
    
    var loader = GitHubLoader()
    
    let OAuthCallback = NSNotification.Name(rawValue: "OAuthCallback")

    var loggedIn = UserDefaults.standard.bool(forKey: "loggedInKey") {
        didSet {
            DispatchQueue.main.async {
                UserDefaults.standard.set(self.loggedIn, forKey: "loggedInKey")
            }
        }
    }

    override func viewDidLoad() {
        textField.delegate = self
        loginButton.delegate = self
        
        setupView()
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
    }
    
    func setupView() {
        loginLabel.stringValue = ""
        
        background.layer?.backgroundColor = .gistGray
        pasteButton.layer?.backgroundColor = .gistGray
        pasteButton.bezelColor = .gistGray
        
        textField.font = .systemFont(ofSize: 14)
        
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
    
    @IBAction func pasteClipboard(_ sender: Any) {
        textField.string = getClipboard()
    }
    
    func getClipboard() -> String {
        let clipboard = NSPasteboard.general
        guard let content = clipboard.string(forType: .string) else {
            return ""
        }
        return content
    }
    
    func setClipboard(content: String) {
        let clipboard = NSPasteboard.general
        clipboard.clearContents()
        clipboard.setString(content, forType: .string)
    }
    
    func createGist() {
        let content = textField.string
        let filename = "gist"
        let description = descriptionField.stringValue
        let secret = secretButton.state == .on
        loader.postGist(content: content, filename: filename, description: description,
            secret: secret, oauth: !username.selected) { dict, error in
            if let _ = error {
                self.username?.title = "Error"
            }
            else if let gistUrl = dict?["html_url"] as? String {
                self.setClipboard(content: gistUrl)
            }
        }
    }
    
    func login() {
        username?.title = "Fetching GitHub"
        loginButton?.isEnabled = false
        
        // Configure OAuth2 callback
        loader.oauth2.authConfig.authorizeContext = view.window
        NotificationCenter.default.removeObserver(self, name: OAuthCallback, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRedirect(_:)), name: OAuthCallback, object: nil)
        
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
    @objc func handleRedirect(_ notification: Notification) {
        if let url = notification.object as? URL {
            self.username?.title = "Loading"
            do {
                try loader.oauth2.handleRedirectURL(url)
            }
            catch let error {
                show(error)
            }
        }
        else {
            show(NSError(domain: NSCocoaErrorDomain, code: 0, userInfo:
                [NSLocalizedDescriptionKey: "Invalid URL"]
            ))
        }
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
//    func textViewDidChangeSelection(_ notification: Notification) {
//        print("SELECTION")
//    }
//
    func textDidBeginEditing(_ notification: Notification) {
        pasteButton.isHidden = true
        print("Began editing")
    }
    
    func textDidEndEditing(_ notification: Notification) {
        guard let textView = notification.object as? TextView else { return }
        if textView.string == textView.placeholderText {
            pasteButton.isHidden = false
        }
        print("Left editing")
    }
    
//    func textDidChange(_ notification: Notification) {
//        guard let textView = notification.object as? NSTextView else { return }
//        print("textView.string")
//    }
}
