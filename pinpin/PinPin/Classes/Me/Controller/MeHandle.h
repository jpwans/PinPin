//
//  MeHandle.h
//  PinPin
//
//  Created by MoPellet on 15/7/17.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeHandle : NSObject
+ (MeHandle*)instance;
/**
*修改个人信息
 */
-(void)updatePersonalInfoWithUserInfo:(UserInfo *)userInfo  withCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;
/**
 *获取token
 */
-(void) getTokenWithCompletionHandler: (void (^)(NSDictionary *dictionary,NSError *error))block;
/**
 *  修改头像
 */
-(void)updateHeadPhoto:(NSString *)photoKey WithCompletionHandler: (void (^)(NSDictionary *dictionary,NSError *error))block;
/**
 *上传头像到气流云
 */
-(void)uploadheadPhoto:(NSData *)imageData;
/**
 *  上传意见反馈
 */
-(void)uploadFeedback:(NSString *)text WithCompletionHandler: (void (^)(NSDictionary *dictionary,NSError *error))block;
/**
 *删除报名信息
 */
-(void)deleteCompetition:(Competition *)competition WithCompletionHandler: (void (^)(NSDictionary *dictionary,NSError *error))block;
@end
