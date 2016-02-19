//
//  ToolKit.h
//  PinPin
//
//  Created by MoPellet on 15/7/15.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolKit : NSObject
+ (ToolKit*)instance;
/**
 *给UIView加上下边框
 */
-(void)drawBottomBorderWithUIView:(UIView *)view Color:(UIColor *)color;

-(void)drawBottomBorderWithButton:(UIButton *)button Color:(UIColor *)color;
/**
 *字符串转日期
 */
+(NSDate*) convertDateFromString:(NSString*)inputString formatter:(NSString *)formatterString;
/**
 *获取当前时间字符串
 */
+(NSString *)getNowTimeWithFormat:(NSString *)format;
/**
 *  时间戳转为时间
 */
+(NSString *)timeStampConversion:(double )timeStamp;

+(NSString *)timeStampConversionDate:(double )timeStamp;
/**
 *数字转中文
 */
-(NSString *)withNum:(NSInteger )num;
//// 将JSON串转化为字典或者数组
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/**
 *  index    转ABC
 */
-(NSString *)withABC:(NSInteger )index;


/**
 *  ABC转Index
 */
-(NSString *)withIndex:(NSString* )ABC;

/**
 *字符串转数组
 */
-(NSMutableArray *)arrayWithString:(NSString *)string;
/**
 *数组转字符串
 */
-(NSString *)stringWithArray :(NSMutableArray *)array;
@end
