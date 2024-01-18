//
//  Config.swift
//  SpritesheetUI
//
//  Created by Jose Espejo on 13/04/2018.
//  Copyright © 2018 Jose Espejo. All rights reserved.
//

import Foundation

struct Config {
    
    var fps = 8
    var tiles = "5x5"
    var jpegQuality = 44
    
    init(videoDimensions: CGSize) {
        
        setVars(dimensions: videoDimensions)
        
    }
    
    mutating func setVars(dimensions: CGSize) {
        
        switch (dimensions) {
        case CGSize(width: 160, height: 600):
            fps = 20
            tiles = "30x1"
            jpegQuality = 44
        case CGSize(width: 300, height: 50),
             CGSize(width: 320, height: 50):
            fps = 25
            tiles = "10x16"
            jpegQuality = 60
        case CGSize(width: 300, height: 250):
            fps = 25
            tiles = "10x4"
            jpegQuality = 44
        case CGSize(width: 300, height: 600):
            fps = 8
            tiles = "16x1"
            jpegQuality = 44
        case CGSize(width: 728, height: 90):
            fps = 25
            tiles = "2x20"
            jpegQuality = 44
        case CGSize(width: 970, height: 250):
            fps = 8
            tiles = "1x12"
            jpegQuality = 44
        default:
            fps = 25
            tiles = "5x5"
            jpegQuality = 44
        }
        
    }
    
}
