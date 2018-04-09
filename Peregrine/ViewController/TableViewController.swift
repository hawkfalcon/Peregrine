import Cocoa

class TableViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet weak var tableView: NSTableView!
    var objects: [Link] = []
    
    @IBOutlet var scrollView: NSScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        scrollView.contentView.postsBoundsChangedNotifications = true
        NotificationCenter.default.addObserver(self, selector: #selector(boundsChange), name: NSView.boundsDidChangeNotification, object: scrollView?.contentView)
    }
    
    @IBAction func shareSheet(_ sender: NSButton) {
        let object = objects[sender.tag]
        var text = object.description != "" ? "\(object.description)\n" : ""
        text += object.url.absoluteString
        
        let sharingPicker:NSSharingServicePicker = NSSharingServicePicker(items: [text])
        sharingPicker.show(relativeTo: NSZeroRect, of: sender, preferredEdge: .minY)
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
        tableView.scrollRowToVisible(0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tableView.rowView(atRow: 0, makeIfNecessary: false)?.isSelected = true
        }
    }

    // Deselect any highlighted row on scrolling
    @objc func boundsChange() {
        //TODO make more efficient
        for row in 0..<objects.count {
            tableView.rowView(atRow: row, makeIfNecessary: false)?.isSelected = false
        }
    }
}

extension Notification.Name {
    static let AddItem = Notification.Name("addTableViewItem")
}
