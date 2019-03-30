//
//  PCServerCommunicator.h
//  PopCab
//
//  Created by Vasim Akram on 27/07/15.
//  Copyright (c) 2015 Dheeraj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionHandler)(BOOL status, NSError *error, NSDictionary *responseData);

@interface PCServerCommunicator : NSObject

+(void)GetDataForMethod:(NSString *)serviceName withParameters:(NSDictionary *)param onCompletion:(CompletionHandler)handlar;

@end
