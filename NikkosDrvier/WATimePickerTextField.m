//
//  WADatePickerTextField.m
//  WACustomControlls
//
//  Created by Vasim Akram on 16/09/15.
//  Copyright (c) 2015 Vasim Akram. All rights reserved.
//

#import "WATimePickerTextField.h"

#define     ToolbarButtonTintColor  [UIColor colorWithRed:144/255.0f green:0 blue:1 alpha:1]
#define     ToolBarTintColor        [UIColor colorWithRed:45/255.0f green:130/255.0f blue:215/255.0f alpha:1]



@interface WATimePickerTextField() {
    
    NSString *selectedValue;
    NSDate *selectedDate;
    NSDateFormatter *dateFormater;
    UIDatePicker *pickerView;
}

@end


@implementation WATimePickerTextField
@synthesize strDateFormate;



 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
   
   
    
    

    
    
}

- (id)initWithCoder:(NSCoder *)inCoder {
    self = [super initWithCoder:inCoder];
    if (self) {
         strDateFormate = @"hh:mm a";
        /*
        self.layer.cornerRadius=4.0f;
        self.layer.masksToBounds=YES;
        self.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        self.layer.borderWidth= 1.0f;
         */
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 16)];
        imageView.contentMode =  UIViewContentModeLeft;
        imageView.image = [UIImage imageNamed:@"watch_icon"];
        
        self.rightView = imageView;
        self.rightViewMode = UITextFieldViewModeAlways;
        
        dateFormater = [[NSDateFormatter alloc] init];
        
        [self initilizePickerView];
    }
    return self;
}


-(void)initilizePickerView{

    UIView *customPickerView=[[UIView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].applicationFrame.size.width,200)];
    UIToolbar *toolbarOfPicker=[[UIToolbar alloc]init];
    toolbarOfPicker.barStyle = UIBarStyleDefault;
    [toolbarOfPicker sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(pickerDoneButtonClicked)];
    doneButton.tintColor = ToolbarButtonTintColor;
    doneButton.style=UIBarButtonItemStylePlain;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(pickerCancelButtonClicked)];
    cancelButton.tintColor = ToolbarButtonTintColor;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    cancelButton.style = UIBarButtonItemStylePlain;
    
    NSArray *arrtoolBarDatePickerButtons=[NSArray arrayWithObjects:cancelButton,flexibleSpace,doneButton, nil];
    
    [toolbarOfPicker setItems:arrtoolBarDatePickerButtons animated:NO];
    CGRect toolbarFrame = CGRectMake(0,0,[UIScreen mainScreen].applicationFrame.size.width,40);
    toolbarOfPicker.barTintColor = ToolBarTintColor;
    [toolbarOfPicker setFrame:toolbarFrame];
    pickerView=[[UIDatePicker alloc]initWithFrame:CGRectMake(0,41,[UIScreen mainScreen].bounds.size.width,160)];
    [pickerView setDate:[NSDate date]];
    pickerView.datePickerMode = UIDatePickerModeTime;
    //pickerView.minimumDate = [NSDate date];
    [self datePickerValueChanged:pickerView];
    [pickerView addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [pickerView setBackgroundColor:[UIColor clearColor]];
    [customPickerView addSubview:toolbarOfPicker];
    [customPickerView addSubview:pickerView];
    
    self.inputView = customPickerView;
    
}


#pragma mark button Action
-(void)pickerDoneButtonClicked{
    NSLog(@"Done Clicked !!!");
    [dateFormater setDateFormat:strDateFormate];
    self.accessibilityLabel = [NSString stringWithFormat:@"%f",[pickerView.date timeIntervalSince1970]];
    self.text = [dateFormater stringFromDate:pickerView.date];
    [self resignFirstResponder];
}

-(void)pickerCancelButtonClicked{
    NSLog(@"Cancle Clicked !!!");
    [self resignFirstResponder];
    selectedValue = nil;
}


#pragma mark - UIDatePicker value change
-(void)datePickerValueChanged:(UIDatePicker *)picker{
    NSDateFormatter *df =[[NSDateFormatter alloc] init];
    [df setDateFormat:strDateFormate];
    
    selectedValue = [df stringFromDate:picker.date];
    selectedDate = picker.date;
}

@end
