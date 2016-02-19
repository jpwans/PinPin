//
//  UILabel+NEO.h
//  PinPin
//
//  Created by liuneo on 16/1/12.
//  Copyright © 2016年 MoPellt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (NEO)


/**
*  创建一个动态高度的UILabel
*
*  @param pointX        Label的横坐标
*  @param pointY        Label的纵坐标
*  @param width         Label的宽度
*  @param strContent    内容
*  @param color         字体颜色
*  @param font          字体大小
*  @param textAlignmeng 对齐方式
*
*  @return 返回一个UILabel
*/
+ (UILabel *)dynamicHeightLabelWithPointX:(CGFloat)pointX
                                   pointY:(CGFloat)pointY
                                    width:(CGFloat)width
                               strContent:(NSString *)strContent
                                    color:(UIColor *)color
                                     font:(UIFont *)font
                            textAlignmeng:(NSTextAlignment)textAlignmeng;

@end
