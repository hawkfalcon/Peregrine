import Cocoa

class LinkTableView: NSTableView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        //self.layer?.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

