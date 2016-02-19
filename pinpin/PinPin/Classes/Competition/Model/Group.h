//
//  Group.h
//  PinPin
//
//  Created by MoPellet on 15/7/21.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SignUpInfo : NSObject
@property (nonatomic, copy) NSString *officeId;
@property (nonatomic, copy) NSString *schoolId;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *comptitionId;
@property (nonatomic, copy) NSString *compCode;
@property (nonatomic, copy) NSString *studentCode;
@end

@interface Office : NSObject
@property (nonatomic, copy) NSString *officeId;
@property (nonatomic, copy) NSString *officeName;
@end



@interface School : NSObject
@property (nonatomic, copy) NSString *schoolId;
@property (nonatomic, copy) NSString *schoolName;
@end


@interface Group : NSObject
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *groupValue;
@end
