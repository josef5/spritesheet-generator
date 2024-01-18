//
//  ViewController.swift
//  SpritesheetUI
//
//  Created by Jose Espejo on 04/04/2018.
//  Copyright © 2018 Jose Espejo. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController, SpriteSheetProcessDelegate {
    
    var videos = [AVAssetTrack]()
    var processesStarted = 0
    var processesFinished = 0
    var processesFinishedSuccessfully = 0
    
    weak var outputViewController: OutputViewController!
    @IBOutlet weak var dropView: DropView!
    @IBOutlet weak var progressIndictator: NSProgressIndicator!
    
    @IBAction func browseFile(sender: AnyObject) {
        
        videos.removeAll()
        
        let openPanel = NSOpenPanel();
        
        openPanel.title                   = "Choose a video file"
        openPanel.showsResizeIndicator    = true
        openPanel.showsHiddenFiles        = false
        openPanel.canChooseDirectories    = true
        openPanel.canCreateDirectories    = true
        openPanel.allowsMultipleSelection = true
        openPanel.allowedFileTypes        = ["mov", "mp4"]
        
        if (openPanel.runModal() == NSApplication.ModalResponse.OK) {
            
            guard openPanel.urls.first != nil, AVURLAsset(url: openPanel.urls.first!).tracks(withMediaType: AVMediaType.video).first != nil else {
                
                let alert = NSAlert()
                alert.messageText = "No video file was selected"
                alert.informativeText = "Select a video file and try again"
                alert.alertStyle = .warning
                
                alert.runModal()
                
                return
                
            }
            
            for url in openPanel.urls {
                
                let video = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first!
                
                self.videos += [video]
                
            }
            
            //progressIndictator.startAnimation(self)
            
            self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "SheetSegue"), sender: self)
            
        } else {
            
            // User clicked on "Cancel"
            return
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dropView.delegate = self
        
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == NSStoryboardSegue.Identifier(rawValue: "SheetSegue")) {
            
            let svc = segue.destinationController as! SheetViewController
            
            svc.videos = videos
            
        }
        
    }

    /// Delegate method called by the Process when finished.
    /// Counts finished processes and successfully finished processes and displays an alert when all complete
    ///
    /// - Parameter status: Process's termination status
    func processFinished(withStatus status: Int32) {
        
        print("Process finished with status: \(status)")
        
        processesFinished += 1
        
        if status == 0 {
            processesFinishedSuccessfully += 1
        }
        
        if processesFinished == processesStarted {
         
            DispatchQueue.main.async {
                
                self.progressIndictator.stopAnimation(self)
                
                let alert = NSAlert()
                alert.messageText = "Spritesheet generation finished"
                alert.informativeText = "\(self.processesFinishedSuccessfully)/\(self.processesFinished) process\(self.processesFinished > 1 ? "es" : "") finished succesfully"
                alert.alertStyle = .informational//.warning
                
                alert.runModal()
                
            }
            
        }
        
    }


}

