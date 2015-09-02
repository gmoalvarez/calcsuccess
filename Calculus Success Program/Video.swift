//
//  Video.swift
//  Calculus Success Program
//
//  Created by Guillermo on 8/5/15.
//  Copyright (c) 2015 guillermo. All rights reserved.
//

import Foundation



class Video:NSObject {
    
    private let baseURLString = "http://www.calcsuccess.org/calcvideos/"
    
    let title:String
    let chapter:String
    let section:String
    let path:String
    let fileName:String
    let ext:String
    let url:NSURL?
    let quality:String
    override var description:String {
        return title
    }
    
    override init() {
        self.title = ""
        self.chapter = ""
        self.section = ""
        self.fileName = ""
        self.ext = ""
        self.path = ""
        self.quality = ""
        self.url = NSURL(string: "")
    }
    
    init(title: String?,chapter:String?, section: String?, path: String?, fileName: String?, quality: String?, ext:String?) {
        self.title = title ?? ""
        self.chapter = chapter ?? ""
        self.section = section ?? ""
        self.fileName = fileName ?? ""
        self.quality = quality ?? ""
        self.ext = ext ?? ""
        if let path = path {
            self.path = baseURLString + path
        } else {
            self.path = baseURLString
        }
        let url:String
        if quality == "HD" {
            url = self.path + self.fileName + "-HD" + "." + self.ext
        } else {
            url = self.path + self.fileName + "." + self.ext
        }
        self.url = NSURL(string: url)
    }
}
