//
//  VideoTableViewController.swift
//  
//
//  Created by Guillermo on 8/5/15.
//
//

import UIKit

class VideoTableViewController: UITableViewController {

    
    //Create simple videos to show on Table View
    private let baseURL = NSURL(string: "http://79.170.44.125/calcsuccess.com/calcvideos/")
    
    var currentChapter = "0" //Initialized to 0 but set to 1-6 when segue occurs
    var videos = [[Video]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTable()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadTable() {
        //Process json file and iterate through all of the videos
        //For every video, initialize a Video
        //Add the video to the videos array in section 1
        VideoListManager.getVideoNameAndURLWithSuccess { (data) -> Void in
            var parseError: NSError?
            let parsedObject:AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
            if let videoList = parsedObject as? [Dictionary<String,String>] {
                let videoListForChapter = videoList.filter {$0["chapter"] == self.currentChapter}
                let numberOfSections = self.findMaximumSection(videoListForChapter)
//                let numberOfSections = videoList.last?["section"]?.toInt() ?? 1
                let numberOfVideos = videoListForChapter.count
                self.videos = Array(count: numberOfSections,repeatedValue:[Video]())
                for video in videoListForChapter {
                    let title = video["title"]
                    let chapter = video["chapter"]
                    let section = video["section"]
                    let path = video["path"]
                    let fileName = video["fileName"]
                    let videotoAdd = Video(title: title, chapter: chapter, section: section, path: path, fileName: fileName)
                    let index = section!.toInt()! - 1
                    self.videos[index].append(videotoAdd)
                }
            }
        
            dispatch_async(dispatch_get_main_queue()) {
                if NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 {
                    self.tableView.estimatedRowHeight = self.tableView.rowHeight
                    self.tableView.rowHeight = UITableViewAutomaticDimension
                }
                self.tableView.reloadData()
            }
        }
        
    }
    
    private func findMaximumSection( dict: Array<[String : String]>) -> Int{
        var currentMax = 0
        for entry in dict {
            var currentSection = entry["section"]?.toInt()
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
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return videos.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return videos[section].count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoCell", forIndexPath: indexPath) as! TableViewCell

        cell.video = videos[indexPath.section][indexPath.row]

        return cell
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
//        var sections = [String]()
//        for video in videos {
//            if let firstVideo = video.first {
//                sections.append(firstVideo.section)
//            }
//        }
        return nil
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section > videos.count {
            return nil
        }
        return videos[section].first?.title
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if segue.identifier == "showVideo"{
            if let destination = segue.destinationViewController as? VideoViewController {
                let videoIndex = tableView.indexPathForSelectedRow()
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
