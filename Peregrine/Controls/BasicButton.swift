import Cocoa

class BasicButton: NSButton {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customize()
    }
    
    func createAttributedString(color: NSColor, size: CGFloat, title: String) -> NSAttributedString {
        return NSAttributedString.create(color: color, size: size, title: title, alignment: self.alignment)
    }
    
    func createAttributedString(color: NSColor, size: CGFloat) -> NSAttributedString {
        return createAttributedString(color: color, size: size, title: self.title)
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
