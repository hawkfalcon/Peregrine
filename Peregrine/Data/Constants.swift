import Cocoa

extension NSImage.Name {
    static let copy = NSImage.Name("copy")
}

extension Notification.Name {
    static let AddItem = Notification.Name("addTableViewItem")
}

extension UserDefaults {
    struct Key {
        static let links = "linksKey"
        static let loggedIn = "loggedInKey"
    }
}

struct Constants {
    static let logIn = "Log In"
    static let logOut = "Log Out"
}
