//
//  ChapterTableViewController.swift
//  Calculus Success Program
//
//  Created by Guillermo on 8/7/15.
//  Copyright (c) 2015 gmoalvarez. All rights reserved.
//

import UIKit

class ChapterTableViewController: UITableViewController {

    let chapters = ["1":"Review of Functions and Trigonometry",
        "2":"Limits",
        "3":"Differentiation",
        "4":"Applications of Differentiation",
        "5":"Integration",
        "6":"Applications of Integration",
        "7":"Integration Techniques",
        "8":"More Applications of Integration",
        "9":"Sequences and Series"]
    let numberOfChapters = 9
    override func viewDidLoad() {
        super.viewDidLoad()
        let quality = NSUserDefaults.standardUserDefaults().objectForKey("watchInHD") as? Bool
        if quality == nil {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "watchInHD")
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return numberOfChapters
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chapterCell", forIndexPath: indexPath) as! ChapterTableViewCell
        let index = indexPath.row + 1
        cell.chapter = chapters["\(index)"]
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showChapter" {
            if let destination = segue.destinationViewController as? VideoTableViewController {
                let chapterIndex = tableView.indexPathForSelectedRow
                if let rowSelected = chapterIndex?.row {
                    let chapter = rowSelected + 1
                    destination.currentChapter = "\(chapter)"
                }
            }
        }
        
    }
    

}
