import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let icon = NSImage.Name("GitHub")
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover()
    let menu = NSMenu()
    var eventMonitor: EventMonitor?
    
    let OAuthCallback = NSNotification.Name(rawValue: "OAuthCallback")

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
                strongSelf.closePopover(event)
            }
        }
        
        /* Register our app to get notified when launched via URL */
        NSAppleEventManager.shared().setEventHandler(self,
            andSelector: #selector(handleURLEvent(_:withReply:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }
    
    @objc func clickMenuBar(_ sender: NSButton) {
        NSApplication.shared.activate(ignoringOtherApps: true)
        let event = NSApp.currentEvent!
        
        if event.type == NSEvent.EventType.rightMouseUp {
            statusItem.popUpMenu(menu)
        }
        else {
            togglePopover(sender)
        }
    }
    
    /* Gets called when the App launches/opens via URL. */
    @objc func handleURLEvent(_ event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {
        guard let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue else {
            NSLog("No valid URL to handle")
            return
        }
        if let url = URL(string: urlString), "owl" == url.scheme && "oauth" == url.host {
            showPopover(nil)
            NotificationCenter.default.post(name: OAuthCallback, object: url)
        }
    }
    
    func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }
    
    func closePopover(_ sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func constructMenu() {
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
