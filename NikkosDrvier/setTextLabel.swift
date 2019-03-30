//
//  setTextLabel.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 14/09/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit

class setTextLabel: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        self.numberOfLines = 1
        self.adjustsFontSizeToFitWidth = true
        // self.textAlignment = .Center

    }
    
    

}
