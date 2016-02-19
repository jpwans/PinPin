//
//  UserHandle.h
//  PinPin
//
//  Created by MoPellet on 15/7/14.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
@interface UserHandle : NSObject
+ (UserHandle*)instance;
/**
 *  是否首次登陆
 */
-(BOOL)isFirstStart;
/*
 *验证码倒计时
 */
-(void)startTimeWithButton:(UIButton *)authCodeButton;
/**
 *  发送验证码
 */
-(void)sendAuthCodeWithPhone:(NSString *)phone;
/**
 *短信验证码验证
 */
-(void)authCodeValidationWithPhone:(NSString *)phone code:(NSString *)code withCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;

/**
 *登陆
 */
-(void) loginWithUserInfo:(UserInfo *)userInfo withCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;

/**
 *注销
 */
//-(void) loginOutWithCompletionHandler: (void (^)(NSDictionary *dictionary,NSError *error))block;
-(void)logout;
/**
 *注册
 */
-(void)registerWithUserInfo:(UserInfo *)userInfo withCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;
/**
 *忘记密码
 */
-(void)forgetPasswordWithUserInfo:(UserInfo *)userInfo withCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;
/**
 *修改密码
 */
-(void)updatePasswordWithUserInfo:(UserInfo *)userInfo withCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;
@end
