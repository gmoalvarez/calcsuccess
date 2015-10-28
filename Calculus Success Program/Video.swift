//
//  Video.swift
//  Calculus Success Program
//
//  Created by Guillermo on 8/5/15.
//  Copyright (c) 2015 guillermo. All rights reserved.
//

import Foundation



class Video:NSObject {
    
    private let baseURLString = "https://web197.secure-secure.co.uk/calcsuccess.org/calcvideos/"
    
    var title:String
    var chapter:String
    var section:String
    var path:String
    var fileName:String
    var ext:String
    var url:NSURL?
    var quality:String
    override var description:String {
        return title
    }
    var downloadProgress:Float?
    var downloading:Bool
    var saved:Bool
    
    override init() {
        self.title = ""
        self.chapter = ""
        self.section = ""
        self.fileName = ""
        self.ext = ""
        self.path = ""
        self.quality = ""
        self.url = NSURL(string: "")
        self.downloading = false
        self.saved = false
    }
    
    init(title: String?,
        chapter:String?,
        section: String?,
        path: String?,
        fileName: String?,
        quality: String?,
        ext:String?, downloading:Bool?,saved:Bool?) {
            
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
            self.downloading = downloading ?? false
            self.saved = saved ?? false
    }
    
    convenience init(title: String?,
    chapter:String?,
    section: String?,
    path: String?,
    fileName: String?,
    quality: String?,
        ext:String?) {
            
            self.init(title: title,chapter: chapter,section: section, path: path, fileName: fileName, quality: quality, ext: ext, downloading: false, saved: false)
    }
}