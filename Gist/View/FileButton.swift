import Cocoa

class FileButton: NSButton {
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
}
