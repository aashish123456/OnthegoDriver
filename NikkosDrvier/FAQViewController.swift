//
//  FAQViewController.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 02/09/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController, SWRevealViewControllerDelegate {
    @IBOutlet var statusButton: UIBarButtonItem!
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    
    @IBOutlet var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NikkosDriverManager.GetLocalString("FAQ")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            sideBarButton.target = self.revealViewController()
            sideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        statusButton.target = self.navigationController
        statusButton.action = #selector(CustomNavigationController.StatusButton(_:))
        webView.loadRequest(URLRequest(url: URL(string: "http://wds2.projectstatus.co.uk/Nikkos/Faq")!))
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
