//
//  CoreDateManager.h
//  PropertyOwnerClient
//
//  Created by MoPellet on 15/5/29.
//  Copyright (c) 2015年 neo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RecordDB.h"
#import "ComptitionDB.h"
#import "QuestionBank.h"
#import "LibraryBank.h"
#import "LibraryBankDB.h"
#import "QuestionBankDB.h"
#define RecordTable @"RecordDB"
#define LibraryTable @"LibraryDB"
#define ComptitionTable @"ComptitionDB"
#define QuestionBankTable @"QuestionBankDB"
#define LibraryBankTbale @"LibraryBankDB"
#define DatabaseName  @"pp_comptition.sqlite"
#define Model  @"pp_comptition"
#import "FMDB.h"
@interface CoreDateManager : NSObject
@property (nonatomic, strong) FMDatabase *db;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDateManager*)instance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
/**
 *插入ComptitionDB数据
 */
- (NSString *)insertComptitionDB:(Competition *)competition;
/**
 *插入libraryBank数据
 */
- (void)insertLibraryDB:(QuestionBank*)questionBank cId:(NSString *)cId;
/**
 *获取UUID
 */
+(NSString*)uuid;
/**
 *下载题目
 */
-(void)downloadWith:(Competition *)competition TestStatus:(TestStatus )testStatus WithCompletionHandler:(void (^)())block;
/**
 *
 */
-(NSString *)isCheckHaveTestStatus:(TestStatus )testStatus;
/**
 *  查询模拟考试的数据
 */
-(NSMutableArray *)queryTestArraysWithcId:(NSString *)cId;
/**
 *  查询模拟考试的数据结果
 */
-(NSMutableArray *)queryTestResultArraysWithcId:(NSString *)cId;
/**
 *  查询正式考试考试的数据结果
 */
-(NSMutableArray *)queryFormalTestResultArraysWithcId:(NSString *)cId :(NSArray *)testArray;
/**
 *  查询模拟次数
 */
-(NSString *)getSimulationCountWith:(NSString *)cId;

/**
 *添加到记录表
 */
-(void)insertRecordDB:(RecordModel *)recordModel;

/**
 *根据CID删除记录表
 */
-( BOOL)deleteRecordDB:(NSString *)cId;
/**
 *查询时候有记录
 */
-(BOOL)queryRecordDB:(NSString *)cId;
/**
 *根据LibraryTypeId 查分数
 */
-(NSString *)queryScoreByLibraryTypeId:(NSString *)LibraryTypeId;
/**
 *  LibraryBankId 查正确选项
 */
-(NSString *)queryTrueChooseByLibraryBankId:(NSString *)LibraryBankId;
/**
 *查询得分
 */
-(Scores * )queryScore:(NSString *)cId;
/**
 *  查询记录表里面当前赛事有没有提交
 */
-(int )queryCount:(NSString *)cId;
/**
 *删除所有数据 不包括记录表
 */
-(void)deleteAllData:(NSString *)cId;


@end