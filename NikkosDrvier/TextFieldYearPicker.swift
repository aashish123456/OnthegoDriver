//
//  TextFieldYearPicker.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 14/09/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit

class TextFieldYearPicker: UITextField ,UIPickerViewDelegate,UIPickerViewDataSource {
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    var pickerArray : NSMutableArray =  NSMutableArray()
    var pickrView : UIPickerView = UIPickerView()
    var yearArray : NSMutableArray = NSMutableArray()
    override func draw(_ rect: CGRect) {
        // Drawing code
//        let fieldBGImage = UIImage(named: "user_bg.png")!.stretchableImage(withLeftCapWidth: 20, topCapHeight: 22)
//        self.background = fieldBGImage
        
        
        /*let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 30, y: self.frame.size.height - width, width: self.frame.size.width-60, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true*/
    }
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        self.rightViewMode = UITextFieldViewMode.always;
        var bgImage : UIImageView?
        var image : UIImage?
        image = UIImage(named:"icon_arrow" )
        bgImage = UIImageView(image: image)
        bgImage!.contentMode = UIViewContentMode.center
        bgImage!.frame = CGRect(x: 0,y: 0,width: 8+20,height: 5)
        self.rightView = bgImage
        
        setToolbarWithPickerOnTextfield()
       
        let date = Date()
        let calendar = Calendar.autoupdatingCurrent
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
        let year =  components.year
        print(year)
        
        
        
        var i = year
        var value = year! - 100
        while i! > value {
            yearArray .add(i as Any)
            //i - = 1
            i = i!-1
        }
        
//        for var i=1950; i<year; i++{
//           yearArray[i] = i + 1
//        }
       
        
    
        self.reloadPickerWithArray(yearArray)
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
    
    /*
     override func textRectForBounds(bounds: CGRect) -> CGRect {
     return CGRectMake(bounds.origin.x + 5, bounds.origin.y + 8, bounds.size.width - 30, bounds.size.height - 16);
     }
     
     override func editingRectForBounds(bounds: CGRect) -> CGRect {
     return self.textRectForBounds(bounds);
     }
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let value = String(format: "%@", pickerArray[row] as! CVarArg)
        self.text = value
        return value
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let value = String(format: "%@", pickerArray[row] as! CVarArg)
        self.text  = value
    }
    
    func doneButtonPressed() {
        self.resignFirstResponder()
    }
    
    func setToolbarWithPickerOnTextfield()  {
        let toolbar : UIToolbar  = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        let flexibleSpaceLeft : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton : UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItemStyle.done,target: self,action: #selector(TextfieldPicker.doneButtonPressed))
        let picker : UIPickerView = UIPickerView()
        self.inputView = picker
        picker.delegate = self
        picker.dataSource = self
        picker.tag = tag
        self.inputView = picker
        
        var items = [UIBarButtonItem]()
        items.append(flexibleSpaceLeft)
        items.append(doneButton)
        toolbar.items = items
        self.inputAccessoryView = toolbar
    }
    
    func reloadPickerWithArray(_ arr:NSMutableArray)  {
        pickerArray = arr
        pickrView.reloadAllComponents()
    }
    
    
}
