//
//  VideoTableViewController.swift
//  
//
//  Created by Guillermo on 8/5/15.
//
//

import UIKit

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

        cell.video = videos[indexPath.section][indexPath.row]

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

        guard let url = currentVideo.url else {
            print("Video not found...url is invalid")
            return
        }
        
        let urlRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(urlRequest,
               queue: NSOperationQueue.mainQueue() ) { (response, data, error) -> Void in
               
//                guard error != nil  else {
//                    print("There was an error \(error)")
//                    return
//                }
//                This part takes a long time. Maybe I should use multithreading here
                guard let videoFile = data else {
                    print("There was no video file found")
                    return
                }
                
                let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                let fileName = currentVideo.fileName + "." + currentVideo.ext
                let writePath = documents.stringByAppendingString("/"+fileName)
                NSFileManager.defaultManager().createFileAtPath(writePath, contents: videoFile, attributes: nil)
//                let readPath = documents.stringByAppendingString("/"+fileName)
//                let fileExists = NSFileManager.defaultManager().fileExistsAtPath(readPath)
//                print("Does the file exist? The answer is \(fileExists)")
                self.printDocuments()
        }
    }
    
    func printDocuments() {
        //http://stackoverflow.com/questions/27721418/ios-swift-getting-list-of-files-in-documents-folder
        // We need just to get the documents folder url
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        // now lets get the directory contents (including folders)
        do {
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsUrl, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
            print(directoryContents)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        // if you want to filter the directory contents you can do like this:
        
        
//        do {
//            let directoryUrls = try  NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsUrl, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
//            print(directoryUrls)
//            let mp3Files = directoryUrls.filter(){ $0.pathExtension == "mp3" }.map{ $0.lastPathComponent }
//            print("MP3 FILES:\n" + mp3Files.description)
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
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
        
        //check if file is stored locally
        
        
        guard let videoURL = videos[section][row].url else {
            print("No URL for some reason")
            return
        }
        
        destination.videoURL = videoURL
        
    }
    

}
