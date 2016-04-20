//
//  UILabelPadding.swift
//  Filmr
//
//  Created by Usman Amjed on 5/21/15.
//  Copyright (c) 2015 Usman Amjed. All rights reserved.
//

import UIKit

class UILabelPadding: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func drawTextInRect(rect: CGRect)
    {
        var insets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
        
    }
}
