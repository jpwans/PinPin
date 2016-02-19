//
//  SetUpNewPhoneViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/21.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "SetUpNewPhoneViewController.h"
#import "PersonalInfoTableViewController.h"
@interface SetUpNewPhoneViewController ()<UITextFieldDelegate>

@end

@implementation SetUpNewPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}
-(void)viewInit{
    [_inputNewPhoneField becomeFirstResponder];
    _inputNewPhoneField.keyboardType = UIKeyboardTypePhonePad;
    _authCodeButton.backgroundColor = THEME_COLOR;
    [_authCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_inputNewPhoneField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    
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
    else  if (textField == _inputNewPhoneField) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}
/**
 *发送验证码
 */
- (IBAction)authCodeAction:(id)sender{
    
    
    if (!(11==_inputNewPhoneField.text.length)) {
        [MBProgressHUD showError:@"手机号码格式错误"];
        return;
    }
    else   if([[_inputNewPhoneField.text trimString]  isEqualToString:[SYSTEM_USERDEFAULTS objectForKey:Y_phone]]){
        [MBProgressHUD showError:@"新号码不能和原号码一样"];
        return;
    }
    [[UserHandle instance] startTimeWithButton:_authCodeButton];
    [[UserHandle instance] sendAuthCodeWithPhone:[_inputNewPhoneField.text trimString]];
}

/**
 *  提交
 */
-(void)save{
    NSString *code = [_authCodeTextField.text trimString];
    NSString *phone = [_inputNewPhoneField.text trimString];
    if (phone.length!=11) {
        [MBProgressHUD showError:@"请正确输入您的手机号！"];
        return;
    }
    else  if([[_inputNewPhoneField.text trimString]  isEqualToString:[SYSTEM_USERDEFAULTS objectForKey:Y_phone]]){
        [MBProgressHUD showError:@"新号码不能和原号码一样"];
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
                [MBProgressHUD showSuccess:@"验证成功"];
                NSArray *viewControllers=[self.navigationController viewControllers];
                PersonalInfoTableViewController *popVC=[viewControllers objectAtIndex:viewControllers.count-3];
                popVC.updateType = P_phone;
                [SYSTEM_USERDEFAULTS setObject:[_inputNewPhoneField.text trimString] forKey:Y_phone];
                [SYSTEM_USERDEFAULTS synchronize];
                [self.navigationController popToViewController:popVC animated:YES];
                
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
}


@end
