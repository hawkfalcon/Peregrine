//
//  GistViewController.swift
//  Gist
//
//  Created by Tristen Miller on 1/28/18.
//  Copyright © 2018 Tristen Miller. All rights reserved.
//

import Cocoa

let gistManager = GistManager()

class GistViewController: NSViewController {
    @IBAction func buttonPress(_ sender: NSButton) {
        let paste = NSPasteboard.general
        if let contents = paste.string(forType: .string) {
            gistManager.createGist(content: contents)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
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
