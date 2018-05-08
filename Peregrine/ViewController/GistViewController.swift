import Cocoa
import p2_OAuth2
import ProgressKit

class GistViewController: NSViewController {
    
    /* Top login section */
    @IBOutlet weak var usernameButton: HoverTextButton!
    @IBOutlet weak var profileButton: ProfileButton!
    @IBOutlet weak var secretButton: SegmentedControl!
    @IBOutlet weak var descriptionField: TextField!
    
    /* File collapsible section */
    @IBOutlet weak var fileSection: NSStackView!
    @IBOutlet weak var fileSectionToggle: TrackedButton!
    @IBOutlet weak var filenameField: TextField!
    @IBOutlet weak var importButton: TrackedButton!
    
    @IBOutlet var textView: TextView!
    
    /* Gist section */
    @IBOutlet weak var gistButton: HoverTextButton!
    @IBOutlet weak var activityIndicator: ShootingStars!
    
    var loader = GitHubLoader()
    
    var loggedIn = UserDefaults.standard.bool(forKey: UserDefaults.Key.loggedIn) {
        didSet {
            self.profileButton.logIn = self.loggedIn
            UserDefaults.standard.set(self.loggedIn, forKey: UserDefaults.Key.loggedIn)
        }
    }

    override func viewDidLoad() {
        self.textView.delegate = self
        setupView()
        
        super.viewDidLoad()
    }

    func setupView() {
        // Restore previous state
        let fileSectionExpanded = UserDefaults.standard.bool(forKey: UserDefaults.Key.fileSectionExpanded)
        self.fileSection.isHidden = !fileSectionExpanded
        if fileSectionExpanded {
            self.fileSectionToggle.state = .on
        }
        self.secretButton.setSelected(true, forSegment:
            UserDefaults.standard.integer(forKey: UserDefaults.Key.secretButtonState))
        
        self.usernameButton.title = Labels.logIn
        self.gistButton.title = Labels.notLoggedIn
        if self.loggedIn {
            login()
        }
    }
    
    @IBAction func profileButtonPress(_ sender: NSButton) {
        if self.loggedIn {
            forgetTokens()
        }
        else {
            login()
        }
    }
    
    @IBAction func usernameButtonPress(_ sender: HoverTextButton) {
        if !self.loggedIn {
            login()
        }
    }
    
    @IBAction func toggleFileSection(_ sender: NSButton) {
        self.fileSection.isHidden = !self.fileSection.isHidden
        UserDefaults.standard.set(!self.fileSection.isHidden, forKey: UserDefaults.Key.fileSectionExpanded)
    }
    
    @IBAction func importButtonPressed(_ sender: NSButton) {
        browseFile()
    }
    
    @IBAction func gistButtonPress(_ sender: NSButton) {
        if loggedIn {
            createGist()
        }
        else {
            login()
        }
    }
    
    @IBAction func secretButtonPressed(_ sender: SegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegment, forKey: UserDefaults.Key.secretButtonState)
    }
    
    func addLinkToTable(link: String, description: String, filename: String) {
        var desc = description
        if description == "" && filename != "" {
            desc = filename
        }
        let link = Link(url: URL(string: link)!, description: desc)

        UserDefaults.standard.addToList(key: UserDefaults.Key.links, value: link)
        NotificationCenter.default.post(name: .AddItem, object: nil)
    }
    
    func createGist() {
        self.gistButton.isEnabled = false
        self.gistButton.title = Labels.empty
        self.activityIndicator.animate = true

        let content = self.textView.string
        let filename = self.filenameField.stringValue
        let description = self.descriptionField.stringValue
        let secret = self.secretButton.selectedSegment == 0
        loader.postGist(content: content, filename: filename, description: description,
            secret: secret) { dict, error in
            if let _ = error {
                self.gistButton.title = Errors.gistError
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.gistButton.isEnabled = self.textView.string != ""
                }
            }
            else if let url = dict?[ResponseKey.url] as? String {
                self.openTableView()
                self.addLinkToTable(link: url, description: description, filename: filename)
                
                self.textView.string = Labels.empty
                self.descriptionField.stringValue = Labels.empty
                self.filenameField.stringValue = Labels.empty
                self.gistButton.title = Labels.gist
            }
            
            self.activityIndicator.animate = false
        }
    }
    
    func login() {
        // Configure OAuth2 window
        loader.oauth2.authConfig.authorizeContext = view.window
        
        // Request user data
        loader.requestUserdata() { dict, error in
            if let _ = error {
                self.loggedIn = false
                self.usernameButton.title = Errors.logInError
            }
            else {
                self.loggedIn = true
                let username = dict?[ResponseKey.username] as? String ?? Labels.defaultUsername
                var profileImage = NSImage(named: .defaultProfile)
                
                if let profileUrl = dict?[ResponseKey.profile] as? String {
                    if let url = URL(string: profileUrl), let data = try? Data(contentsOf: url) {
                        profileImage = NSImage(data: data)
                    }
                }

                self.loginView(username: username, image: profileImage)
            }
        }
    }
    
    func forgetTokens() {
        self.loggedIn = false
        loader.oauth2.forgetTokens()
        
        /* Eat cookies on log out */
        let storage = HTTPCookieStorage.shared
        if let cookies = storage.cookies {
            for cookie in cookies {
                storage.deleteCookie(cookie)
            }
        }
        
        self.resetView()
    }
    
    func loginView(username: String, image: NSImage?) {
        self.usernameButton.title = username
        self.usernameButton.untrackHover()
        self.usernameButton.isHoverCursorHand = false
        self.profileButton.title = Labels.empty
        self.profileButton.image = image
        self.gistButton.title = Labels.gist
        self.gistButton.isEnabled = self.textView.string != ""
    }
    
    func resetView() {
        self.usernameButton.title = Labels.logIn
        self.usernameButton.trackHover()
        self.usernameButton.isHoverCursorHand = true
        self.profileButton.title = Labels.empty
        self.profileButton.image = NSImage(named: .defaultProfile)
        self.gistButton.title = Labels.notLoggedIn
        self.gistButton.isEnabled = true
    }

    func openTableView() {
        if let split = self.parent as? SplitViewController, let tableItem = split.tableItem {
            tableItem.isCollapsed = false
            split.setCollapseToggleOn()
        }
    }
    
    func browseFile() {
        let panel = NSOpenPanel()
        
        panel.title = Labels.panel
        panel.showsResizeIndicator = true
        panel.showsHiddenFiles = false
        panel.canChooseDirectories = false
        panel.canCreateDirectories = true
        panel.allowsMultipleSelection = false
        //dialog.allowedFileTypes = ["txt"]
        
        guard let window = self.view.window else {
            return
        }
        panel.beginSheetModal(for: window) { (response) in
            if response != .OK {
                return // Cancelled
            }
            if let result = panel.url {
                do {
                    let contents = try String(contentsOf: result)
                    self.filenameField.stringValue = result.lastPathComponent
                    self.textView.string = contents
                    self.gistButton.isEnabled = true
                }
                catch _ {
                    self.filenameField.stringValue = Errors.fileError
                }
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
    func textDidChange(_ notification: Notification) {
        if self.loggedIn {
            self.gistButton.isEnabled = self.textView.string != ""
        }
    }
}
