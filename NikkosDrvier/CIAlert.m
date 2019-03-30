//
//  CIAlert.m
//  Rondo
//
//  Created by Kjostinden on 20.07.11.
//  Copyright 2011 Creative Intersection. All rights reserved.
//

#import "CIAlert.h"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
void CIAlert(NSString* title, NSString* alert) {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Onthego!" message:alert delegate:nil
                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alertView show];
}

void CIError(NSString* error) {
  CIAlert(@"Onthego!", error);
}
