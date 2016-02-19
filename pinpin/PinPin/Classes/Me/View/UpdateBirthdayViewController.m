//
//  UpdateBirthdayViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/19.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "UpdateBirthdayViewController.h"
#import "PersonalInfoTableViewController.h"
@interface UpdateBirthdayViewController ()

@end

@implementation UpdateBirthdayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}

-(void)viewInit{
    self.view.backgroundColor = BACKGROUND_COLOR;
    _inputBirthdayField = [[UITextField alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, 40)];
    _inputBirthdayField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    _inputBirthdayField.leftViewMode =  UITextFieldViewModeAlways;
    _inputBirthdayField.layer.borderWidth = 1.0;
    _inputBirthdayField.leftViewMode =  UITextFieldViewModeAlways;
    _inputBirthdayField.layer.borderWidth = 1.0;
    _inputBirthdayField.layer.borderColor = [[UIColor lightTextColor] CGColor];
    _inputBirthdayField.backgroundColor = [UIColor whiteColor];
    _inputBirthdayField.text =![SYSTEM_USERDEFAULTS objectForKey:Y_birthday] ?[ToolKit getNowTimeWithFormat:@"yyyy-MM-dd"]: [ToolKit timeStampConversionDate:[[SYSTEM_USERDEFAULTS objectForKey:Y_birthday] doubleValue]];
    UIDatePicker * picker = [[UIDatePicker alloc] init];
    picker.datePickerMode = UIDatePickerModeDate;
    picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    _inputBirthdayField.inputView  = picker;
    NSDate *nowdate  =![SYSTEM_USERDEFAULTS objectForKey:Y_birthday]?[NSDate date]:[NSDate dateWithTimeIntervalSince1970:[[SYSTEM_USERDEFAULTS objectForKey:Y_birthday] doubleValue]/1000];
    picker.date =nowdate;
    [picker addTarget:self action:@selector(pickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_inputBirthdayField];
    [_inputBirthdayField becomeFirstResponder];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDownToKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    
    /**
     *  创建提交按钮
     */
    
    UIBarButtonItem *  rightButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}
- (void)touchDownToKeyboard:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
-(void)pickerValueChanged:(UIDatePicker *)picker{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init] ;
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    _inputBirthdayField.text =  [dateformatter stringFromDate:picker.date];
    

}
/**
 *  提交
 */
-(void)save{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:_inputBirthdayField.text];
    NSTimeInterval dateDiff = [ date timeIntervalSinceNow];
    if (dateDiff>0) {
        [MBProgressHUD showError:@"请选择正确是出生日期"];
        return;
    }
    NSArray *viewControllers=[self.navigationController viewControllers];
    PersonalInfoTableViewController *popVC=[viewControllers objectAtIndex:viewControllers.count-2];
    popVC.updateType = P_birthday;
    [self.navigationController popToViewController:popVC animated:YES];
  NSString *timeSp = [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]*1000];
    
    [SYSTEM_USERDEFAULTS setObject:timeSp forKey:Y_birthday];
    [SYSTEM_USERDEFAULTS synchronize];
    UserInfo *userInfo = [UserInfo new];
    userInfo.birthday =  timeSp;
    [[MeHandle instance ] updatePersonalInfoWithUserInfo:userInfo withCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
                NSLog(@"%@",dictionary[Y_Message]);
                //                [SYSTEM_USERDEFAULTS setObject:_inputTextField.text forKey:Y_name];
                //                [SYSTEM_USERDEFAULTS synchronize];
            }
            else{
                [MBProgressHUD showError:dictionary[Y_Message]];
            }
        }else{
            [MBProgressHUD showError:NetError];
            
        }
    }];
    
}


@end
