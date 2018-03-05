import Cocoa

class TableViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    let key = "links"
    
    @IBOutlet weak var tableView: NSTableView!
    var objects: [String] = []
    
    @IBOutlet var scrollView: NSScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...100 {
            self.objects.append(String(i))
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        let defaults = UserDefaults.standard
        objects = defaults.object(forKey: key) as? [String] ?? [String]()
        tableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.addTableViewItem(_:)), name: Notification.Name.addItem, object: nil)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.objects.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: .init("Cell"), owner: nil) as? NSTableCellView
        cell?.textField?.stringValue = self.objects[row]
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView.selectedRow
        if row >= 0 {
            print(self.objects[row])
            tableView.deselectRow(row)
        }
    }
    
    @objc func addTableViewItem(_ not: Notification) {
        let defaults = UserDefaults.standard
        objects = defaults.object(forKey: key) as? [String] ?? [String]()
        tableView.reloadData()
    }
    
    override var representedObject: Any? {
        didSet {
        }
    }
}

extension Notification.Name {
    static let addItem = Notification.Name("addTableViewItem")
}
