//
//  DoubleMovieCellClass.swift
//  Filmr
//
//  Created by Usman Amjed on 5/15/15.
//  Copyright (c) 2015 Usman Amjed. All rights reserved.
//

import UIKit

class DoubleMovieCellClass: UITableViewCell {

    @IBOutlet weak var leftMovieID: UILabel!
    @IBOutlet weak var rightMovieID: UILabel!
    @IBOutlet weak var leftMoviePoster: UIImageView!
    @IBOutlet weak var rightMoviePoster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
