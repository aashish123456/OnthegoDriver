//
//  WADatePickerTextField.m
//  WACustomControlls
//
//  Created by Vasim Akram on 16/09/15.
//  Copyright (c) 2015 Vasim Akram. All rights reserved.
//

#import "WADatePickerTextField.h"

#define     ToolbarButtonTintColor  [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define     ToolBarTintColor        [UIColor colorWithRed:45/255.0f green:130/255.0f blue:215/255.0f alpha:1]



@interface WADatePickerTextField() {
    
    UIDatePicker *datePickerView;
    NSDateFormatter *dateFormater;
}

@end


@implementation WADatePickerTextField
@synthesize strDateFormate;




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    /*
    self.layer.cornerRadius=4.0f;
    self.layer.masksToBounds=YES;
    self.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.layer.borderWidth= 1.0f;
    */
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 16)];
    imageView.contentMode =  UIViewContentModeLeft;
    imageView.image = [UIImage imageNamed:@"calendar_icon"];
    
    self.rightView = imageView;
    self.rightViewMode = UITextFieldViewModeAlways;
}

- (id)initWithCoder:(NSCoder *)inCoder {
    self = [super initWithCoder:inCoder];
    if (self) {
        
        dateFormater = [[NSDateFormatter alloc] init];
        
        //strDateFormate = @"dd-MMM-yyyy";
        strDateFormate = @"yyyy";
        [super setDelegate:(id<UITextFieldDelegate>)self];
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
    datePickerView=[[UIDatePicker alloc]initWithFrame:CGRectMake(0,41,[UIScreen mainScreen].bounds.size.width,160)];
    
    
    
    [datePickerView setDate:[NSDate date]];
    
    datePickerView.datePickerMode = UIDatePickerModeDate;
    //set minimume date ..> today date
    datePickerView.minimumDate = [NSDate date];
    [datePickerView setBackgroundColor:[UIColor clearColor]];
    [customPickerView addSubview:toolbarOfPicker];
    [customPickerView addSubview:datePickerView];
    
    self.inputView = customPickerView;
    
}

-(void)setMinimumeDate:(int)minimumDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-100];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    datePickerView.minimumDate = minDate;
    
    NSDateComponents *compsMax = [[NSDateComponents alloc] init];
    [compsMax setYear:minimumDate];
    NSDate *maxDate = [calendar dateByAddingComponents:compsMax toDate:currentDate options:0];
    datePickerView.maximumDate = maxDate;
}
#pragma mark button Action
-(void)pickerDoneButtonClicked{
    NSLog(@"Done Clicked !!!");
    [dateFormater setDateFormat:strDateFormate];
    
    self.accessibilityLabel = [NSString stringWithFormat:@"%f",[datePickerView.date timeIntervalSince1970]];
    self.text = [dateFormater stringFromDate:datePickerView.date];
    [self resignFirstResponder];
}

-(void)pickerCancelButtonClicked{
    NSLog(@"Cancle Clicked !!!");
    [self resignFirstResponder];
}

#pragma mark - UItextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if([self.text isEqualToString:@""] == NO && datePickerView){
        NSDate *selectedDate = [dateFormater dateFromString:self.text];
        if(selectedDate){
            datePickerView.date = selectedDate;
        }
    }
    return YES;
}


@end
