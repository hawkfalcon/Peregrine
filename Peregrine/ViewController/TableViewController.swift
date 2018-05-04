import Cocoa

class TableViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var scrollView: NSScrollView!

    var links: [Link] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        scrollView.contentView.postsBoundsChangedNotifications = true
        NotificationCenter.default.addObserver(self, selector: #selector(boundsChange), name: NSView.boundsDidChangeNotification, object: scrollView?.contentView)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        self.links = UserDefaults.standard.getList(key: UserDefaults.Key.links)
        tableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.addTableViewItem(_:)), name: .AddItem, object: nil)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.links.count
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let cell = tableView.makeView(withIdentifier: .init("Cell"), owner: nil) as? TableRowView
        let link = self.links[row]
        var text = link.description != "" ? link.description : link.url.absoluteString
        if text.count >= Constants.maxStringLength {
            text = "\(text.prefix(Constants.maxStringLength))..."
        }
    
        cell?.text.stringValue = text
        cell?.button.tag = row

        return cell
    }
    
    @IBAction func shareSheet(_ sender: NSButton) {
        let link = self.links[sender.tag]

        let sharingPicker = NSSharingServicePicker(items: [link.url])
        sharingPicker.delegate = self
        
        sharingPicker.show(relativeTo: NSZeroRect, of: sender, preferredEdge: .minY)
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView.selectedRow
        if row >= 0 {
            NSWorkspace.shared.open(self.links[row].url)
            NotificationCenter.default.post(name: .TogglePopover, object: nil)
            tableView.deselectRow(row)
        }
    }
    
    @objc func addTableViewItem(_ not: Notification) {
        self.links = UserDefaults.standard.getList(key: UserDefaults.Key.links)
        tableView.reloadData()
        tableView.scrollRowToVisible(0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tableView.rowView(atRow: 0, makeIfNecessary: false)?.isSelected = true
        }
    }

    // Deselect any highlighted row on scrolling
    @objc func boundsChange() {
        let range = tableView.rows(in: tableView.visibleRect)
        for row in range.location..<(range.location + range.length) {
            tableView.rowView(atRow: row, makeIfNecessary: false)?.isSelected = false
        }
    }
    
    func setClipboard(text: String) {
        let clipboard = NSPasteboard.general
        clipboard.clearContents()
        clipboard.setString(text, forType: .string)
    }
}

extension TableViewController: NSSharingServicePickerDelegate {
    func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, sharingServicesForItems items: [Any], proposedSharingServices proposedServices: [NSSharingService]) -> [NSSharingService] {
        guard let image = NSImage(named: NSImage.Name.copy) else {
            return proposedServices
        }
        
        var share = proposedServices
        let customService = NSSharingService(title: "Copy Gist Link", image: image, alternateImage: image, handler: {
            if let link = items.first as? URL {
                self.setClipboard(text: link.absoluteString)
            }
        })
        share.insert(customService, at: 0)
        
        return share
    }
}
