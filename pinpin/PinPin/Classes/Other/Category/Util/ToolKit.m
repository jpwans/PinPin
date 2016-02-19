//
//  ToolKit.m
//  PinPin
//
//  Created by MoPellet on 15/7/15.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "ToolKit.h"

@implementation ToolKit
static ToolKit *instance = nil;

+ (ToolKit*)instance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[super alloc] init];
    });
    return instance;
}
-(void)drawBottomBorderWithUIView:(UIView *)view Color:(UIColor *)color{
    CALayer *bottomBorder = [CALayer layer];
    CGFloat  hight = view.frame.size.height - 1;
    bottomBorder.frame = CGRectMake(0.0f, hight, view.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = color.CGColor;
    [view.layer addSublayer:bottomBorder];
}

-(void)drawBottomBorderWithButton:(UIButton *)button Color:(UIColor *)color{
    CALayer *bottomBorder = [CALayer layer];
    CGFloat  hight = button.frame.size.height - 1;
    bottomBorder.frame = CGRectMake(0.0f, hight, 70, 1.0f);
    bottomBorder.backgroundColor = color.CGColor;
    [button.layer addSublayer:bottomBorder];
}

+(NSDate*) convertDateFromString:(NSString*)inputString formatter:(NSString *)formatterString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:formatterString];
    NSDate *date=[formatter dateFromString:inputString];
    return date;
}

+(NSString *)getNowTimeWithFormat:(NSString *)format{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:format];
    return [dateformatter stringFromDate:senddate];
}


+(NSString *)timeStampConversion:(double )timeStamp{
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:timeStamp/1000];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

+(NSString *)timeStampConversionDate:(double )timeStamp{
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:timeStamp/1000];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}
/**
 *数字转中文
 */
-(NSString *)withNum:(NSInteger )num{
    NSString *str ;
    switch (num) {
        case 1:
            str =@"一";
            break;
        case 2:
            str =@"二";
            break;
        case 3:
            str =@"三";
            break;
        case 4:
            str =@"四";
            break;
        case 5:
            str =@"五";
            break;
        case 6:
            str =@"六";
            break;
        case 7:
            str =@"七";
            break;
        case 8:
            str =@"八";
            break;
        case 9:
            str =@"九";
            break;
        case 10:
            str =@"十";
            break;
        default:
            break;
    }
    return str;
}
/**
 *  index    转ABC
 */
-(NSString *)withABC:(NSInteger )index{
    NSString *str ;
    switch (index) {
        case 0:
            str =@"A";
            break;
        case 1:
            str =@"B";
            break;
        case 2:
            str =@"C";
            break;
        case 3:
            str =@"D";
            break;
        case 4:
            str =@"E";
            break;
        case 5:
            str =@"F";
            break;
        case 6:
            str =@"G";
            break;
        case 7:
            str =@"H";
            break;
        case 8:
            str =@"I";
            break;
        case 9:
            str =@"J";
            break;
        case 10:
            str =@"K";
            break;
            case -1:
            str = @"-1";
            break;
        default:
            break;
    }
    return str;
}


/**
 *  ABC转Index
 */
-(NSString *)withIndex:(NSString * )ABC{

    NSString *str ;
    if ([ABC isEqualToString:@"A"]) {
        str=@"0";
    }
    if ([ABC isEqualToString:@"B"]) {
        str=@"1";
    }

    if ([ABC isEqualToString:@"C"]) {
        str=@"2";
    }

    if ([ABC isEqualToString:@"D"]) {
        str=@"3";
    }

    if ([ABC isEqualToString:@"E"]) {
        str=@"4";
    }

    if ([ABC isEqualToString:@"F"]) {
        str=@"5";
    }
        return str;
}


//// 将JSON串转化为字典或者数组
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(NSMutableArray *)arrayWithString:(NSString *)string{
return     [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByString:NSLocalizedString(@",", nil)]];
}

-(NSString *)stringWithArray :(NSMutableArray *)array{
return [array componentsJoinedByString:@","];
}

@end
