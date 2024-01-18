//
//  OutputViewController.swift
//  SpritesheetUI
//
//  Created by Jose Espejo on 03/05/2018.
//  Copyright © 2018 Jose Espejo. All rights reserved.
//

import Cocoa

class OutputViewController: NSViewController, NSWindowDelegate, SpriteSheetProcessOutputDelegate {
    
    @IBOutlet var outputTextView: NSTextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        outputTextView.font = NSFont(name: "Menlo", size: 11.0)
        
    }
    
    /// Print text to the output text view
    ///
    /// - Parameter text: Any string
    func addText(_ text: String) {
        
        DispatchQueue.main.async {
            
            self.outputTextView.string += text
            let range = NSRange(location:self.outputTextView.string.count,length:0)
            self.outputTextView.scrollRangeToVisible(range)
            
        }
        
    }
    
}
