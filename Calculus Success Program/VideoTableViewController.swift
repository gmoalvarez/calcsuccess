//
//  VideoTableViewController.swift
//  
//
//  Created by Guillermo on 8/5/15.
//
//

import UIKit
import Alamofire

class VideoTableViewController: UITableViewController {
    
    var currentChapter = "0" //Initialized to 0 but set to 1-6 when segue occurs
    var videos = [[Video]]() 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 30
        loadTable()
    }
    
    private func loadTable() {
        //Process json file and iterate through all of the videos
        //For every video, initialize a Video
        //Add the video to the videos 2D array model
        VideoListManager.getVideoNameAndURLWithSuccess { (data) -> Void in
            let parsedObject:AnyObject?
            do {
                parsedObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            } catch let error as NSError {
                let parseError:NSError? = error
                print(parseError)
                parsedObject = nil
            } catch {
                fatalError()
            }
            
            if let videoList = parsedObject as? [Dictionary<String,String>] {
                let videoListForChapter = videoList.filter {$0["chapter"] == self.currentChapter}
                let numberOfSections = self.findMaximumSection(videoListForChapter)
                self.videos = Array(count: numberOfSections,repeatedValue:[Video]())
                for video in videoListForChapter {
                    let title = video["title"]
                    let chapter = video["chapter"]
                    let section = video["section"]
                    let path = video["path"]
                    let fileName = video["fileName"]
                    let ext = video["extension"]
                    let quality = self.getQualityFromSettings()
                    let videotoAdd = Video(title: title, chapter: chapter, section: section, path: path, fileName: fileName,quality: quality, ext:ext)
                    let index = Int(section!)! - 1
                    self.videos[index].append(videotoAdd)
                }
            }
        
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    private func getQualityFromSettings() -> String {
        let watchInHD = NSUserDefaults.standardUserDefaults().boolForKey("watchInHD")
        return watchInHD == true ? "HD":"SD"
    }
    
    private func findMaximumSection( dict: Array<[String : String]>) -> Int{
        var currentMax = 0
        for entry in dict {
            let currentSection = Int(entry["section"]!)
            if let currentSection = currentSection {
                if currentSection > currentMax {
                    currentMax = currentSection
                }
            }
        }
        return currentMax
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return videos.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos[section].count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoCell", forIndexPath: indexPath) as! TableViewCell
        
        let currentVideo = videos[indexPath.section][indexPath.row]

        cell.downloadButton.hidden = false
        cell.progressView.hidden = false
        cell.activityIndicator.hidden = true
        
        if currentVideo.downloadStatus.isDownloading {
            cell.progressView.progress = currentVideo.downloadStatus.downloadProgress
        } else if currentVideo.downloadStatus.isSaved {
            if let image = UIImage(contentsOfFile: "Checkmark-32.png") {
                cell.downloadButton.imageView?.image = image
            }
        }
        
        cell.video = currentVideo

        return cell
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return nil
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section > videos.count {
            return nil
        }
        return videos[section].first?.title
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        //Code to save Video to Documents directory goes here
        let currentVideo = videos[indexPath.section][indexPath.row]

        guard !currentVideo.downloadStatus.isSaved else {
            print("Video is already saved")
            return
        }
        
        guard let url = currentVideo.url else {
            print("Video not found...url is invalid")
            return
        }
        
        let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        
        Alamofire.download(.GET, url, destination: destination)
        .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
            let progress = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
//            print(progress)
            currentVideo.downloadStatus.isDownloading = true
            currentVideo.downloadStatus.downloadProgress = progress
            self.updateProgressBar(progress)
        }.response { _,_,_, error in
            if let error = error {
                print("Failed with error: \(error)")
            } else {
                print("Downloaded file successfully")
                currentVideo.downloadStatus.isDownloading = false
                currentVideo.downloadStatus.isSaved = true
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.tableView.reloadData()
//                }
            }
            print("Files currently in the documents directory:")
            self.printDocumentsDirectoryContents()
        }
        
    }
    
    func updateProgressBar(progress: Float) {
        let progressTruncated = Int(progress * 10000.0)
        
        if progressTruncated % 50 == 0 || progress < 0.005 {
            print(progressTruncated)
            print(progress)
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    func printDocumentsDirectoryContents() {
        let manager = NSFileManager.defaultManager()
        let documentsURL = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        do {
            let directoryContents = try manager.contentsOfDirectoryAtURL(documentsURL,
                includingPropertiesForKeys: nil,
                options: NSDirectoryEnumerationOptions())
            print(directoryContents)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        guard segue.identifier == "showVideo" else {
            print("segue identifier is not showVideo")
            return
        }
        
        guard let destination = segue.destinationViewController as? VideoViewController else {
            print("destination is not VideoViewController")
            return
        }
        
        guard let videoIndex = tableView.indexPathForSelectedRow else {
            print("couldn't get video Index")
            return
        }
        
        let section = videoIndex.section
        let row = videoIndex.row
        let currentVideo = videos[section][row]
        //TODO: - check if file is stored locally
        let videoURL = getUrlOfVideo(currentVideo)
        
//        guard let videoURL = videos[section][row].url else {
//            print("No URL for some reason")
//            return
//        }
        
        destination.videoURL = videoURL
        
    }
    
    func getUrlOfVideo(video: Video) -> NSURL{
        if video.downloadStatus.isSaved {
            let manager = NSFileManager.defaultManager()
            let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
            var fileName:String
            if getQualityFromSettings() == "HD" {
                fileName = video.fileName+"-HD"
            } else {
                fileName = video.fileName
            }
            let filePath = documents+"/"+fileName+"."+video.ext
            let filePathURL = NSURL(fileURLWithPath: filePath,isDirectory: false)
            print(filePath)
            return filePathURL

        }
        return video.url!
    }
    
    
}
