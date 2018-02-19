//
//  GistViewController.swift
//  Gist
//
//  Created by Tristen Miller on 1/28/18.
//  Copyright © 2018 Tristen Miller. All rights reserved.
//

import Cocoa
import OAuth2

class GistViewController: NSViewController {
    var loader = GitHubLoader()
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var loginButton: NSButton!
    @IBOutlet var box: NSView!
    @IBOutlet weak var pasteButton: NSButton!
    @IBOutlet weak var loginLabel: NSTextField!
    
    @IBOutlet var textField: NSTextView!
    
    var loggedIn = false

    override func viewDidLoad() {
        loginLabel.stringValue = ""
        
        let area = NSTrackingArea.init(rect: loginButton.bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: nil)
        loginButton.addTrackingArea(area)
        
        super.viewDidLoad()
    }
    
    override func mouseEntered(with event: NSEvent) {
        loginLabel.stringValue = "Log " + (loggedIn ? "Out" : "In")
        print("Entered")
    }
    
    override func mouseExited(with event: NSEvent) {
        loginLabel.stringValue = ""
        print("Exited")
    }
    
    override func viewWillAppear() {
        box.wantsLayer = true
        //box.layer?.backgroundColor = CGColor.init(red: 250.0/255.0, green: 251.0/255.0, blue: 252.0/255.0, alpha: 1.0)
    }
    @IBAction func pasteClipboard(_ sender: Any) {
        let paste = NSPasteboard.general
        if let contents = paste.string(forType: .string) {
        textField.string = contents
        }
    }
    
    func paste(content: String) {
        let paste = NSPasteboard.general
        paste.clearContents()
        paste.setString(content, forType: .string)
    }
    
    @IBAction func buttonPress(_ sender: NSButton) {
        print("?")
        loader.postGist(content: textField.string, name: "gist") { dict, error in
            if let error = error {
                switch error {
                case OAuth2Error.requestCancelled:
                    self.label?.stringValue = "Cancelled. Try Again."
                default:
                    self.label?.stringValue = "Failed. Try Again."
                }
            }
            else {
                if let htmlUrl = dict?["html_url"] as? String {
                    self.paste(content: htmlUrl)
                }
            }
        }
    }
    
    let OAuth2AppDidReceiveCallbackNotification = NSNotification.Name(rawValue: "OAuth2AppDidReceiveCallback")
    
    @IBAction func login(_ sender: NSButton?) {
        if self.loggedIn {
            self.loggedIn = false
            forgetTokens(sender)
            return
        }
        
        // show what is happening
        label?.stringValue = "Opening GitHub"
        loginButton?.isEnabled = false
        
        // config OAuth2
        loader.oauth2.authConfig.authorizeContext = view.window
        NotificationCenter.default.removeObserver(self, name: OAuth2AppDidReceiveCallbackNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRedirect(_:)), name: OAuth2AppDidReceiveCallbackNotification, object: nil)
        
        // load user data
        loader.requestUserdata() { dict, error in
            if let error = error {
                switch error {
                case OAuth2Error.requestCancelled:
                    self.label?.stringValue = "Cancelled. Try Again."
                default:
                    self.label?.stringValue = "Failed. Try Again."
                    self.show(error)
                }
            }
            else {
                if let imgURL = dict?["avatar_url"] as? String {
                    let url = URL(string: imgURL)
                    let data = try? Data(contentsOf: url!)
                    self.loginButton.image = NSImage(data: data!)
                }
                if let username = dict?["name"] as? String {
                    self.label?.stringValue = "\(username)"
                }
                else {
                    self.label?.stringValue = "Failed to fetch your name"
                    NSLog("Fetched: \(String(describing: dict))")
                }
                self.loggedIn = true
            }
            self.loginButton?.isEnabled = true
            self.label?.isHidden = false
        }
    }
    
    @IBAction func forgetTokens(_ sender: NSButton?) {
        label?.stringValue = "Logging out"
        loader.oauth2.forgetTokens()
        label?.stringValue = "Log In"
        loginButton.image = NSImage(named: NSImage.Name("GitHub-White"))
        label?.isHidden = false
    }
    
    // MARK: - Authorization
    
    @objc func handleRedirect(_ notification: Notification) {
        if let url = notification.object as? URL {
            label?.stringValue = "Loading"
            do {
                try loader.oauth2.handleRedirectURL(url)
            }
            catch let error {
                show(error)
            }
        }
        else {
            show(NSError(domain: NSCocoaErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid notification: did not contain a URL"]))
        }
    }
    
    // MARK: - Error Handling
    
    /** Forwards to `display(error:)`. */
    func show(_ error: Error) {
        if let error = error as? OAuth2Error {
            let err = NSError(domain: "OAuth2ErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: error.description])
            display(err)
        }
        else {
            display(error as NSError)
        }
    }
    
    /** Alert or log the given NSError. */
    func display(_ error: NSError) {
        if let window = self.view.window {
            NSAlert(error: error).beginSheetModal(for: window, completionHandler: nil)
            label?.stringValue = error.localizedDescription
        }
        else {
            NSLog("Error authorizing: \(error.description)")
        }
    }
}

extension GistViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> GistViewController {
        //todo remove magic names
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("GistViewController")

        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? GistViewController else {
            fatalError("Missing viewcontroller")
        }
        
        return viewcontroller
    }
}
