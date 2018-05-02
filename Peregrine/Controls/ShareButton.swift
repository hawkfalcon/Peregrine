import Cocoa

class ShareButton: TrackedButton {
    
    override func customize() {
        self.sendAction(on: .leftMouseDown)
    }
}
