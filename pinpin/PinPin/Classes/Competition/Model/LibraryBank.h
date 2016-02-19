//
//  LibraryBank.h
//  PinPin
//
//  Created by MoPellet on 15/8/1.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibraryBank : NSObject
@property (nonatomic, copy) NSString *libraryBankAnswers;
@property (nonatomic, copy) NSString *libraryBankChoice;
@property (nonatomic, copy) NSString *libraryBankChoiceType;
@property (nonatomic, copy) NSString *libraryBankContent;
@property (nonatomic, copy) NSString *libraryBankId;
@property (nonatomic, copy) NSString *libraryBankPic;
@property (nonatomic, copy) NSString *libraryBankVoice;


@property (nonatomic, copy) NSString * isTrue;  //0错的  1 对的
@property (nonatomic, copy) NSString * myChoose;// 我的选择

@property (nonatomic, copy) NSString * correctChoose;// 正确
@property (nonatomic, copy) NSString * libraryTypeId;// 不合格传过来的

@end


@interface ChoiceContent : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *option;
@end