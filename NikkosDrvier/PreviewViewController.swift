//
//  PreviewViewController.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 15/09/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet var imgView: UIImageView!
    var strImgURL : String!
    var img : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        if img != nil{
            imgView.image = img
        }else{
            imgView.imageURL = URL(string: strImgURL)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
