//
//  TextFieldCharLimit.swift
//  JobDispatch
//
//  Created by Vasim Akram on 03/08/16.
//  Copyright © 2016 Ashish Soni. All rights reserved.
//

import Foundation


    // 1
    private var maxLengths = [UITextField: Int]()
    
    // 2
    extension UITextField {
        
        // 3
        @IBInspectable var maxLength: Int {
            get {
                // 4
                guard let length = maxLengths[self] else {
                    return Int.max
                }
                return length
            }
            set {
                maxLengths[self] = newValue
                // 5
                addTarget(
                    self,
                    action: #selector(limitLength),
                    for: UIControlEvents.editingChanged
                )
            }
        }
        
        func limitLength(_ textField: UITextField) {
            // 6
            guard let prospectiveText = textField.text, prospectiveText.characters.count > maxLength else {
                    return
            }
            
            let selection = selectedTextRange
            // 7
            text = prospectiveText.substring(
                with: Range<String.Index>(prospectiveText.startIndex ..< prospectiveText.characters.index(prospectiveText.startIndex, offsetBy: maxLength))
            )
            selectedTextRange = selection
        }
        
    }




extension UIViewController{
    func isModal() -> Bool {
        
        if let navigationController = self.navigationController{
            if navigationController.viewControllers.first != self{
                return false
            }
        }
        
        if self.presentingViewController != nil {
            return true
        }
        
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        }
        
        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
}
