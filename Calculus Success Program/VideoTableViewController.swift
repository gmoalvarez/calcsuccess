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
    private let baseURL = NSURL(string: "http://79.170.44.125/calcsuccess.com/calcvideos/chap2/")
    
    var videos = [[Video]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTable()
        if NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 {
            tableView.estimatedRowHeight = tableView.rowHeight
            tableView.rowHeight = UITableViewAutomaticDimension
        }
        self.tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadTable() {
        var video1 = Video()
        video1.title = "Limits - Evaluating Limits by Graphing mini lecture"
        video1.chapter = "2"
        video1.section = "1"
        video1.path = "\(baseURL!)2.1-1-Limits-Evaluating_Limits_by_Graphing_mini_lecture.mp4"
        video1.url = NSURL(string: video1.path!)
        
        var video2 = Video()
        video2.title = "Limits - Evaluating Limits by Graphing examples"
        video2.chapter = "2"
        video2.section = "1"
        video2.path = "\(baseURL!)2.1-2-Limits-Evaluating_Limits_by_Graphing_examples.mp4"
        video2.url = NSURL(string: video2.path!, relativeToURL: baseURL)
        
        var video3 = Video()
        video3.title = "Limits - Continuity mini lecture"
        video3.chapter = "2"
        video3.section = "1"
        video3.path = "\(baseURL!)2.2-2-Continuity_Video_Exercises.mp4"
        video3.url = NSURL(string: video3.path!, relativeToURL: baseURL)
        
        videos = [[video1,video2],[video3]]
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
