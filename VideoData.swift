//
//  VideoData.swift
//  SpritesheetUI
//
//  Created by Jose Espejo on 03/05/2018.
//  Copyright © 2018 Jose Espejo. All rights reserved.
//

import Foundation

struct VideoData {
    
    var videoName: String!
    var videoDimensions: CGSize!
    var path: URL!
    var fps: Int!
    var jpegQuality: Int!
    var tiles: String!
    
    var directory: URL! {
        
        get {
            return path.deletingLastPathComponent()
        }
        
    }
    
}
