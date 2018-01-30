//
//  SwitchButton.swift
//  Gist
//
//  Created by Tristen Miller on 1/29/18.
//  Copyright © 2018 Tristen Miller. All rights reserved.
//

import Cocoa

class SwitchButton: BasicButton {

    override func setupButton() {
        self.attributedTitle = NSAttributedString(string: "Secret", attributes: [
            NSAttributedStringKey.foregroundColor : NSColor.white])
    }
    
}
