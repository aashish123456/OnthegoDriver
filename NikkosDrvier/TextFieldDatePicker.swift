//
//  TextFieldDatePicker.swift
//  MoodTracking
//
//  Created by Pulkit on 06/05/16.
//  Copyright © 2016 Vinod Sahu. All rights reserved.
//

import UIKit

class TextFieldDatePicker: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    let datePicker : UIDatePicker = UIDatePicker()
    var type : String?
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.rightViewMode = UITextFieldViewMode.always;
        var bgImage : UIImageView?
        var image : UIImage?
        image = UIImage(named:"calender" )
        bgImage = UIImageView(image: image)
        bgImage!.contentMode = UIViewContentMode.center
        bgImage!.frame = CGRect(x: 0,y: 0,width: 10+20,height: 11)
        self.rightView = bgImage
        
        datePicker.maximumDate = Date()
        if type == "Time"{
            setToolbarWithTimePickerOnTextfield()
        }else{
            setToolbarWithDatePickerOnTextfield()
        }
        
    }
    override func draw(_ rect: CGRect) {
        // Drawing code
//        let fieldBGImage = UIImage(named: "user_bg.png")!.stretchableImage(withLeftCapWidth: 20, topCapHeight: 22)
//        self.background = fieldBGImage
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 5, y: bounds.origin.y + 8, width: bounds.size.width - 30, height: bounds.size.height - 16);
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds);
    }
    
    func doneButtonPressed() {
        if  type == "Time"{
            let dateformatter = DateFormatter ()
            dateformatter.dateFormat = "hh:mm a"
            let DateInFormat = dateformatter.string(from: datePicker.date)
            self.text = DateInFormat
        }else{
            let dateformatter = DateFormatter ()
            
            if UserDefaults.standard.value(forKey: "Date_Format") as? String == "Month/Day/Year" {
                dateformatter.dateFormat = "MMM-dd-yyyy"
            }else{
                dateformatter.dateFormat = "dd-MMM-yyyy"
            }
            let DateInFormat = dateformatter.string(from: datePicker.date)
            self.text = DateInFormat
        }
        self.resignFirstResponder()
    }
    
    func setToolbarWithDatePickerOnTextfield() {
        let toolbar : UIToolbar  = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        let flexibleSpaceLeft : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton : UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(TextFieldDatePicker.doneButtonPressed))
        self.inputView = datePicker
        datePicker.datePickerMode = UIDatePickerMode.date

        var items = [UIBarButtonItem]()
        items.append(flexibleSpaceLeft)
        items.append(doneButton)
        toolbar.items = items
        self.inputAccessoryView = toolbar
    }
    
    func setToolbarWithTimePickerOnTextfield() {
        let toolbar : UIToolbar  = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        let flexibleSpaceLeft : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton : UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(TextFieldDatePicker.doneButtonPressed))
        self.inputView = datePicker
        datePicker.datePickerMode = UIDatePickerMode.time

        var items = [UIBarButtonItem]()
        items.append(flexibleSpaceLeft)
        items.append(doneButton)
        toolbar.items = items
        self.inputAccessoryView = toolbar
    }
    

}
