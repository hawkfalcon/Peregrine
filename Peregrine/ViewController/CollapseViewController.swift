import Cocoa

class CollapseViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func collapse(_ sender: Any) {
        if let parent = self.parent as? SplitViewController {
            if let listViewItem = parent.splitViewItems.last {
                listViewItem.isCollapsed = !listViewItem.isCollapsed
            }
        }
    }
}
