//
//  DoubleMovieCellClass.swift
//  Filmr
//
//  Created by Usman Amjed on 5/15/15.
//  Copyright (c) 2015 Usman Amjed. All rights reserved.
//

import UIKit

var touchPosition:CGFloat = 0

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
    
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        let touch = touches.first as! UITouch
//        let location = touch.locationInView(self)
//        var xcoord = location.x
//        touchPosition = xcoord
//        
//    }

}
