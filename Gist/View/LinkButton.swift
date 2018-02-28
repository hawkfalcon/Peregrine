import Cocoa

class LinkButton: BasicButton {
    
    override func customize() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        let attributes: [NSAttributedStringKey : Any] = [.foregroundColor: NSColor.white, .font: NSFont.systemFont(ofSize: 16), .paragraphStyle: paragraphStyle]
        self.attributedTitle = NSMutableAttributedString(string: self.title, attributes: attributes)
    }
}
