import Cocoa

extension NSImage.Name {
    //TODO: Update Image
    static let icon = NSImage.Name("GitHub")
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
    }
}

extension NSStoryboard.Name {
    static let main = NSStoryboard.Name("Main")
}

extension NSStoryboard.SceneIdentifier {
    static let splitViewController = NSStoryboard.SceneIdentifier("SplitViewController")
}

struct Constants {
    static let logIn = "Log In"
    static let logOut = "Log Out"
}
