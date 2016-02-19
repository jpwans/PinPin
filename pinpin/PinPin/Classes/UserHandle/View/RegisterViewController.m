//
//  RegisterViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/14.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UIAlertViewDelegate>

@end

@implementation RegisterViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}

/**
 *  初始化控制器
 */
-(void)viewInit{
    _doneButton.layer.masksToBounds = YES;
    _doneButton.layer.cornerRadius = 6.0;
    _doneButton.backgroundColor = THEME_COLOR;
    _authCodeButton.backgroundColor = THEME_COLOR;
    [_authCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.view.backgroundColor = BACKGROUND_COLOR;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDownToKeyboard:)];
    [self.view addGestureRecognizer:tap];
}
/**
 *  限制验证码的长度为4位
 */
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _authCodeTextField) {
        if (textField.text.length > 4) {
            textField.text = [textField.text substringToIndex:4];
        }
    }
    else  if (textField == _phoneTextField) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}
/**
 *完成注册
 */
- (IBAction)doneAction:(id)sender {
    NSString *code = [_authCodeTextField.text trimString];
    NSString *phone = [_phoneTextField.text trimString];
    NSString *name = [_nameTextField.text trimString];
    if([name isEmptyString]){
        [MBProgressHUD showError:@"请正确输入您真实姓名！"];
        return;
    }
    else  if (phone.length!=11) {
        [MBProgressHUD showError:@"请正确输入您的手机号！"];
        return;
    }
    else  if ([code isEmptyString]||code.length!=4) {
        [MBProgressHUD showError:@"请正确输入您的验证码！"];
        return;
    }
    [MBProgressHUD showMessage:nil];
    
    
    [SMSSDK commitVerificationCode:code phoneNumber:phone zone:ZONE result:^(NSError *error) {
        
        if (!error) {
            
                UserInfo *userInfo = [UserInfo new];
                userInfo.phone = phone;
                userInfo.password =_passwordTextField.text;
                userInfo.name = [_nameTextField.text trimString];
                [[UserHandle instance]registerWithUserInfo:userInfo withCompletionHandler:^(NSDictionary *dictionary1, NSError *error1) {
                    [MBProgressHUD hideHUD];
                    if (!error1) {
                        
                        if ([dictionary1[Y_Code] intValue]==Y_Code_Success) {
                            UIAlertView *alertView =[ [UIAlertView alloc] initWithTitle:nil message:dictionary1[Y_Message] delegate:self cancelButtonTitle:@"稍后登陆" otherButtonTitles:@"立即登陆", nil];
                            [alertView show];
                        }else{
                            [MBProgressHUD hideHUD];
                            [MBProgressHUD showError:@"该手机号码已经注册！"];
                        }
                    }
                    else {
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"服务器连接失败"];
                    }
                }];
          }
         if(error){
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"验证失败"];
            
          }
    }];
    
    
//    [[UserHandle instance]authCodeValidationWithPhone:phone code:code withCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
//        
//        if (!error) {
//            if (200==[dictionary[@"status"] intValue]) {
//                //设置密码
//                NSLog(@"设置密码");
//                UserInfo *userInfo = [UserInfo new];
//                userInfo.phone = phone;
//                userInfo.password =_passwordTextField.text;
//                userInfo.name = [_nameTextField.text trimString];
//                [[UserHandle instance]registerWithUserInfo:userInfo withCompletionHandler:^(NSDictionary *dictionary1, NSError *error) {
//                    [MBProgressHUD hideHUD];
//                    if (!error) {
//                        
//                        if ([dictionary1[Y_Code] intValue]==Y_Code_Success) {
//                            UIAlertView *alertView =[ [UIAlertView alloc] initWithTitle:nil message:dictionary1[Y_Message] delegate:self cancelButtonTitle:@"稍后登陆" otherButtonTitles:@"立即登陆", nil];
//                            [alertView show];
//                        }
//                    }
//                    else {
//                        [MBProgressHUD showError:@"服务器连接失败"];
//                    }
//                }];
//                
//            }else{
//                [MBProgressHUD hideHUD];
//                [MBProgressHUD showError:@"您输入的验证码有误"];
//            }
//        }else {
////            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"commitVerificationCode"]]];
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showError:@"验证失败"];
//        }
//    }];
    
}
/**
 *发送验证码
 */
- (IBAction)authCodeAction:(id)sender{
    if (!(11==_phoneTextField.text.length)) {
        [MBProgressHUD showError:@"手机号码格式错误"];
        return;
    }
    [[UserHandle instance] startTimeWithButton:_authCodeButton];
    [[UserHandle instance] sendAuthCodeWithPhone:[_phoneTextField.text trimString]];
}

- (void)touchDownToKeyboard:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        UserInfo *userInfo = [UserInfo new];
        userInfo.phone =[_phoneTextField.text trimString];
        userInfo.password = _passwordTextField.text;
       [MBProgressHUD showMessage:nil];
        [[UserHandle instance] loginWithUserInfo:userInfo withCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
            if (!error) {
                [MBProgressHUD hideHUD];
                if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
                    UserInfo *loginUserInfo   = [UserInfo objectWithKeyValues:dictionary[Y_Data]];
                    
                    [[Config Instance] saveLoginUserInfo:loginUserInfo];
                    UIStoryboard * storyBoard =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ShareAppDelegate.window.rootViewController = [storyBoard instantiateInitialViewController];
                    [ShareAppDelegate initTabBarController];
                }
                else {
                    [MBProgressHUD showError:dictionary[Y_Message]];
                }
            }
            else{
                       [MBProgressHUD hideHUD];
                [MBProgressHUD showError:NetError];
            }
        }];

    }
}
@end
