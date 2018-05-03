import Cocoa

class CollapseViewController: NSViewController {
    func listViewItem() -> NSSplitViewItem? {
        if let parent = self.parent as? SplitViewController {
            if let listViewItem = parent.splitViewItems.last {
                return listViewItem
            }
        }
        return nil
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if let collapsible = listViewItem() {
            collapsible.isCollapsed = !UserDefaults.standard.bool(forKey: UserDefaults.Key.tableViewExpanded)
        }
    }
    
    @IBAction func collapse(_ sender: Any) {
        if let collapsible = listViewItem() {
            collapsible.isCollapsed = !collapsible.isCollapsed
            UserDefaults.standard.set(!collapsible.isCollapsed, forKey: UserDefaults.Key.tableViewExpanded)
        }
    }
}
