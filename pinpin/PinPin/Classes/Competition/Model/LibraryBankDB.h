//
//  LibraryBankDB.h
//  PinPin
//
//  Created by MoPellet on 15/8/12.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LibraryBankDB : NSManagedObject

@property (nonatomic, retain) NSString * libraryBankAnswers;
@property (nonatomic, retain) NSString * libraryBankChoice;
@property (nonatomic, retain) NSString * libraryBankChoiceType;
@property (nonatomic, retain) NSString * libraryBankContent;
@property (nonatomic, retain) NSString * libraryBankId;
@property (nonatomic, retain) NSString * libraryBankPic;
@property (nonatomic, retain) NSString * libraryBankVoice;
@property (nonatomic, retain) NSString * subjectId; //外键

@end
