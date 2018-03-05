
import Cocoa

class TextView: NSTextView {
    
    let placeholderText = "Hello I am some text I want to share please share me"

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
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
        if self.string == placeholderText {
            self.string = ""
        }
    }
    
    func exitedTextView() {
        if self.string == "" {
            self.string = placeholderText
        }
        
    }
}
