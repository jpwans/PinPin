//
//  UpdatePersonalViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/17.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "UpdateNameViewController.h"
#import "PersonalInfoTableViewController.h"
@interface UpdateNameViewController ()

@end

@implementation UpdateNameViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self viewInit];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewInit{
    self.view.backgroundColor = BACKGROUND_COLOR;
    _inputNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, 40)];
    _inputNameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    _inputNameField.leftViewMode =  UITextFieldViewModeAlways;
    _inputNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _inputNameField.layer.borderWidth = 1.0;
    _inputNameField.layer.borderColor = [[UIColor lightTextColor] CGColor];
    _inputNameField.text = [SYSTEM_USERDEFAULTS objectForKey:Y_name];
    _inputNameField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_inputNameField];
    [_inputNameField becomeFirstResponder];
    
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
    popVC.updateType = P_name;
    [self.navigationController popToViewController:popVC animated:YES];
    [SYSTEM_USERDEFAULTS setObject:_inputNameField.text forKey:Y_name];
    [SYSTEM_USERDEFAULTS synchronize];
    UserInfo *userInfo = [UserInfo new];
    userInfo.name =  _inputNameField.text;
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
