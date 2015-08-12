//
//  ChapterTableViewCell.swift
//  Calculus Success Program
//
//  Created by Guillermo on 8/7/15.
//  Copyright (c) 2015 gmoalvarez. All rights reserved.
//

import UIKit

class ChapterTableViewCell: UITableViewCell {

    @IBOutlet weak var chapterCellLabel: UILabel!
    
    

    var chapter: String? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        chapterCellLabel.numberOfLines = 0
        if let chapter = chapter {
            chapterCellLabel.text = chapter
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
