//
//  UserHandle.m
//  PinPin
//
//  Created by MoPellet on 15/7/14.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "UserHandle.h"

@implementation UserHandle
static UserHandle *instance = nil;

+ (UserHandle*)instance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[super alloc] init];
    });
    return instance;
}
/**
 *  是否首次登陆
 */
-(BOOL)isFirstStart{
    if (![SYSTEM_USERDEFAULTS boolForKey:Y_IsFirstStart]) {
        [SYSTEM_USERDEFAULTS setBool:YES forKey:Y_IsFirstStart];//设置成yes以后再也不进入
        return YES;
    }
//    else{
        return NO;
//    }
}
-(void)startTimeWithButton:(UIButton *)authCodeButton{
    __block int timeout=30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [authCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                authCodeButton.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                [authCodeButton setTitle:[NSString stringWithFormat:@"获取验证码(%@)",strTime] forState:UIControlStateNormal];
                authCodeButton.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}
-(void)sendAuthCodeWithPhone:(NSString *)phone{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error){
                                     if (!error) {
                                         [MBProgressHUD showSuccess:@"验证码发送成功！"];
                                     }
                                     else{
                                         [MBProgressHUD showError:@"验证码发送失败！"];
                                     }
                                 }];
//    
//    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone zone:ZONE customIdentifier:nil result:^(NSError *error) {
//        
//        if (!error) {
//            [MBProgressHUD showSuccess:@"验证码发送成功！"];
//        }
//        else{
//            [MBProgressHUD showError:@"验证码发送失败！"];
//        }
//        
//    }];
    
//ios9以前的用法
//    [SMSSDK getVerificationCodeBySMSWithPhone:phone
//                                          zone:ZONE
//                                        result:^(SMS_SDKError *error)
//     {
//         if (!error) {
//             [MBProgressHUD showSuccess:@"验证码发送成功！"];
//         }
//         else{
//             [MBProgressHUD showError:@"验证码发送失败！"];
//         }
//     }];
    
}

-(void)authCodeValidationWithPhone:(NSString *)phone code:(NSString *)code withCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block
{
    
    
    [SMSSDK commitVerificationCode:code phoneNumber:phone zone:ZONE result:^(NSError *error) {
       
        if (!error) {
            NSDictionary *dictionary= [NSDictionary dictionaryWithObjectsAndKeys:@"200",@"status", nil];
            if (block) {
                block(dictionary,nil);
            }
        }{
            if (block) {
                block([NSDictionary dictionary],error);
            }
        
        }
    }];
 
  //mob.com v1.1.1以前版本
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:SMSAPPKEY ,@"appkey",phone,@"phone" ,ZONE,@"zone",code,@"code",nil];
//    [manager POST:URL_SMS_AUTH parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dictionary= responseObject;
//        if (block) {
//            block(dictionary,nil);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",[error localizedDescription]);
//        if (block) {
//            block([NSDictionary dictionary],error);
//        }
//    }];
}
/**
 *登陆
 */
-(void) loginWithUserInfo:(UserInfo *)userInfo withCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    userInfo.password = [DES3Util encrypt:userInfo.password];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userInfo.phone,@"phone",
                                userInfo.password,@"password",nil];

    [manager POST:API_BASE_URL_STRING(URL_Login) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary= responseObject;
        if (block) {
            block(dictionary,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        if (block) {
            block([NSDictionary dictionary],error);
        }
    }];
}


//-(void) loginOutWithCompletionHandler: (void (^)(NSDictionary *dictionary,NSError *error))block
//{
//    
//}
-(void)logout{
    [[Config Instance] removeObjectFromUserDefaults];
    UIStoryboard * storyBoard =  [UIStoryboard storyboardWithName:@"UserHandle" bundle:nil];
    ShareAppDelegate.window.rootViewController = [storyBoard instantiateInitialViewController];
}
/**
 *注册
 */
-(void)registerWithUserInfo:(UserInfo *)userInfo withCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    userInfo.password = [DES3Util encrypt:userInfo.password];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.name ,@"name",userInfo.phone,@"phone" ,userInfo.password,@"password",nil];
    [manager POST:API_BASE_URL_STRING(URL_Register) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary= responseObject;
        if (block) {
            block(dictionary,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        if (block) {
            block([NSDictionary dictionary],error);
        }
    }];
}
/**
 *忘记密码
 */
-(void)forgetPasswordWithUserInfo:(UserInfo *)userInfo withCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    userInfo.password = [DES3Util encrypt:userInfo.password];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.phone,@"phone" ,userInfo.password,@"password",nil];
    [manager POST:API_BASE_URL_STRING(URL_ForgetPassword) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary= responseObject;
        if (block) {
            block(dictionary,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        if (block) {
            block([NSDictionary dictionary],error);
        }
    }];
}
/**
 *修改密码
 */
-(void)updatePasswordWithUserInfo:(UserInfo *)userInfo withCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [RestClient getAFHTTPRequestOperationManagerPutheaderPost];
    userInfo.password = [DES3Util encrypt:userInfo.password];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.password,@"newPassword" ,[SYSTEM_USERDEFAULTS objectForKey:Y_password],@"password",nil];
    [manager POST:API_BASE_URL_STRING(URL_UpdatePassword) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary= responseObject;
        if (block) {
            block(dictionary,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        if (block) {
            block([NSDictionary dictionary],error);
        }
    }];
}
@end
