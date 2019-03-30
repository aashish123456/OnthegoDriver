//
//  WAPickerTextField.m
//  WACustomControlls
//
//  Created by Vasim Akram on 16/09/15.
//  Copyright (c) 2015 Vasim Akram. All rights reserved.
//

#import "WAExpiryDateTextField.h"


#define     ToolbarButtonTintColor  [UIColor colorWithRed:38/255.0f green:167/255.0f blue:237/255.0f alpha:1]
#define     ToolBarTintColor        [UIColor colorWithRed:227/255.0f green:231/255.0f blue:235/255.0f alpha:1]



@interface WAExpiryDateTextField()<UIPickerViewDataSource, UIPickerViewDelegate> {
    UIPickerView *pickrView;
    
    NSArray *arrMonths;
    NSArray *arrYears;
    NSArray *arrAboveCurrentYearMonths;
    NSArray *arrPickerMonths;
    NSInteger currentMonth;
    NSInteger currentYear;
}

@end


@implementation WAExpiryDateTextField

@synthesize selectedMonth, selectedYear;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
}

- (id)initWithCoder:(NSCoder *)inCoder {
    self = [super initWithCoder:inCoder];
    if (self) {
        [super setDelegate:(id<UITextFieldDelegate>)self];
        [self initilizePickerView];
        
        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 11)];
//        imageView.contentMode =  UIViewContentModeCenter;
//        imageView.image = [UIImage imageNamed:@"serviceArrowDone"];
//        
//        self.rightView = imageView;
//        self.rightViewMode = UITextFieldViewModeAlways;
        
        arrAboveCurrentYearMonths = @[@"01",@"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12"];
        [self setYearRange];
        [self setMonthRange];

    }
    return self;
}

-(void)setText:(NSString *)text{
    [super setText:text];
    if([self.text isEqualToString:@""] == NO && pickrView){
        NSArray *arrData = [self.text componentsSeparatedByString:@"/"];
        self.selectedMonth =  [arrData[0] integerValue];
        self.selectedYear =  [arrData[1] integerValue];
    }
}


-(void)setYearRange{
    NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    currentYear = [gregorian component:NSCalendarUnitYear fromDate:NSDate.date];
    NSMutableArray *ageArray = [NSMutableArray array];
    for(NSInteger i = 0 ; i < 25 ; i++){
        [ageArray addObject:[NSString stringWithFormat:@"%ld", (long)currentYear + i]];
    }
    arrYears = ageArray.copy;
}

-(void)setMonthRange{
    NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    currentMonth = [gregorian component:NSCalendarUnitMonth fromDate:NSDate.date];
    NSMutableArray *ageArray = [NSMutableArray array];
    for(NSInteger i = currentMonth ; i <= 12 ; i++){
        if(i<10){
            [ageArray addObject:[NSString stringWithFormat:@"0%ld",(long)i]];
        }else{
            [ageArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
    }
    
    arrPickerMonths = ageArray.copy;
    arrMonths = arrPickerMonths.copy ;
}


-(void)initilizePickerView{
    UIView *customPickerView=[[UIView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,200)];
    UIToolbar *toolbarOfPicker=[[UIToolbar alloc]init];
    toolbarOfPicker.barStyle = UIBarStyleDefault;
    [toolbarOfPicker sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(pickerDoneButtonClicked)];
    doneButton.tintColor = ToolbarButtonTintColor;
    doneButton.style=UIBarButtonItemStylePlain;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(pickerCancelButtonClicked)];
    cancelButton.tintColor = ToolbarButtonTintColor ;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    cancelButton.style = UIBarButtonItemStylePlain;
    
    NSArray *arrtoolBarDatePickerButtons=[NSArray arrayWithObjects:cancelButton,flexibleSpace,doneButton, nil];
    
    [toolbarOfPicker setItems:arrtoolBarDatePickerButtons animated:NO];
    CGRect toolbarFrame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,40);
    toolbarOfPicker.barTintColor = ToolBarTintColor;
    [toolbarOfPicker setFrame:toolbarFrame];
    
    pickrView=[[UIPickerView alloc]initWithFrame:CGRectMake(0,41,[UIScreen mainScreen].bounds.size.width,160)];
    pickrView.delegate=self;
    pickrView.dataSource=self;
    pickrView.showsSelectionIndicator=YES;
    [pickrView setBackgroundColor:[UIColor clearColor]];
    [customPickerView addSubview:toolbarOfPicker];
    [customPickerView addSubview:pickrView];
    
    self.inputView = customPickerView;
}


#pragma mark button Action
-(void)pickerDoneButtonClicked{
    NSLog(@"Done Clicked !!!");
    NSString *strSelectedMonth = arrMonths[[pickrView selectedRowInComponent:0]];
    NSString *strSelectedYear = arrYears[[pickrView selectedRowInComponent:1]];
    
    self.text = [NSString stringWithFormat:@"%@/%@",strSelectedMonth, strSelectedYear];
    self.selectedMonth = strSelectedMonth.integerValue;
    self.selectedYear = strSelectedYear.integerValue;

    [self resignFirstResponder];
}

-(void)pickerCancelButtonClicked{
    NSLog(@"Cancle Clicked !!!");
    [self resignFirstResponder];
}



#pragma mark - UIPickerView Delegate And DataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(component == 0){
        return arrMonths.count;
    }
    else{
        return arrYears.count;
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(component == 0){
        return arrMonths[row];
    }
    else{
        return arrYears[row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *strSelectedYear = arrYears[[pickerView selectedRowInComponent:1]];
    if([strSelectedYear integerValue] > currentYear){
        arrMonths = arrAboveCurrentYearMonths ;
    }else{
        arrMonths = arrPickerMonths ;
    }
     [pickrView reloadComponent:0];
}

#pragma mark - UItextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if([self.text isEqualToString:@""] == NO && pickrView){
        NSArray *arrData = [self.text componentsSeparatedByString:@"/"];
        NSInteger index1 = [arrMonths indexOfObject:arrData[0]];
        [pickrView selectRow:index1 inComponent:0 animated:NO];
        
        NSInteger index2 = [arrYears indexOfObject:arrData[1]];
        [pickrView selectRow:index2 inComponent:1 animated:NO];
    }
    
    return YES;
}




@end
