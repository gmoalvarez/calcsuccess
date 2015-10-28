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
    
    var video: Video? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        videoTitleLabel.text = video?.title
        if let progress = video?.downloadProgress {
            progressView.progress = progress
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
