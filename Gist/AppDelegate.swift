//
//  AppDelegate.swift
//  Gist
//
//  Created by Tristen Miller on 1/9/18.
//  Copyright © 2018 Tristen Miller. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let icon = NSImage.Name("GitHub")
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    
    let OAuth2AppDidReceiveCallbackNotification = NSNotification.Name(rawValue: "OAuth2AppDidReceiveCallback")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: icon)
            button.action = #selector(togglePopover(_:))
        }
        popover.contentViewController = GistViewController.freshController()
        
        //constructMenu()
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
    
    /* Gets called when the App launches/opens via URL. */
    @objc func handleURLEvent(_ event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {
        guard let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue else {
            NSLog("No valid URL to handle")
            return
        }
        if let url = URL(string: urlString), "owl" == url.scheme && "oauth" == url.host {
            showPopover(nil)
            NotificationCenter.default.post(name: OAuth2AppDidReceiveCallbackNotification, object: url)
        }
    }
    
    @objc func togglePopover(_ sender: Any?) {
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
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Quotes", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
