import Cocoa

class GistButton: BasicButton {
    
    
    
    lazy var titleAttributes: [NSAttributedStringKey : Any] = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.alignment
        
        let attributes: [NSAttributedStringKey : Any] = [
            .foregroundColor: NSColor.white,
            .font: NSFont.systemFont(ofSize: 24),
            .paragraphStyle: paragraphStyle]
        
        return attributes
    }()
    
    lazy var highlightedTitleAttributes: [NSAttributedStringKey : Any] = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.alignment
        
        let attributes: [NSAttributedStringKey : Any] = [
            .foregroundColor: NSColor.black,
            .font: NSFont.systemFont(ofSize: 24),
            .paragraphStyle: paragraphStyle]
        
        return attributes
    }()
    
    
    
    override func customize() {
        self.attributedTitle = NSMutableAttributedString(string: self.title, attributes: titleAttributes)
        
        //self.layer?.cornerRadius = 6
        //self.layer?.backgroundColor = .init(red: 90.0 / 255.0, green: 94.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0)
        //self.image = tintedImage(self.image!, tint: .red)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if self.isHighlighted {
            self.attributedTitle = NSMutableAttributedString(string: self.title, attributes: titleAttributes)
        }
        else {
            self.attributedTitle = NSMutableAttributedString(string: self.title, attributes: highlightedTitleAttributes)
        }
    }

}
