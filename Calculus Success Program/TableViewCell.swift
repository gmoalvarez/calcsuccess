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
    
    var video: Video? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        videoTitleLabel.text = video?.title
        progressView.progress = (video?.downloadStatus.downloadProgress)!
        if progressView.progress == 1.0 ||
        progressView.progress == 0.0 {
            progressView.hidden = true
        } else {
            progressView.hidden = false
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
