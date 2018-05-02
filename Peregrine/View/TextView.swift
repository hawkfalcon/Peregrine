
import Cocoa

class TextView: NSTextView {
    // Exposes the private placeholder
    @objc var placeholderAttributedString: NSAttributedString?

    let size: CGFloat = 14
    let placeholderText = "Type or paste text/code..."

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.font = .systemFont(ofSize: 14)
        self.placeholderAttributedString =
            NSAttributedString.create(
            color: .gistLightGray,
            size: size, title: placeholderText,
            alignment: .left)
    }
    
    override func becomeFirstResponder() -> Bool {
        enteredTextView()
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        exitedTextView()
        return super.resignFirstResponder()
    }
    
    func enteredTextView() {
    }
    
    func exitedTextView() {
    }
    
    // MARK: key shortcuts
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        guard event.type == .keyDown else { return false }
        if event.modifierFlags.contains(NSEvent.ModifierFlags.command.union(.shift)) {
            if event.charactersIgnoringModifiers == "Z" {
                if NSApp.sendAction(Selector(("redo:")), to: nil, from: self) { return true }
            }
        }
        else if event.modifierFlags.contains(.command) {
            switch event.charactersIgnoringModifiers!.lowercased() {
            case "x":
                if NSApp.sendAction(#selector(NSText.cut(_:)), to: nil, from: self) { return true }
            case "c":
                if NSApp.sendAction(#selector(NSText.copy(_:)), to: nil, from: self) { return true }
            case "v":
                if NSApp.sendAction(#selector(NSText.paste(_:)), to: nil, from: self) { return true }
            case "z":
                if NSApp.sendAction(Selector(("undo:")), to: nil, from: self) { return true }
            case "a":
                if NSApp.sendAction(#selector(NSResponder.selectAll(_:)), to: nil, from: self) { return true }
            default:
                break
            }
        }
        return super.performKeyEquivalent(with: event)
    }
}
