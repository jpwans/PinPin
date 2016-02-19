//
//  RecordDB.h
//  PinPin
//
//  Created by MoPellet on 15/8/4.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RecordDB : NSManagedObject  //考试记录表

@property (nonatomic, retain) NSString * cId;//外健
@property (nonatomic, retain) NSString * isTrue;  //0错的  1 对的
@property (nonatomic, retain) NSString * libraryBankId; //
@property (nonatomic, retain) NSString * myChoose;// 我的选择
@property (nonatomic, retain) NSString * recordId;//记录ID
@property (nonatomic, retain) NSString * score;//分数
@property (nonatomic, retain) NSString * simulationCount;//模拟次数
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * answerTime;
@property (nonatomic, retain) NSString * updateTime;

@end
