//
//  TextFieldNumberPad.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 14/09/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit

class TextFieldNumberPad: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    
    func setToolbarOnTextfield(_ textField : UITextField)  {
        
        let toolbar : UIToolbar  = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        let flexibleSpaceLeft : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton : UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItemStyle.done,target: self,action: #selector(self.doneButtonPressed))
        
        
        var items = [UIBarButtonItem]()
        items.append(flexibleSpaceLeft)
        items.append(doneButton)
        toolbar.items = items
        textField.inputAccessoryView = toolbar
    }
    
    func doneButtonPressed() {
        self.resignFirstResponder()
    }
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        let fieldBGImage = UIImage(named: "user_bg.png")!.stretchableImage(withLeftCapWidth: 20, topCapHeight: 22)
        self.background = fieldBGImage
        self.setToolbarOnTextfield(self)
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
