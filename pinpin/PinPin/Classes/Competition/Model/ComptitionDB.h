//
//  ComptitionDB.h
//  PinPin
//
//  Created by MoPellet on 15/8/23.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ComptitionDB : NSManagedObject  //竞赛表

@property (nonatomic, retain) NSString * cId;//主健， uuid生成
@property (nonatomic, retain) NSString * comptitonId;
@property (nonatomic, retain) NSString * comptitonName;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * createUser;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSString * groupType;
@property (nonatomic, retain) NSString * testType;
@property (nonatomic, retain) NSString * isSubmit;  //是否提交

@end
