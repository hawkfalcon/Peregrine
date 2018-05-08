import Cocoa

class SplitViewController: NSSplitViewController {
    lazy var tableItem = self.splitViewItems.last
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = .gistGray
    }
    
    override func splitView(_ splitView: NSSplitView,
                   effectiveRect proposedEffectiveRect: NSRect,
                   forDrawnRect drawnRect: NSRect,
                   ofDividerAt dividerIndex: Int) -> NSRect {
        return NSRect(x: 0, y: 0, width: 0, height: 0)
    }

    override func splitView(_ splitView: NSSplitView, shouldHideDividerAt dividerIndex: Int) -> Bool {
        return true
    }
    
    func setCollapseToggleOn() {
        if let collapse = self.childViewControllers[1] as? CollapseViewController {
            collapse.collapseToggle.state = .on
        }
    }
}

