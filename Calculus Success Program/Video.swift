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
    
    let title:String
    let chapter:String
    let section:String
    let path:String
    let fileName:String
    let ext:String
    let url:NSURL?
    let quality:String
    var downloadStatus:DownloadStatus
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
        self.downloadStatus = DownloadStatus()
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
        self.downloadStatus = DownloadStatus()
    }
    
    func getHDVideoURL() -> NSURL? {
        
        if self.quality == "HD" {
            return self.url
        }
        
        let urlString = self.path + self.fileName + "-HD" + "." + self.ext
        return NSURL(string: urlString)
    }
    
    func addSkipBackupAttributeToVideo(video: Video) -> Bool {
        //1. Get the documents directory
        let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        
        //2. Since all videos downloaded are in HD, the local filename ends with HD every time
        //   so we add HD to the file name
        let fileName = video.fileName+"-HD"
        
        //3. Get local file path and NSURL
        let filePath = documents+"/"+fileName+"."+video.ext
        let filePathURL = NSURL(fileURLWithPath: filePath,isDirectory: false)
        
        //4. Add key to not include in iCloud backup
        do {
            try filePathURL.setResourceValue(NSNumber(bool: true), forKey: NSURLIsExcludedFromBackupKey)
        } catch let error as NSError {
            print(error)
            return false
        } catch {
            fatalError()
        }
        
        return true

    }
}