//
//  PopoverView.swift
//  Gist
//
//  Created by Tristen Miller on 1/29/18.
//  Copyright © 2018 Tristen Miller. All rights reserved.
//

import Cocoa

class PopoverView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func viewDidMoveToWindow() {
        
        guard let frameView = window?.contentView?.superview else {
            return
        }
        
        let backgroundView = NSView(frame: frameView.bounds)
        backgroundView.wantsLayer = true
        let color = CGColor.init(red: 36.0 / 255.0, green: 41.0 / 255.0, blue: 46.0 / 255.0, alpha: 1.0)
        backgroundView.layer?.backgroundColor = color
        backgroundView.layer?.borderColor = color
        backgroundView.autoresizingMask = [.width, .height]
        
        frameView.addSubview(backgroundView, positioned: .below, relativeTo: frameView)
        
    }
}
