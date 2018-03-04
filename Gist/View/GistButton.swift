import Cocoa

class GistButton: TrackedButton {
    
    lazy var whiteTitle = createAttributedString(color: .white)
    lazy var blackTitle = createAttributedString(color: .black)
    lazy var grayTitle = createAttributedString(color: .gistGray)

    func createAttributedString(color: NSColor) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.alignment
        
        let attributes: [NSAttributedStringKey : Any] = [
            .foregroundColor: color,
            .font: NSFont.systemFont(ofSize: 24),
            .paragraphStyle: paragraphStyle]
        
        return NSAttributedString(string: self.title, attributes: attributes)
    }
    
    override func customize() {
        self.attributedTitle = whiteTitle

        super.customize()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if self.isHighlighted {
            self.attributedTitle = whiteTitle
        }
        else {
            self.attributedTitle = blackTitle
        }
    }
    
    override func hoverOver() {
        self.layer?.backgroundColor = .gistMediumGray
        //self.attributedTitle = grayTitle
    }
    
    override func hoverOff() {
        self.layer?.backgroundColor = .gistGray
        self.attributedTitle = whiteTitle
    }
}

extension NSColor {
    static let gistLightGray = NSColor.init(
        red: 90.0 / 255.0, green: 94.0 / 255.0, blue: 98.0 / 255.0,
        alpha: 1.0
    )
    
    static let gistGray = NSColor.init(cgColor: .gistGray)!
}

extension CGColor {
    static let gistMediumGray = CGColor.init(
        red: 60 / 255.0, green: 64 / 255.0, blue: 68 / 255.0,
        alpha: 1.0
    )
}
