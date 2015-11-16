//
//  DownloadStatus.swift
//  Calculus Success Program
//
//  Created by Guillermo on 11/16/15.
//  Copyright © 2015 gmoalvarez. All rights reserved.
//

import Foundation

class DownloadStatus {
    
    var isSaved = false
    var isDownloading = false
    var downloadProgress:Float = 0.0
    var localURL:NSURL?
}