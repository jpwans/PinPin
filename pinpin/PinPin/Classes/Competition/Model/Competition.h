//
//  Competition.h
//  PinPin
//
//  Created by MoPellet on 15/7/20.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Competition : NSObject
@property (nonatomic, copy) NSString *attendEnd;
@property (nonatomic, copy) NSString *attendStart;
@property (nonatomic, copy) NSString *compStatus;
@property (nonatomic, copy) NSString *competitionEnd;
@property (nonatomic, copy) NSString *competitionStart;
@property (nonatomic, copy) NSString *comptitonCode;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *isNewRecord;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *compId;
@property (nonatomic, copy) NSString *compCode;
@property (nonatomic, copy) NSString *comptitionId;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *officeId;
@property (nonatomic, copy) NSString *officeName;
@property (nonatomic, copy) NSString *partCode;//查分数
@property (nonatomic, copy) NSString *partId;
@property (nonatomic, copy) NSString *schoolId;
@property (nonatomic, copy) NSString *schoolName;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *stuName;
@property (nonatomic, copy) NSString *studentCode;
@property (nonatomic, copy) NSString *studentId;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *comptitionRemarks;
@property (nonatomic, copy) NSString *duration;
@end

/**
 *  查分
 */
@interface StudentScore: NSObject
@property (nonatomic, copy) NSString *compName;
@property (nonatomic, copy) NSString *comptitionId;
@property (nonatomic, copy) NSString *correctNum;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *groupValue;
@property (nonatomic, copy) NSString *mistakeNum;
@property (nonatomic, copy) NSString *officeId;
@property (nonatomic, copy) NSString *officeName;
@property (nonatomic, copy) NSString *partCode;
@property (nonatomic, copy) NSString *partId;
@property (nonatomic, copy) NSString *schoolId;
@property (nonatomic, copy) NSString *schoolName;
@property (nonatomic, copy) NSString *schoolRank;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *scoreLine;
@property (nonatomic, copy) NSString *stationRank;
@property(nonatomic, copy)  NSString *studentId;
@property(nonatomic, copy)  NSString *studentName;
@end

@interface AnsWerDetails : NSObject
@property (nonatomic, copy) NSString *correctChoose;
@property (nonatomic, copy) NSString *libraryBankId;
@property (nonatomic, copy) NSString *libraryTypeId;
@property (nonatomic, copy) NSString *myChoose;

@end

@interface RecordModel : NSObject
@property (nonatomic, retain) NSString * cId;
@property (nonatomic, retain) NSString * isTrue;
@property (nonatomic, retain) NSString * libraryBankId;
@property (nonatomic, retain) NSString * myChoose;
@property (nonatomic, retain) NSString * recordId;
@property (nonatomic, retain) NSString * score;
@property (nonatomic, retain) NSString * simulationCount;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * answerTime;
@property (nonatomic, retain) NSString * updateTime;
@end

@interface Scores : NSObject
@property (nonatomic, assign) int  trueCount;
@property (nonatomic, assign) int  errorCount;
@property (nonatomic, assign) float  score;
@end

