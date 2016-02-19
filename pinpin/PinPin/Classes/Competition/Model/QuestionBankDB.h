//
//  QuestionBankDB.h
//  PinPin
//
//  Created by MoPellet on 15/8/12.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface QuestionBankDB : NSManagedObject

@property (nonatomic, retain) NSString * chosenType;
@property (nonatomic, retain) NSString * libraryDescription;
@property (nonatomic, retain) NSString * librarySetting;
@property (nonatomic, retain) NSString * libraryTypeId;
@property (nonatomic, retain) NSString * score;
@property (nonatomic, retain) NSString * choiceShowType;
@property (nonatomic, retain) NSString * cId;
@property (nonatomic, retain) NSString * subjectId; //主键

@end
