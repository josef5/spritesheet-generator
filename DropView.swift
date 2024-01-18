//
//  DropView.swift
//  DragAndDropTest
//
//  Created by Jose Espejo on 14/03/2017.
//  Copyright © 2017 Jose Espejo. All rights reserved.
//  http://stackoverflow.com/a/29233824/896907

import Cocoa
import AVFoundation

class DropView: NSView {
    
    var delegate: ViewController?
    
    let allowedFileTypes = ["mp4", "mov", "m4a"]
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        // Declare and register an array of accepted types
        registerForDraggedTypes([NSPasteboard.PasteboardType(kUTTypeFileURL as String),
                                 NSPasteboard.PasteboardType(kUTTypeItem as String)])
        
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        
        delegate?.videos.removeAll()
        
        return allowableUrls(inDrag: sender).count > 0 ? .link : []
        
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
        let urls = allowableUrls(inDrag: sender)
        
        for url in urls {
            
            let video = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first!
            print(video)
            delegate?.videos += [video]
            
        }
        
        delegate?.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "SheetSegue"), sender: self)
        
        return urls.count > 0
        
    }
    
    func extensionIsOk(url: URL) -> Bool {
        
        return allowedFileTypes.contains(url.pathExtension.lowercased())
        
    }
    
    func allowableUrls(inDrag draggingInfo: NSDraggingInfo) -> [URL] {
        
        var urls = [URL]()
        
        if let pasteboard = draggingInfo.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray {
            
            for path in pasteboard {
                
                let url = URL(fileURLWithPath: path as! String)
                
                if extensionIsOk(url: url) {
                    urls += [url]
                }
                
            }
            
        }
        
        return urls
        
    }
    
}
