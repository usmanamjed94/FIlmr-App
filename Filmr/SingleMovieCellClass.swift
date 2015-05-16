//
//  singleMovieCellClass.swift
//  Filmr
//
//  Created by Usman Amjed on 5/14/15.
//  Copyright (c) 2015 Usman Amjed. All rights reserved.
//

import UIKit

class SingleMovieCellClass: UITableViewCell {
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieId: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
