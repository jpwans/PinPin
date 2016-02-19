//
//  UILabel+NEO.m
//  PinPin
//
//  Created by liuneo on 16/1/12.
//  Copyright © 2016年 MoPellt. All rights reserved.
//

#import "UILabel+NEO.h"

@implementation UILabel (NEO)


//动态设置Label的高度
+ (UILabel *)dynamicHeightLabelWithPointX:(CGFloat)pointX
                                   pointY:(CGFloat)pointY
                                    width:(CGFloat)width
                               strContent:(NSString *)strContent
                                    color:(UIColor *)color
                                     font:(UIFont *)font
                            textAlignmeng:(NSTextAlignment)textAlignmeng
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [strContent boundingRectWithSize:CGSizeMake(width,MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributes
                                                context:nil].size;
    
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointX, pointY, width, labelSize.height)];
    [myLabel setNumberOfLines:0];
    myLabel.text = strContent;
    myLabel.font = font;
    myLabel.textColor = color;
    return myLabel;
    
}

@end
