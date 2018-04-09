//
//  LinksViewController.swift
//  Gist
//
//  Created by Tristen Miller on 2/6/18.
//  Copyright © 2018 Tristen Miller. All rights reserved.
//
import Cocoa

class LinksViewController: NSViewController {
    @IBOutlet var box: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        
    }

    override func viewWillAppear() {
        box.layer?.backgroundColor = NSColor.blue.cgColor
        //box.layer?.setNeedsDisplay()
    }
}
