//
//  UpdateAgeViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/19.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "UpdateAgeViewController.h"
#import "PersonalInfoTableViewController.h"
@interface UpdateAgeViewController ()

@end

@implementation UpdateAgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self viewInit];
}

-(void)viewInit{
    _inputAgeField = [[UITextField alloc] initWithFrame:CGRectMake(10, 74, SCREEN_WIDTH-20, 30)];
    _inputAgeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    _inputAgeField.leftViewMode =  UITextFieldViewModeAlways;
    _inputAgeField.layer.masksToBounds = YES;
    _inputAgeField.layer.cornerRadius = 6.0;
    _inputAgeField.layer.borderWidth = 1.0;
    _inputAgeField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _inputAgeField.text = [SYSTEM_USERDEFAULTS objectForKey:Y_age];
    _inputAgeField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_inputAgeField];
    [_inputAgeField becomeFirstResponder];
    
    /**
     *  创建提交按钮
     */
    
    UIBarButtonItem *  rightButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightButton;
}
/**
 *  提交
 */
-(void)save{
    NSArray *viewControllers=[self.navigationController viewControllers];
    PersonalInfoTableViewController *popVC=[viewControllers objectAtIndex:viewControllers.count-2];
    popVC.updateType = P_age;
    [self.navigationController popToViewController:popVC animated:YES];
    [SYSTEM_USERDEFAULTS setObject:[_inputAgeField.text trimString] forKey:Y_age];
    [SYSTEM_USERDEFAULTS synchronize];
    UserInfo *userInfo = [UserInfo new];
    userInfo.age =  _inputAgeField.text;
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
