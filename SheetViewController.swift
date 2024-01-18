//
//  SheetViewController.swift
//  SpritesheetUI
//
//  Created by Jose Espejo on 06/04/2018.
//  Copyright © 2018 Jose Espejo. All rights reserved.
//

import Cocoa
import AVFoundation

class SheetViewController: NSViewController {
    
    var videos = [AVAssetTrack]()
    /*var processesFinished = 0
    var processesFinishedSuccessfully = 0*/
    
    @IBOutlet weak var scrollView: NSScrollView!
    
    @IBAction func startButtonPressed(_ sender: NSButton) {
        
        checkInput()
        
        dismiss(sender)
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: NSButton) {
        
        videos = []
        
        dismiss(sender)
        
    }
    
    var videoDataViewControllers: [VideoDataViewController] {
        
        get {
            
            return childViewControllers.filter {
                $0 is VideoDataViewController
                } as! [VideoDataViewController]
            
        }
        
    }
    
    var videoDataViews: [NSView] {
        
        get {
            
            return scrollView.documentView!.subviews.sorted(by: {
                $0.frame.origin.y < $1.frame.origin.y
            })
            
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(videos)
        
        loadVideoViews()
        
    }
    
    
    /// Load a view for each video to be processed
    func loadVideoViews() {
        
        for i in 0 ..< videos.count {
            
            loadVideoView(video: videos[i], i: i)
            
        }
        
        checkSoleVideoDataViewController()
        
    }
    
    
    /// Load a view from the nib
    ///
    /// - Parameters:
    ///   - video: A video asset
    ///   - i: index
    func loadVideoView(video: AVAssetTrack, i: Int) {
        
        let vdvc = VideoDataViewController(nibName: NSNib.Name(rawValue: "VideoDataView"), bundle: Bundle.main)
        
        vdvc.video = video
        addChildViewController(vdvc)
        
        vdvc.view.frame.origin.y = CGFloat(i) * vdvc.view.frame.height
        
        scrollView.documentView?.addSubview(vdvc.view)
        
        print(vdvc.view.bounds)
        
    }
    
    /// Reposition video data views (if one removed)
    func updateScrollView() {
        
        for i in 0 ..< videoDataViews.count {
            
            let vdv = videoDataViews[i]
            
            vdv.frame.origin.y = CGFloat(i) * vdv.frame.height
            
        }
        
    }
    
    
    /// Remove video data view controller and view
    ///
    /// - Parameter vdvc: Video data view controller
    func removeVideoDataViewController(vdvc: VideoDataViewController) {
        
        vdvc.view.removeFromSuperview()
        vdvc.removeFromParentViewController()
        
        updateScrollView()
        
        checkSoleVideoDataViewController()
        
    }
    
    
    /// Disable remove button if video data view is the last one
    /// Ensures scrollview cannot be empty
    func checkSoleVideoDataViewController() {
        
        if videoDataViewControllers.count == 1 {
            videoDataViewControllers.first!.setRemoveButtonVisible(false)
        }
        
    }
    
    
    /// Check for errors in input fields
    func checkInput() {
        
        var hasError = false
        
        for vdvc in videoDataViewControllers {
            
            if vdvc.hasError == true {
                hasError = true
            }
            
        }
        
        if !hasError {
            
            startProcessing()
            
        } else {
            
            let alert = NSAlert()
            alert.messageText = "Some errors were found in the input data"
            alert.informativeText = "Errors are marked in red"
            alert.alertStyle = .warning
            
            alert.runModal()
            
        }
        
    }
    
    /// Launch output window and run the spritesheet script on each video
    func startProcessing() {
        
        let rootViewController = (presenting as! ViewController)
        
        rootViewController.processesFinished = 0
        rootViewController.processesFinishedSuccessfully = 0
        rootViewController.processesStarted = videoDataViewControllers.count
        rootViewController.progressIndictator.startAnimation(self)
        
        if (rootViewController.outputViewController?.view.window == nil) {
            
            performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "OutputSegue"), sender: presenting)
            
        }
        
        for vdvc in videoDataViewControllers {
            
            let process = SpriteSheetProcess(videoData: vdvc.videoData)
            process.delegate = rootViewController
            process.outputDelegate = rootViewController.outputViewController
            
            process.start()
            
        }
        
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
     
        // Set reference to output view controller in root view controller
        (presenting as! ViewController).outputViewController = segue.destinationController as! OutputViewController
        
    }
    
    /// Delegate method called by the Process when finished.
    /// Counts finished processes and successfully finished processes and displays an alert when all complete
    ///
    /// - Parameter status: Process's termination status
    /*func processFinished(withStatus status: Int32) {
     
        print("Process finished with status: \(status)")
        
        processesFinished += 1
        
        if status == 0 {
            processesFinishedSuccessfully += 1
        }
        
        if processesFinished == videoDataViewControllers.count {
            
            DispatchQueue.main.async {
                
                let alert = NSAlert()
                alert.messageText = "Spritesheet generation finished"
                alert.informativeText = "\(self.processesFinishedSuccessfully)/\(self.processesFinished) process\(self.processesFinished > 1 ? "es" : "") finished succesfully"
                alert.alertStyle = .informational//.warning
                
                alert.runModal()
                
            }
            
        }
        
    }*/

}
