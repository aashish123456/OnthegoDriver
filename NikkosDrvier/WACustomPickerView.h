//
//  WACustomPickerView.h
//  NightLife
//
//  Created by Vasim Akram on 06/08/15.
//  Copyright (c) 2015 Vasim Akram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol WACustomPickerDelegate


@optional
- (void)didClickedOnCancleButton;
- (void)textField:(UITextField *)textField didClickedOnDoneButtonWith:(int)selectedValue;
- (void)textField:(UITextField *)textField didClicked:(NSDate*)selectedDate;

@end


@interface WACustomPickerView : NSObject

@property (nonatomic, assign) id<WACustomPickerDelegate> delegate;
-(id)initDatePicker:(UIDatePickerMode)mode;

-(void)setInputData:(NSArray *)array withSorting:(BOOL)flag;
-(void)setPickerToInputView:(UITextField *)aTextField;
@end
