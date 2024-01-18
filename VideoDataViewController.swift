//
//  SubViewController.swift
//  ModalFromXib
//
//  Created by Jose Espejo on 13/11/2017.
//  Copyright © 2017 Jose Espejo. All rights reserved.
//

import Cocoa
import AVFoundation

class VideoDataViewController: NSViewController {
    
    @IBOutlet weak var videoNameLabel: NSTextField!
    @IBOutlet weak var videoDimensionsLabel: NSTextField!
    @IBOutlet weak var fpsTextField: NSTextField!
    @IBOutlet weak var jpegQualityTextField: NSTextField!
    @IBOutlet weak var tilesTextField: NSTextField!
    @IBOutlet weak var removeButton: NSButton!
    
    @IBAction func removeButtonPressed(_ sender: NSButton) {

        (self.parent as! SheetViewController).removeVideoDataViewController(vdvc: self)
        
    }
    
    var video: AVAssetTrack! {
        
        didSet {
            setup(withVideo: video)
        }
        
    }
    
    var videoData: VideoData {
        
        get {
            return VideoData(
                videoName: videoName,
                videoDimensions: videoDimensions,
                path: videoPath,
                fps: Int(fpsTextField.intValue),
                jpegQuality: Int(jpegQualityTextField.intValue),
                tiles: tilesTextField.stringValue
            )
        }
        
    }
    
    var hasError: Bool {
        
        get {
            
            return errorsFound()
            
        }
        
    }
    
    var videoName: String!
    var videoDimensions: CGSize!
    var videoPath: URL!
    
    private func setup(withVideo video: AVAssetTrack) {
        
        loadView()
        
        let asset = video.asset as! AVURLAsset
        videoPath = asset.url
        videoName = videoPath.lastPathComponent
        
        videoDimensions = video.naturalSize
        
        videoNameLabel.stringValue = videoName
        videoDimensionsLabel.stringValue = "\(Int(videoDimensions.width)) x \(Int(videoDimensions.height))"
        
        let defaultValues = Config(videoDimensions: videoDimensions)
        
        fpsTextField.stringValue = String(defaultValues.fps)
        jpegQualityTextField.stringValue = String(defaultValues.jpegQuality)
        tilesTextField.stringValue = String(defaultValues.tiles)
        
    }
    
    
    /// Check for errors in textfields
    ///
    /// - Returns: True if any errors found
    fileprivate func errorsFound() -> Bool {
        
        var errorFound = false
        
        if Int(fpsTextField.intValue) < 1 {
            
            errorFound = true
            markTextFieldError(textField: fpsTextField, markError: true)
            
        } else {
            
            markTextFieldError(textField: fpsTextField, markError: false)
            
        }
        
        if !(1...100 ~= Int(jpegQualityTextField.intValue)) {
            
            errorFound = true
            markTextFieldError(textField: jpegQualityTextField, markError: true)
            
        } else {
            
            markTextFieldError(textField: jpegQualityTextField, markError: false)
            
        }
        
        if tilesTextField.stringValue.count < 3 || tilesTextField.stringValue.split(separator: "x").count != 2 {
            
            errorFound = true
            markTextFieldError(textField: tilesTextField, markError: true)
            
        } else {
            
            markTextFieldError(textField: tilesTextField, markError: false)
            
        }
        
        return errorFound
        
    }
    
    
    /// Mark text field that has an error with a red border
    ///
    /// - Parameters:
    ///   - textField: textfield
    ///   - markError: Boolean, set or remove red border
    func markTextFieldError(textField: NSTextField, markError: Bool) {
        
        if markError {
            
            textField.wantsLayer = true
            textField.layer = CALayer()
            textField.layer?.borderWidth = 2
            textField.layer?.cornerRadius = 3
            textField.layer?.borderColor = NSColor.red.cgColor
            textField.layer?.backgroundColor = NSColor.white.cgColor
            
        } else {
            
            textField.wantsLayer = false
            textField.layer = nil
            
        }
        
    }
    
    
    /// Set visibility of remove button
    ///
    /// - Parameter visible: Visible if true
    func setRemoveButtonVisible(_ visible: Bool) {
        
        removeButton.isHidden = !visible
        
    }
    
}
