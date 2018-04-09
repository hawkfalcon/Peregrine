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
    
    @IBAction func shareSheet(_ sender: NSButton) {
        let sharingPicker:NSSharingServicePicker = NSSharingServicePicker.init(items:
            [
                objects[sender.tag].description,
                objects[sender.tag].url
            ]
        )
        sharingPicker.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
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
        let object = self.objects[row]
        let text = object.description != "" ? object.description : "\(object.url.absoluteString.prefix(38))..."
    
        cell?.text.stringValue = text
        cell?.button.tag = row

        return cell
    }
    
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
        tableView.rowView(atRow: 0, makeIfNecessary: false)?.isSelected = true
        //tableView.selectRowIndexes([0], byExtendingSelection: false)
    }
}

extension Notification.Name {
    static let AddItem = Notification.Name("addTableViewItem")
}
