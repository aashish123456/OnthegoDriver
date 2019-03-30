//
//  PCLocationManager.m
//  PopCab
//
//  Created by Vasim Akram on 28/07/15.
//  Copyright (c) 2015 Dheeraj. All rights reserved.
//

#import "PCLocationManager.h"
#import "OnthegoDriver-Swift.h"



@implementation PCLocationManager

@synthesize locationMngr, myLocation ,isAlreadyUpdatingLocation;

+ (id) sharedLocationManager {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

-(id)init{
    self = [super init];
    
    if(self){
        self.locationMngr = [[CLLocationManager alloc] init];
        self.locationMngr.delegate = self;
        self.locationMngr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//kCLLocationAccuracyBest;
        self.locationMngr.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        self.myLocation = CLLocationCoordinate2DMake(0, 0);
    }
    return self;
}

-(void)startUpdateingLocation{
    
    //    if(isAlreadyUpdatingLocation){
    //        return;
    //    }
    //    else{
    
    [self.locationMngr requestAlwaysAuthorization];
    [self.locationMngr startUpdatingLocation];
    self.locationMngr.allowsBackgroundLocationUpdates = YES;
    if ([CLLocationManager locationServicesEnabled]){
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            self.isAlreadyUpdatingLocation = false;
        }else{
            self.isAlreadyUpdatingLocation = true;
        }
    }else{
        self.isAlreadyUpdatingLocation = false;
    }
    
    
    //    }
}

-(void)stopUpdationgLocation{
    [self.locationMngr stopUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@":::::::::location did update::::::::::::");
    
    if(manager.location.coordinate.latitude == self.myLocation.latitude && manager.location.coordinate.longitude == self.myLocation.longitude){
        return;
    }
    //isAlreadyUpdatingLocation = YES;
    
    self.myLocation = manager.location.coordinate;
    NSLog(@"course is  %f",manager.location.course);
    
    
    // if([checkForNull([PopCabSettings getUserType]) isEqualToString:@"Driver"]){
     [self updateLocationToServer];
    //        if ([PopCabSettings getCurrentTrip]!=nil) {
    //            [self checkReachDestination];
    //        }
    
    
}

-(void)updateLocationToServer{
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
 
        [params setObject:[NSString stringWithFormat:@"%f",self.locationMngr.location.course] forKey:@"Course"];
    
    
//    else{
//        [params setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Course"];
//    }
    if([SharedStorage getDriverId] != nil){
        [params setObject:[SharedStorage getDriverId] forKey:@"DriverId"];
    }else{
        [params setObject:@"0" forKey:@"DriverId"];
    }
    if(self.myLocation.latitude != 0){
        [params setObject:[NSString stringWithFormat:@"%f",self.myLocation.latitude] forKey:@"Latitude"];
    }else{
        [params setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Latitude"];
    }
    if(self.myLocation.longitude != 0){
        [params setObject:[NSString stringWithFormat:@"%f",self.myLocation.longitude] forKey:@"Longitude"];
    }else{
        [params setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Longitude"];
    }
    
   /* NSInteger  timezoneoffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
    NSLog(@"timezoneoffset>>%ld", (long)timezoneoffset);
    [params setObject:[NSString stringWithFormat:@"%ld",(long)timezoneoffset] forKey:@"UtcOffsetInSecond"];*/
    
    /*
     NSMutableDictionary *parameterNew = [[NSMutableDictionary alloc] init];
     [parameterNew setObject:params forKey:@"RequestPacket"];
     NSLog(@"%@",parameterNew);
     */
    NSLog(@"%@",params);
    [PCServerCommunicator GetDataForMethod:@"UpdateDriverLocation" withParameters:params onCompletion:^(BOOL status, NSError *error, NSDictionary *responseData)
     {
         
         if(status == YES){
             NSLog(@"Success !! in Location ping");
         }
         else if (error == nil){
             NSLog(@"Failed !! %@",[responseData objectForKey:@"status"]);
         }
         else{
             NSLog(@"Oops ! please try again");
         }
     }];
    
}


@end
