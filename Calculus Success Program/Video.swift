//
//  Video.swift
//  Calculus Success Program
//
//  Created by Guillermo on 8/5/15.
//  Copyright (c) 2015 guillermo. All rights reserved.
//

import Foundation

struct Video {
    var title:String?
    var chapter:String?
    var section:String?
    var path:String?
    var url:NSURL?
    //  var quality:String
    var description:String? {
        return title
    }
}