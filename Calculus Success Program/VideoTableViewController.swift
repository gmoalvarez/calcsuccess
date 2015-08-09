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
        println(currentChapter)
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
                self.videos.append(Array(count: videoList.count,repeatedValue:Video()))
//                for (index,video) in enumerate(videoList) {
//                    let title = video["title"] as! String
//                    let chapter = video["chapter"] as! String
//                    let section = video["section"] as! String
//                    let path = video["path"] as! String
//                    let fileName = video["fileName"] as! String
//                    self.videos[0][index] = Video(title: title, chapter: chapter, section: section, path: path, fileName: fileName)
//                }
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
