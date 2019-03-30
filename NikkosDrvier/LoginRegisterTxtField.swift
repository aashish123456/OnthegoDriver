//
//  LoginRegisterTxtField.swift
//  NikkosDrvier
//
//  Created by Umang on 9/1/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit

class LoginRegisterTxtField: UITextField {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        //let fieldBGImage = UIImage(named: "user_bg.png")!.stretchableImage(withLeftCapWidth: 20, topCapHeight: 22)
        //self.background = fieldBGImage
        
//        let border = CALayer()
//        let width = CGFloat(1.0)
//        border.borderColor = UIColor.gray.cgColor
//        border.frame = CGRect(x: 30, y: self.frame.size.height - width, width: self.frame.size.width-60, height: self.frame.size.height)
//        
//        border.borderWidth = width
//        self.layer.addSublayer(border)
//        self.layer.masksToBounds = true
    }
 
    func setLeftImage(_ imageName: String)  {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 21))
        let image = UIImage(named:imageName);
        imageView.image = image;
        imageView.frame = imageView.frame.insetBy(dx: -10, dy: 0);
        imageView.contentMode = UIViewContentMode.center
        self.leftViewMode = UITextFieldViewMode.always
        self.leftView = imageView;
        
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect
    {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x  += 10
        return textRect
    }
    

}
