//
//  UpdatePasswordViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/17.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "UpdatePasswordViewController.h"

@interface UpdatePasswordViewController ()

@end

@implementation UpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self viewInit];
}

-(void)viewInit{
    self.view.backgroundColor = BACKGROUND_COLOR;
    _doneButton.layer.masksToBounds = YES;
    _doneButton.layer.cornerRadius = 6.0;
    _doneButton.backgroundColor = THEME_COLOR;
    [_phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.view.backgroundColor = BACKGROUND_COLOR;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDownToKeyboard:)];
    [self.view addGestureRecognizer:tap];
    _phoneTextField.text = [SYSTEM_USERDEFAULTS objectForKey:Y_phone] ;
}
/**
 *  限制验证码的长度为4位
 */
- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField == _phoneTextField) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}
- (void)touchDownToKeyboard:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
- (IBAction)doneAction:(id)sender {
    NSString *phone = [_phoneTextField.text trimString];
    NSString *oldPassword = _oldPasswordTextField.text;
    NSString *firstPassword = _firstPasswordTextField.text;
    NSString *secondPassword = _sencondPasswordTextField.text;
    NSLog(@"%@",[SYSTEM_USERDEFAULTS objectForKey:Y_password] );
    NSLog(@"%@",[DES3Util encrypt:oldPassword]);
    NSLog(@"%@",[SYSTEM_USERDEFAULTS objectForKey:Y_phone] );
    if ([phone isEmptyString]) {
        [MBProgressHUD showError:@"请输入您的手机号"];
        return;
    }
    else if([oldPassword isEmptyString]||[firstPassword isEmptyString] || [secondPassword isEmptyString]){
        [MBProgressHUD showError:@"请输入您的密码"];
        return;
    }
    else if(![[SYSTEM_USERDEFAULTS objectForKey:Y_password] isEqualToString:[DES3Util encrypt:oldPassword]]){
        [MBProgressHUD showError:@"您输入的旧密码不正确！"];
        return;
    }
    else if(![firstPassword isEqualToString:secondPassword]){
        [MBProgressHUD showError:@"您两次输入密码不一致！"];
        return;
    }
    UserInfo *userInfo = [UserInfo new];
    userInfo.password = firstPassword;
//    [MBProgressHUD showMessage:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[UserHandle instance] updatePasswordWithUserInfo:userInfo withCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        if(!error){
//            [MBProgressHUD hideHUD];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
                [MBProgressHUD showSuccess:dictionary[Y_Message]];
                [[UserHandle instance ] logout];
            }
            else{
                [MBProgressHUD showError:dictionary[Y_Message]];
            }
        }
        else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:NetError];
        }
    }];
}

@end
