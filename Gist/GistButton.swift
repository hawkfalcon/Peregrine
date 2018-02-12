//
//  GistButton.swift
//  Gist
//
//  Created by Tristen Miller on 1/29/18.
//  Copyright © 2018 Tristen Miller. All rights reserved.
//

import Cocoa

class GistButton: BasicButton {
    
    override func setupButton() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        let attributes: [NSAttributedStringKey : Any] = [.foregroundColor: NSColor.white, .font: NSFont.systemFont(ofSize: 24), .paragraphStyle: paragraphStyle]
        self.attributedTitle = NSMutableAttributedString(string: self.title, attributes: attributes)        //self.layer?.cornerRadius = 6
        //self.layer?.backgroundColor = .init(red: 90.0 / 255.0, green: 94.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0)
        //self.image = tintedImage(self.image!, tint: .red)
    }

}
