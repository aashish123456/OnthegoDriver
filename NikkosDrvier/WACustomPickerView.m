//
//  WACustomPickerView.m
//  NightLife
//
//  Created by Vasim Akram on 06/08/15.
//  Copyright (c) 2015 Vasim Akram. All rights reserved.
//

#import "WACustomPickerView.h"

@interface WACustomPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>{
    UITextField *textField;
    NSString *selectedValue;
    NSArray *inputData;
    UIView *customPickerView;
    int selectedIndex;
    UIPickerView *pickerView;
    NSDate *selectedDate;
}
@end


@implementation WACustomPickerView
@synthesize delegate;
-(id)init{
    self = [super init];
    if(self){
        [self initilizePickerView];
    }
    return self;
}

-(id)initDatePicker:(UIDatePickerMode)mode{
    self = [super init];
    if(self){
        [self initilizeDatePickerView:mode];
    }
    return self;
}


-(void)initilizePickerView{
    customPickerView=[[UIView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].applicationFrame.size.width,200)];
    UIToolbar *toolbarOfPicker=[[UIToolbar alloc]init];
    toolbarOfPicker.barStyle = UIBarStyleDefault;
    [toolbarOfPicker sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(pickerDoneButtonClicked)];
  //  doneButton.tintColor = [UIColor colorWithRed:144/255.0f green:0 blue:1 alpha:1];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(pickerCancelButtonClicked)];
  //  cancelButton.tintColor = [UIColor colorWithRed:144/255.0f green:0 blue:1 alpha:1];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    cancelButton.style = UIBarButtonItemStylePlain;
    doneButton.style=UIBarButtonItemStylePlain;
    NSArray *arrtoolBarDatePickerButtons=[NSArray arrayWithObjects:cancelButton,flexibleSpace,doneButton, nil];
    
    [toolbarOfPicker setItems:arrtoolBarDatePickerButtons animated:NO];
    CGRect toolbarFrame = CGRectMake(0,0,[UIScreen mainScreen].applicationFrame.size.width,40);
    toolbarOfPicker.barTintColor = [UIColor colorWithRed:227/255.0f green:231/255.0f blue:235/255.0f alpha:1];
    [toolbarOfPicker setFrame:toolbarFrame];
    pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0,41,[UIScreen mainScreen].bounds.size.width,160)];
    pickerView.delegate=self;
    pickerView.dataSource=self;
    pickerView.showsSelectionIndicator=YES;
    [pickerView setBackgroundColor:[UIColor clearColor]];
    [customPickerView addSubview:toolbarOfPicker];
    [customPickerView addSubview:pickerView];
}

-(void)initilizeDatePickerView:(UIDatePickerMode)mode{
    customPickerView=[[UIView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].applicationFrame.size.width,200)];
    UIToolbar *toolbarOfPicker=[[UIToolbar alloc]init];
    toolbarOfPicker.barStyle = UIBarStyleDefault;
    [toolbarOfPicker sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(pickerDoneButtonClicked)];
   // doneButton.tintColor = [UIColor colorWithRed:144/255.0f green:0 blue:1 alpha:1];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(pickerCancelButtonClicked)];
    //cancelButton.tintColor = [UIColor colorWithRed:144/255.0f green:0 blue:1 alpha:1];;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    cancelButton.style = UIBarButtonItemStylePlain;
    doneButton.style=UIBarButtonItemStylePlain;
    NSArray *arrtoolBarDatePickerButtons=[NSArray arrayWithObjects:cancelButton,flexibleSpace,doneButton, nil];
    
    [toolbarOfPicker setItems:arrtoolBarDatePickerButtons animated:NO];
    CGRect toolbarFrame = CGRectMake(0,0,[UIScreen mainScreen].applicationFrame.size.width,40);
    toolbarOfPicker.barTintColor = [UIColor colorWithRed:227/255.0f green:231/255.0f blue:235/255.0f alpha:1];
    [toolbarOfPicker setFrame:toolbarFrame];
    UIDatePicker *aPickerView=[[UIDatePicker alloc]initWithFrame:CGRectMake(0,41,[UIScreen mainScreen].bounds.size.width,160)];
    [aPickerView setDate:[NSDate date]];
    aPickerView.datePickerMode = mode;
    if ( aPickerView.datePickerMode==UIDatePickerModeDate) {
       aPickerView.maximumDate = [NSDate date];
    }
   // aPickerView.minimumDate = [NSDate date];
    [self datePickerValueChanged:aPickerView];
    [aPickerView addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [aPickerView setBackgroundColor:[UIColor clearColor]];
    [customPickerView addSubview:toolbarOfPicker];
    [customPickerView addSubview:aPickerView];
}


-(void)setInputData:(NSArray *)array withSorting:(BOOL)flag{
    if(flag){
        inputData = [array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    else{
        inputData = array;
    }
    [pickerView reloadAllComponents];
}

-(void)setPickerToInputView:(UITextField *)aTextField
{
    textField = aTextField;
    aTextField.inputView = customPickerView;
    
}


#pragma mark button Action
-(void)pickerDoneButtonClicked{
    NSLog(@"Done Clicked !!!");
    if(selectedValue == nil && pickerView){
        selectedValue = inputData[0];
    
    }
    else if([textField isKindOfClass:[UITextField class]]){
        textField.accessibilityLabel = [NSString stringWithFormat:@"%f",[selectedDate timeIntervalSince1970]];
        
    }
    if (selectedValue!=nil) {
           textField.text = selectedValue;
    }

    
    

   
    if(self.delegate && pickerView){
        [self.delegate textField:textField didClickedOnDoneButtonWith:selectedIndex];
    }else  if (self.delegate ) {
        [self.delegate textField:textField didClicked:selectedDate];
    }
    
    [textField resignFirstResponder];
   
    //selectedValue = nil;
}

-(void)pickerCancelButtonClicked{
    NSLog(@"Cancle Clicked !!!");
    [textField resignFirstResponder];
    if(self.delegate){
        [self.delegate didClickedOnCancleButton];
    }
    
    //selectedValue = nil;
}


#pragma mark - UIPickerView Delegate And DataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [inputData count];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [inputData objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    selectedValue=[inputData objectAtIndex:row];
    selectedIndex=row;
}


#pragma mark - UIDatePicker value change
-(void)datePickerValueChanged:(UIDatePicker *)picker{
    NSDateFormatter *df =[[NSDateFormatter alloc] init];
    if (picker.datePickerMode==UIDatePickerModeDate) {
          [df setDateFormat:@"dd MMM, yyyy"];  
    }else
    {
          [df setDateFormat:@"HH:mm"];
    }

    
    selectedValue = [df stringFromDate:picker.date];
    selectedDate = picker.date;
}
@end
