//
//  InfoView.swift
//  NikkosDriver
//
//  Created by Ashish Soni on 24/11/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit

class InfoView: UIView {

    @IBOutlet var popupInside: UIView!
    
    
    internal func showInView(_ aView: UIView!)
    {
        popupInside.layer.cornerRadius = 12.0
        aView.addSubview(self)
        self.showAnimate()
    }
    
    
    
    func showAnimate()
    {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.removeFromSuperview()
                }
        });
    }


}
