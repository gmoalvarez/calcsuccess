//
//  SettingsTableViewController.swift
//  Calculus Success Program
//
//  Created by Guillermo on 8/31/15.
//  Copyright (c) 2015 gmoalvarez. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    let ratingsAddress = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1030043040&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
    
    @IBOutlet weak var watchInHD: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let watchHD = NSUserDefaults.standardUserDefaults().boolForKey("watchInHD")
        if watchHD {
            self.watchInHD.setOn(true, animated: true)
        } else {
            self.watchInHD.setOn(false, animated: true)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleQuality(sender: UISwitch) {
        if (sender == self.watchInHD) {
            if self.watchInHD.on {
                self.watchInHD.setOn(true, animated: true)
            } else {
                self.watchInHD.setOn(false, animated: true)
            }
            NSUserDefaults.standardUserDefaults().setBool(self.watchInHD.on, forKey: "watchInHD")
        }
        
    }
    
    @IBAction func rateApp(sender: UIButton) {
        guard let ratingsURL = NSURL(string: ratingsAddress) else {
            print("Error: URL not found")
            return
        }
        UIApplication.sharedApplication().openURL(ratingsURL)
        
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
