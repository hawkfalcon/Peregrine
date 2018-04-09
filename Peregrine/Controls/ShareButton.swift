import Cocoa

class ShareButton: NSButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.sendAction(on: .leftMouseDown)
    }
}
