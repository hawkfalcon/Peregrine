import Cocoa
import p2_OAuth2
import ProgressKit

class GistViewController: NSViewController {
    
/* TODO:
     - Better failure states
     - Onboarding
     - Tests
 */
    
    /* Top login section */
    @IBOutlet weak var usernameButton: UsernameButton!
    @IBOutlet weak var profileButton: ProfileButton!
    @IBOutlet weak var secretButton: SegmentedControl!
    @IBOutlet weak var descriptionField: TextField!
    
    /* File collapsible section */
    @IBOutlet weak var fileSection: NSStackView!
    @IBOutlet weak var filenameField: TextField!
    @IBOutlet weak var importButton: TrackedButton!
    
    @IBOutlet var textView: TextView!
    
    /* Gist section */
    @IBOutlet weak var gistButton: TexturedButton!
    @IBOutlet weak var activityIndicator: ShootingStars!
    
    var loader = GitHubLoader()
    
    var loggedIn = UserDefaults.standard.bool(forKey: UserDefaults.Key.loggedIn) {
        didSet {
            self.profileButton.logIn = self.loggedIn
            DispatchQueue.main.async {
                UserDefaults.standard.set(self.loggedIn, forKey: UserDefaults.Key.loggedIn)
            }
        }
    }

    override func viewDidLoad() {
        self.textView.delegate = self
        setupView()
        
        super.viewDidLoad()
    }

    func setupView() {
        self.fileSection.isHidden = true
        self.gistButton.isEnabled = false
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
    
    @IBAction func usernameButtonPress(_ sender: UsernameButton) {
        if sender.title == Constants.logIn {
            login()
        }
    }
    
    @IBAction func toggleFileSection(_ sender: NSButton) {
        self.fileSection.isHidden = !self.fileSection.isHidden
    }
    
    @IBAction func importButtonPressed(_ sender: NSButton) {
        browseFile()
    }
    
    @IBAction func gistButtonPress(_ sender: NSButton) {
        createGist()
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
        self.gistButton.title = ""
        self.activityIndicator.animate = true

        let content = self.textView.string
        let filename = self.filenameField.stringValue
        let description = self.descriptionField.stringValue
        let secret = self.secretButton.selectedSegment == 0
        loader.postGist(content: content, filename: filename, description: description,
            secret: secret) { dict, error in
                if let _ = error {
                    self.usernameButton.title = "Error"
                    //TODO ERROR
                }
                //TODO magic string
                else if let gistUrl = dict?["html_url"] as? String {
                    self.openTableView()
                    self.addLinkToTable(link: gistUrl, description: description, filename: filename)
                }
                
                self.activityIndicator.animate = false
                self.textView.string = ""
                self.descriptionField.stringValue = ""
                self.filenameField.stringValue = ""
                self.gistButton.reset()
        }
    }
    
    func login() {
        usernameButton.title = "Loading..."
        profileButton.isEnabled = false
        
        // Configure OAuth2 window
        loader.oauth2.authConfig.authorizeContext = view.window
        
        // Request user data
        loader.requestUserdata() { dict, error in
            if let _ = error {
                self.usernameButton.title = "Error"
                //TODO ERROR
            }
            else {
                //TODO magic string
                if let imgURL = dict?["avatar_url"] as? String {
                    if let url = URL(string: imgURL), let data = try? Data(contentsOf: url) {
                        self.profileButton.image = NSImage(data: data)
                    }
                }
                //TODO magic string
                if let username = dict?["name"] as? String {
                    self.usernameButton.title = "\(username)"
                }
                
                self.loggedIn = true
                self.profileButton.isEnabled = true
            }
        }
    }
    
    func forgetTokens() {
        self.loggedIn = false
        loader.oauth2.forgetTokens()
        
        self.usernameButton.title = Constants.logIn
        self.profileButton.title = ""
        //TODO magic string
        self.profileButton.image = NSImage(named: NSImage.Name("GitHub-White"))
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
        
        panel.title = "Choose a file"
        panel.showsResizeIndicator = true
        panel.showsHiddenFiles = false
        panel.canChooseDirectories = false
        panel.canCreateDirectories = true
        panel.allowsMultipleSelection = false
        //dialog.allowedFileTypes = ["txt"]
        
        //TODO unwrap
        let window = self.view.window!
        panel.beginSheetModal(for: window) { (response) in
            if response == .OK {
            if let result = panel.url {
                do {
                    let contents = try String(contentsOf: result)
                    self.filenameField.stringValue = result.lastPathComponent
                    self.textView.string = contents
                    self.gistButton.isEnabled = true
                }
                catch _ {
                    //TODO ERROR
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
    func textDidChange(_ notification: Notification) {
        self.gistButton.isEnabled = textView.string != ""
    }
}
