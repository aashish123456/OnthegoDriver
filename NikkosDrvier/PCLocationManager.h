//
//  PCLocationManager.h
//  PopCab
//
//  Created by Vasim Akram on 28/07/15.
//  Copyright (c) 2015 Dheeraj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PCLocationManager : NSObject<CLLocationManagerDelegate>{
    //BOOL isAlreadyUpdatingLocation;
}

@property (nonatomic, retain) CLLocationManager *locationMngr;
@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) BOOL isAlreadyUpdatingLocation;
+ (id) sharedLocationManager;
-(void)startUpdateingLocation;
-(void)stopUpdationgLocation;

@end
