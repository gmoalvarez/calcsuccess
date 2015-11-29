//
//  TableViewCell.swift
//  Calculus Success Program
//
//  Created by Guillermo on 8/5/15.
//  Copyright (c) 2015 gmoalvarez. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var customAccessoryView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    var video: Video? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        guard let video = video else {
            print("eror: video should not be nil")
            return
        }
    
        videoTitleLabel.text = video.title
        if video.downloadStatus.isDownloading {
            progressView.hidden = false
            checkmarkImageView.hidden = true
            progressView.progress = video.downloadStatus.downloadProgress
            downloadButton.hidden = true
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
        } else {
            checkmarkImageView.hidden = true
            progressView.hidden = true
            activityIndicator.stopAnimating()
        }
        
        if video.downloadStatus.isSaved {
            activityIndicator.stopAnimating()
            progressView.hidden = true
            downloadButton.hidden = true
            checkmarkImageView.hidden = false
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
