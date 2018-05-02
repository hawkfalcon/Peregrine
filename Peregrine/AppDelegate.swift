import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover()
    let menu = NSMenu()
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: .icon)
            button.action = #selector(clickMenuBar(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        popover.contentViewController = createViewController()
        popover.appearance = NSAppearance(named: .aqua)
        constructMenu()
        
        /* Any clicks outside of the popup close it. */
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover()
            }
        }

        NotificationCenter.default.removeObserver(self, name: .TogglePopover, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(togglePopover), name: .TogglePopover, object: nil)
    }
    
    @objc func clickMenuBar(_ sender: NSButton) {
        NSApplication.shared.activate(ignoringOtherApps: true)
        if let event = NSApp.currentEvent {
            if event.type == .rightMouseUp {
                statusItem.popUpMenu(menu)
            }
            else {
                togglePopover()
            }
        }
    }
    
    func createViewController() -> NSViewController {
        let storyboard = NSStoryboard(name: .main, bundle: nil)
        return storyboard.instantiateController(withIdentifier: .splitViewController) as! NSViewController
    }
    
    func constructMenu() {
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Clear", action: #selector(clearLinks), keyEquivalent: ""))
    }
    
    @objc func clearLinks() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: UserDefaults.Key.links)
    }
    
    @objc func togglePopover() {
        popover.isShown ? closePopover() : showPopover()
    }
    
    func showPopover() {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
        eventMonitor?.start()
    }
    
    func closePopover() {
        popover.performClose(nil)
        eventMonitor?.stop()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

/* Potential future update: detachable popover:
 
extension AppDelegate: NSPopoverDelegate {
    func popoverShouldDetach(_ popover: NSPopover) -> Bool {
        return true
    }
}
 */
