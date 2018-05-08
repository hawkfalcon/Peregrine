import Cocoa

class CollapseViewController: NSViewController {
    @IBOutlet weak var collapseToggle: TrackedButton!
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if let split = self.parent as? SplitViewController, let collapsable = split.tableItem {
            collapsable.isCollapsed = !UserDefaults.standard.bool(forKey: UserDefaults.Key.tableViewExpanded)
            if collapsable.isCollapsed {
                collapseToggle.state = .off
            }
        }
    }
    
    @IBAction func collapse(_ sender: Any) {
        if let split = self.parent as? SplitViewController, let collapsable = split.tableItem {
            collapsable.isCollapsed = !collapsable.isCollapsed
            UserDefaults.standard.set(!collapsable.isCollapsed, forKey: UserDefaults.Key.tableViewExpanded)
        }
    }
}
