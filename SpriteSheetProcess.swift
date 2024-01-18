//
//  SpriteSheetProcess.swift
//  SpritesheetUI
//
//  Created by Jose Espejo on 03/05/2018.
//  Copyright © 2018 Jose Espejo. All rights reserved.
//

import Foundation

protocol SpriteSheetProcessOutputDelegate: AnyObject {
    
    func addText(_ text: String)
    
}

protocol SpriteSheetProcessDelegate: AnyObject {
    
    func processFinished(withStatus status: Int32)
    
}

/// Run shell script with parameters
class SpriteSheetProcess {
    
    var process: Process!
    var outputPipe:Pipe!
    
    var videoData: VideoData!
    
    var outputViewController: OutputViewController!
    
    weak var delegate: SpriteSheetProcessDelegate?
    weak var outputDelegate: SpriteSheetProcessOutputDelegate?
    
    init(videoData: VideoData) {
        
        self.videoData = videoData
        
    }
    
    func start() {
        
        let taskQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        
        taskQueue.async {
            
            self.process = Process()
            self.process.launchPath = Bundle.main.path(forResource: "SpriteSheetGenerator", ofType:"sh")
            self.process.arguments = [
                self.videoData.videoName,
                "\(Int(self.videoData.videoDimensions.width))x\(Int(self.videoData.videoDimensions.height))",
                self.videoData.directory.path,
                self.videoData.path.path,
                "\(self.videoData.fps!)",
                "\(self.videoData.jpegQuality!)",
                self.videoData.tiles
            ]
            
            self.outputPipe = Pipe()
            self.process.standardOutput = self.outputPipe
            
            self.outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: self.outputPipe.fileHandleForReading , queue: nil) {
                
                notification in
                
                let output = self.outputPipe.fileHandleForReading.availableData
                let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
                
                DispatchQueue.main.async(execute: {
                    
                    print(outputString)
                    
                    self.outputDelegate?.addText(outputString)
                    
                })
                
                self.outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
                
            }
            
            self.process.launch()
            
            self.waitUntilExit()
            
        }
        
    }
    
    
    /// When script process finished notify delegate
    func waitUntilExit() {
        
        //var del = delegate // Temporarily retain delegate reference
        
        process.waitUntilExit()
        
        let terminationStatus = process.terminationStatus
        
        if terminationStatus == 0 {
            outputDelegate?.addText("Task succeeded: \(videoData.videoName)")
        } else {
            outputDelegate?.addText("Task failed: \(videoData.videoName)")
        }
        
        delegate?.processFinished(withStatus: terminationStatus)
        
        //del = nil // release
        
    }
    
}
