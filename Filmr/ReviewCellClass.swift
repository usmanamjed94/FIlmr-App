//
//  ReviewCellClass.swift
//  Filmr
//
//  Created by Usman Amjed on 5/20/15.
//  Copyright (c) 2015 Usman Amjed. All rights reserved.
//

import UIKit

class ReviewCellClass: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var reviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
