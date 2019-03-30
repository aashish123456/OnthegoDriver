//
//  CIAlertController.m
//  IndianWedding
//
//  Created by Umang on 12/28/15.
//  Copyright © 2015 Dheeraj. All rights reserved.
//

#import "CIAlertController.h"
#import "CIAlert.h"

#define IS_IOS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

void CIAlertController(NSString* title, NSString* alert, UIViewController* vc) {
    if(IS_IOS_8_OR_LATER){
    UIAlertController *alerView = [UIAlertController alertControllerWithTitle:@"Onthego!" message:alert preferredStyle:UIAlertControllerStyleAlert];
    [alerView addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }]];
    [vc presentViewController:alerView animated:NO completion:nil];
    }else
    {
        CIAlert(title, alert);
    }
}

void CIErrorController(NSString* error, UIViewController* vc) {

     if(IS_IOS_8_OR_LATER){
    UIAlertController *alerView = [UIAlertController alertControllerWithTitle:@"Onthego!" message:error preferredStyle:UIAlertControllerStyleAlert];
    [alerView addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }]];
    [vc presentViewController:alerView animated:NO completion:nil];
     }else
     {
         CIError(error);
     }
}
