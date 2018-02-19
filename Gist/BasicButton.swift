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
