//
//  VideoListManager.swift
//  Calculus Success Program
//
//  Created by Guillermo on 8/6/15.
//  Copyright (c) 2015 gmoalvarez. All rights reserved.
//

import Foundation

//Adapted from Ray Wenderlich online tutorial for how to extract data from Json file
class VideoListManager {
    
    class func getVideoNameAndURLWithSuccess(success: ((data: NSData) -> Void)) {
        //1
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //2
            let filePath = NSBundle.mainBundle().pathForResource("calc_video_list",ofType:"json")
            
            if let filePath = filePath {
                do {
                    let data = try NSData(contentsOfFile:filePath,options: NSDataReadingOptions.DataReadingUncached)
                    success(data: data)
                } catch let error as NSError {
                    let readError:NSError? = error
                    print(readError)
                } catch {
                    fatalError()
                }
            }
        })
    }
}
