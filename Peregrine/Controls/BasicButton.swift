import Cocoa

class BasicButton: NSButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customize()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        customize()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func createAttributedString(color: NSColor, size: CGFloat) -> NSAttributedString {
        return NSAttributedString.create(color: color, size: size, title: self.title, alignment: self.alignment)
    }
    
    func customize() {}
}

extension NSAttributedString {
    class func create(color: NSColor, size: CGFloat, title: String, alignment: NSTextAlignment) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        let attributes: [NSAttributedStringKey : Any] = [
            .foregroundColor: color,
            .font: NSFont.systemFont(ofSize: size),
            .paragraphStyle: paragraphStyle]
        
        return NSAttributedString(string: title, attributes: attributes)
    }
}
