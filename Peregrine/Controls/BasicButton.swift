import Cocoa

protocol ClearControl: class {
    func applyClear()
}

class BasicButton: NSButton, ClearControl {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyClear()
        customize()
    }
    
    func createAttributedString(color: NSColor, size: CGFloat, title: String) -> NSAttributedString {
        return NSAttributedString.createAttributedString(color: color, size: size, title: title, alignment: self.alignment)
    }
    
    func createAttributedString(color: NSColor, size: CGFloat) -> NSAttributedString {
        return createAttributedString(color: color, size: size, title: self.title)
    }
    
    func customize() {}
}

extension ClearControl where Self: NSControl {
    func applyClear() {
        self.appearance = NSAppearance(named: .aqua)
        self.wantsLayer = true
        self.layer?.masksToBounds = true
        self.layer?.backgroundColor = .gistGray
        self.layer?.borderColor = .gistGray
    }
}

extension NSAttributedString {
    class func createAttributedString(color: NSColor, size: CGFloat, title: String, alignment: NSTextAlignment) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        let attributes: [NSAttributedStringKey : Any] = [
            .foregroundColor: color,
            .font: NSFont.systemFont(ofSize: size),
            .paragraphStyle: paragraphStyle]
        
        return NSAttributedString(string: title, attributes: attributes)
    }
}
