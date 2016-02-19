//
//  UpdatePhoneViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/19.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "UpdatePhoneViewController.h"
#import "PersonalInfoTableViewController.h"
#import "SetUpNewPhoneViewController.h"
@interface UpdatePhoneViewController ()<UIAlertViewDelegate>

@end

@implementation UpdatePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}

-(void)viewInit{
    
    _inputPhoneField.text = [SYSTEM_USERDEFAULTS objectForKey:Y_phone];
    _authCodeButton.backgroundColor = THEME_COLOR;
    [_authCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDownToKeyboard:)];
    [self.view addGestureRecognizer:tap];
    /**
     *  创建提交按钮
     */
    UIBarButtonItem *  rightButton = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}
- (void)touchDownToKeyboard:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
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
}
/**
 *发送验证码
 */
- (IBAction)authCodeAction:(id)sender{
    if (!(11==_inputPhoneField.text.length)) {
        [MBProgressHUD showError:@"手机号码格式错误"];
        return;
    }
    [[UserHandle instance] startTimeWithButton:_authCodeButton];
    [[UserHandle instance] sendAuthCodeWithPhone:[_inputPhoneField.text trimString]];
}

/**
 *  提交
 */
-(void)save{
    NSString *code = [_authCodeTextField.text trimString];
    NSString *phone = [_inputPhoneField.text trimString];
    if (phone.length!=11) {
        [MBProgressHUD showError:@"请正确输入您的手机号！"];
        return;
    }
    else  if ([code isEmptyString]||code.length!=4) {
        [MBProgressHUD showError:@"请正确输入您的验证码！"];
        return;
    }
    [MBProgressHUD showMessage:nil];
    [[UserHandle instance]authCodeValidationWithPhone:phone code:code withCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            [MBProgressHUD hideHUD];
            if (200==[dictionary[@"status"] intValue]) {
                SetUpNewPhoneViewController *setUpNewPhoneViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SetUpNewPhoneViewController"];
                [self.navigationController pushViewController:setUpNewPhoneViewController animated:YES];
            }
            else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"您输入的验证码有误"];
            }
        }else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:NetError];
        }
    }];
    
    //    NSArray *viewControllers=[self.navigationController viewControllers];
    //    PersonalInfoTableViewController *popVC=[viewControllers objectAtIndex:viewControllers.count-2];
    //    popVC.updateType = P_phone;
    //    [self.navigationController popToViewController:popVC animated:YES];
    //    [SYSTEM_USERDEFAULTS setObject:[_inputPhoneField.text trimString] forKey:Y_phone];
    //    [SYSTEM_USERDEFAULTS synchronize];
    //    UserInfo *userInfo = [UserInfo new];
    //    userInfo.phone =  _inputPhoneField.text;
    //    [[MeHandle instance ] updatePersonalInfoWithUserInfo:userInfo withCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
    //        if (!error) {
    //            if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
    //                NSLog(@"%@",dictionary[Y_Message]);
    //                //                [SYSTEM_USERDEFAULTS setObject:_inputTextField.text forKey:Y_name];
    //                //                [SYSTEM_USERDEFAULTS synchronize];
    //            }
    //            else{
    //                [MBProgressHUD showError:dictionary[Y_Message]];
    //            }
    //        }else{
    //            [MBProgressHUD showError:NetError];
    //            
    //        }
    //    }];
    
}


@end
