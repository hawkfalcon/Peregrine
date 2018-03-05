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
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.alignment
        
        let attributes: [NSAttributedStringKey : Any] = [
            .foregroundColor: color,
            .font: NSFont.systemFont(ofSize: size),
            .paragraphStyle: paragraphStyle]
        
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func createAttributedString(color: NSColor, size: CGFloat) -> NSAttributedString {
        return createAttributedString(color: color, size: size, title: self.title)
    }
    
    func customize() {}
}

extension ClearControl where Self: NSControl {
    func applyClear() {
        self.appearance = NSAppearance(named: NSAppearance.Name.aqua)
        self.wantsLayer = true
        self.layer?.masksToBounds = true
        self.layer?.backgroundColor = .clear
    }
}
