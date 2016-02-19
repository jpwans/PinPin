//
//  QuestionBank.h
//  PinPin
//
//  Created by MoPellet on 15/8/1.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibraryBank.h"


@interface QuestionBank : NSObject
@property (nonatomic, copy) NSString *choiceShowType;
@property (nonatomic, copy) NSString *chosenType;
@property (nonatomic, strong) NSMutableArray *libraryBankArrays;
@property (nonatomic, copy) NSString *libraryDescription;
@property (nonatomic, copy) NSString *librarySetting;
@property (nonatomic, copy) NSString *libraryTypeId;
@property (nonatomic, copy) NSString *score;
@end



