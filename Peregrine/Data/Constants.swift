import Cocoa

extension NSImage.Name {
    //TODO: Update Image
    static let icon = NSImage.Name("peregrine-logo")
    static let defaultProfile = NSImage.Name("GitHub-White")
    static let copy = NSImage.Name("copy")
}

extension Notification.Name {
    static let TogglePopover = Notification.Name("TogglePopover")
    static let AddItem = Notification.Name("addTableViewItem")
}

extension UserDefaults {
    struct Key {
        static let links = "linksKey"
        static let loggedIn = "loggedInKey"
        static let fileSectionExpanded = "fileSectionExpandedKey"
        static let secretButtonState = "secretButtonStateKey"
        static let tableViewExpanded = "tableViewExpandedKey"
    }
}

extension NSStoryboard.Name {
    static let main = NSStoryboard.Name("Main")
}

extension NSStoryboard.SceneIdentifier {
    static let splitViewController = NSStoryboard.SceneIdentifier("SplitViewController")
}

struct Constants {
    static let maxStringLength = 38
    static let waitTime = 1.5
}

struct Labels {
    static let empty = ""
    static let logIn = "Log In"
    static let logOut = "Log Out"
    static let defaultUsername = "Username"
    static let panel = "Choose a file"
    static let notLoggedIn = "Please Log In First 😊"
    static let gist = "Create Gist"
    static let noText = "Start Writing Above 🖋"
    static let noLinks = "Gists will appear here 👻"
}

struct Errors {
    static let logInError = "Try again? 😣"
    static let gistError = "Something is wrong 😰"
    static let fileError = "Invalid file 👾"
}

struct ResponseKey {
    static let username = "login"
    static let profile = "avatar_url"
    static let url = "html_url"
}
