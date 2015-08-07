//
//  Video.swift
//  Calculus Success Program
//
//  Created by Guillermo on 8/5/15.
//  Copyright (c) 2015 guillermo. All rights reserved.
//

import Foundation



class Video {
    
    private let baseURLString = "http://79.170.44.125/calcsuccess.com/calcvideos/"
    
    let title:String
    let chapter:String
    let section:String
    let path:String
    let fileName:String
    let url:NSURL?
    //  var quality:String
    var description:String {
        return title
    }
    
    init() {
        self.title = ""
        self.chapter = ""
        self.section = ""
        self.fileName = ""
        self.path = ""
        self.url = NSURL(string: "")
    }
    
    init(title: String?,chapter:String?, section: String?, path: String?, fileName: String?) {
        self.title = title ?? ""
        self.chapter = chapter ?? ""
        self.section = section ?? ""
        self.fileName = fileName ?? ""
        if let path = path {
            self.path = baseURLString + path
            self.url = NSURL(string: self.path + self.fileName)!
        } else {
            self.path = ""
            self.url = NSURL(string: "")
        }
    }
}