//
//  TextfieldPicker.swift
//  MoodTracking
//
//  Created by Pulkit on 06/05/16.
//  Copyright © 2016 Vinod Sahu. All rights reserved.
//

import UIKit

@objc protocol TextFieldPickerDelegate : NSObjectProtocol{
    //optional func parmaTypeTextFieldDidClickedOnCancleButton(textField: UITextField!)
    @objc optional func textField(_ textField: UITextField!, didClickedOnDoneButtonWith selectedValue: String)
    
    
}

class TextfieldPicker: UITextField,UIPickerViewDelegate,UIPickerViewDataSource {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    var pickerArray : NSMutableArray =  NSMutableArray()
    var pickerArrayWithCountory : NSMutableArray =  NSMutableArray()
    var pickrView : UIPickerView = UIPickerView()
    var delegateTextField : TextFieldPickerDelegate?
    
    override func draw(_ rect: CGRect) {
        // Drawing code
//        let fieldBGImage = UIImage(named: "user_bg.png")!.stretchableImage(withLeftCapWidth: 20, topCapHeight: 22)
//        self.background = fieldBGImage
    }

 
    
    
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        self.rightViewMode = UITextFieldViewMode.always;
        var bgImage : UIImageView?
        var image : UIImage?
        image = UIImage(named:"select_language_arrow" )
        bgImage = UIImageView(image: image)
        bgImage!.contentMode = UIViewContentMode.center
        bgImage!.frame = CGRect(x: 0,y: 0,width: 28,height: 5)
        self.rightView = bgImage
        
        setToolbarWithPickerOnTextfield()
        
        
    }
    func setLeftImage(_ imageName: String)  {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 21))
        let image = UIImage(named:imageName);
        imageView.image = image;
        imageView.frame = imageView.frame.insetBy(dx: -10, dy: 0);
        imageView.contentMode = UIViewContentMode.center
        self.leftViewMode = UITextFieldViewMode.always
        self.leftView = imageView;
        
    }

    func setLeftLabel(_ labelText: String)  {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 21))
       // let image = UIImage(named:imageName);
      //  imageView.image = image;
        label.frame = label.frame.insetBy(dx: -10, dy: 0);
        label.text = labelText
        
        label.font = UIFont(name: label.font.fontName, size: 10)
        label.textColor = UIColor.white
        label.contentMode = UIViewContentMode.right
        self.leftViewMode = UITextFieldViewMode.always
        self.leftView = label;
        
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
        self.text  = pickerArray[row] as? String
        if pickerArrayWithCountory.count > 0 {
            let name = pickerArrayWithCountory[row] as? String
            return  name! + (pickerArray[row] as! String)
        }else{
            return pickerArray[row] as? String
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.text  = pickerArray[row] as? String
    }
    
    func doneButtonPressed() {
        self.resignFirstResponder()
        if delegateTextField != nil && delegateTextField?.responds(to: #selector(TextFieldPickerDelegate.textField(_:didClickedOnDoneButtonWith:))) == true {
            delegateTextField!.textField!(self, didClickedOnDoneButtonWith: self.text!)
        }
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

    func reloadPickerWithArrayArray(_ arr:NSMutableArray, arrName:NSMutableArray)  {
        pickerArray = arr
        pickerArrayWithCountory = arrName
        pickrView.reloadAllComponents()
    }


}
