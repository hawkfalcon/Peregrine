import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let icon = NSImage.Name("GitHub")
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover()
    let menu = NSMenu()
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: icon)
            button.action = #selector(clickMenuBar(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        popover.contentViewController = SplitViewController.freshController()
        constructMenu()
        
        /* Any clicks outside of the popup close it. Weak to prevent a reference counting cycle */
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover()
            }
        }
        
        /* Register our app to get notified when launched via URL */
//        NSAppleEventManager.shared().setEventHandler(self,
//            andSelector: #selector(handleURLEvent(_:withReply:)),
//            forEventClass: AEEventClass(kInternetEventClass),
//            andEventID: AEEventID(kAEGetURL)
//        )
        
        NotificationCenter.default.removeObserver(self, name: .TogglePopover, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(togglePopover), name: .TogglePopover, object: nil)
    }
    
    @objc func clickMenuBar(_ sender: NSButton) {
        NSApplication.shared.activate(ignoringOtherApps: true)
        let event = NSApp.currentEvent!
        
        if event.type == NSEvent.EventType.rightMouseUp {
            statusItem.popUpMenu(menu)
        }
        else {
            togglePopover()
        }
    }
    
//    /* Gets called when the App launches/opens via URL. */
//    @objc func handleURLEvent(_ event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {
//        guard let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue else {
//            NSLog("No valid URL to handle")
//            return
//        }
//        if let url = URL(string: urlString), "owl" == url.scheme && "oauth" == url.host {
//            showPopover()
//            NotificationCenter.default.post(name: .OAuthCallback, object: url)
//        }
//    }
    
    @objc func togglePopover() {
        popover.isShown ? closePopover() : showPopover()
    }
    
    func showPopover() {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }
    
    func closePopover() {
        popover.performClose(nil)
        eventMonitor?.stop()
    }
    
    func constructMenu() {
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Clear", action: #selector(clearLinks), keyEquivalent: ""))
    }
    
    @objc func clearLinks() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Link.key)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

extension Notification.Name {
    static let OAuthCallback = Notification.Name("OAuthCallback")
    static let TogglePopover = Notification.Name("TogglePopover")
}
