import Cocoa

class TableViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet weak var tableView: NSTableView!
    var objects: [Link] = []
    
    @IBOutlet var scrollView: NSScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        objects = UserDefaults.standard.getList(key: Link.key)
        tableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.addTableViewItem(_:)), name: .AddItem, object: nil)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.objects.count
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let cell = tableView.makeView(withIdentifier: .init("Cell"), owner: nil) as? TableRowView
        cell?.text.stringValue = self.objects[row].description

        return cell
    }
    
//    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        let cell = tableView.makeView(withIdentifier: .init("Cell"), owner: nil) as? NSTableCellView
//        cell?.textField?.stringValue = self.objects[row]
//
//        return cell
//    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView.selectedRow
        if row >= 0 {
            NSWorkspace.shared.open(self.objects[row].url)
            NotificationCenter.default.post(name: .TogglePopover, object: nil)
            tableView.deselectRow(row)
        }
    }
    
    @objc func addTableViewItem(_ not: Notification) {
        objects = UserDefaults.standard.getList(key: Link.key)
        tableView.reloadData()
    }
    
    override var representedObject: Any? {
        didSet {
        }
    }
}

extension Notification.Name {
    static let AddItem = Notification.Name("addTableViewItem")
}
