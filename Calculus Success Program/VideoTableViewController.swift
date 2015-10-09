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
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if segue.identifier == "showVideo"{
            if let destination = segue.destinationViewController as? VideoViewController {
                let videoIndex = tableView.indexPathForSelectedRow
                if let section = videoIndex?.section,
                    let row = videoIndex?.row {
                        if let videoURL = videos[section][row].url {
                            destination.videoURL = videoURL
                        }
                }
            }
        }
    }
    

}
