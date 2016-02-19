//
//  CompetitionHandle.h
//  PinPin
//
//  Created by MoPellet on 15/7/20.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Group.h"
@interface CompetitionHandle : NSObject
@property (strong, nonatomic) MKNetworkOperation *downloadOperation;
+ (CompetitionHandle*)instance;
/**
 *获取赛事
 */
-(void)getComptitionWithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;


/**
 *获取单个学生竞赛状态
 */
-(void)findStudentStatusForOneCompWithCompletionHandler:(NSString *)compitionId WithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;

/**
 *获取学生状态
 */
-(void)findStudentStatusWithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;


/**
 *获取竞赛列表
 */
-(void)getComptitionsWithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;


/**
 *学生报名
 */
-(void)signUpWith:( SignUpInfo*)signUpInfo  WithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;

/**
 *  获取站点
 */
-(void)getOfficeInfoWithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;
/**
 *获取学校
 */
-(void)getSchoolInfoWithOfficeId:(NSString *)officeId WithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;
/**
 *  获取人群组
 */
-(void)getGroupWithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;

/**
 *获取题库
 */
-(void)getLibrarhyBanksCompetition:(Competition*)competition TestStatus:(TestStatus )testStatus WithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;
/**
 *获取学生竞赛信息  查分
 */
-(void)getStudentCompetitionInfoWithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;
/**
 *  根据竞赛编号获取学生信息
 */
-(void)getStudentInfoByCode:(NSString *)partCode WithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;
/**
 *  获取答题详情
 */
-(void)getAnswerDetails:(StudentScore *)studentScore WithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;
/**
 *提交题库
 */
-(void)submitTest:(NSDictionary *)parameters WithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block;
@end
