import Cocoa

class SwitchButton: BasicButton {
    override func customize() {
        self.attributedTitle = NSAttributedString(string: "Secret", attributes: [
            NSAttributedStringKey.foregroundColor : NSColor.white])
    }
}
