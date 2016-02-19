//
//  LoginViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/14.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}

-(void)viewInit{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO ; //禁用右滑手势
    self.view.backgroundColor = BACKGROUND_COLOR;
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 6.0;
    _loginButton.backgroundColor = THEME_COLOR;
    
    [[ToolKit instance] drawBottomBorderWithUIView:_accountTextField Color:BACKGROUND_COLOR];
    
    [[ToolKit instance] drawBottomBorderWithButton:_ForgotPasswordButton Color:[UIColor lightGrayColor]];
    
    [[ToolKit instance] drawBottomBorderWithButton:_RegisterButton Color:[UIColor lightGrayColor]];
    
    _accountTextField.backgroundColor =[UIColor whiteColor];
    _passwordTextField.backgroundColor =[UIColor whiteColor];
    
    _accountTextField.delegate =self;
    _passwordTextField.delegate=self;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDownToKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    if (iPhone4) {
        _topLayout.constant = 68;
    }
    else if(iPhone5){
        _topLayout.constant = 150;
    }
    else if(iPhone6){
        _topLayout.constant = 180;
    }
    else if(iPhone6plus){
        _topLayout.constant = 200;
    }
}

- (void)touchDownToKeyboard:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.textAlignment= NSTextAlignmentLeft;
    CATransition *animation = [CATransition animation];
    [animation setDuration:1.0];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setType:@"rippleEffect"];// rippleEffect
    [animation setSubtype:kCATransitionFromTop];
    [textField.layer addAnimation:animation forKey:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.textAlignment= NSTextAlignmentCenter;
    CATransition *animation = [CATransition animation];
    [animation setDuration:1.0];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setType:@"rippleEffect"];// rippleEffect
    [animation setSubtype:kCATransitionFromTop];
    [textField.layer addAnimation:animation forKey:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_passwordTextField) {
        [self loginAction:nil];
    }
    return YES;
}

/*
 *游客身份
 */
- (IBAction)visitorAciton:(id)sender {
    
    [[Config Instance] removeObjectFromUserDefaults];
    
    UIStoryboard * storyBoard =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShareAppDelegate.window.rootViewController = [storyBoard instantiateInitialViewController];
    [ShareAppDelegate initTabBarController];
}



/**
 *登陆
 */
- (IBAction)loginAction:(id)sender{
    [_passwordTextField resignFirstResponder];
    if ([_accountTextField.text isEmptyString]) {
        [MBProgressHUD showError:@"请输入您的账号！"];
        return;
    }
    else if([_passwordTextField.text isEmptyString]){
        [MBProgressHUD showError:@"请输入您的密码"];
        return;
    }
    UserInfo *userInfo = [UserInfo new];
    userInfo.phone = [_accountTextField.text trimString];
    userInfo.password  =  _passwordTextField.text;
    [self loginWithUser:userInfo];
}

-(void)loginWithUser:(UserInfo *)userInfo{
    [[UserHandle instance] loginWithUserInfo:userInfo withCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
                NSLog(@"%@",dictionary);
                NSLog(@"%@",dictionary[Y_Message]);
//                [MBProgressHUD showMessage:nil];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [MBProgressHUD hideHUD];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    UserInfo *loginUserInfo   = [UserInfo objectWithKeyValues:dictionary[Y_Data]];
                    [[Config Instance] saveLoginUserInfo:loginUserInfo];
                    UIStoryboard * storyBoard =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ShareAppDelegate.window.rootViewController = [storyBoard instantiateInitialViewController];
                    [ShareAppDelegate initTabBarController];
                });
                
            }
            else {
                [MBProgressHUD showError:dictionary[Y_Message]];
                
            }
        }
        else{
            [MBProgressHUD showError:NetError];
        }
    }];
    
}


@end
