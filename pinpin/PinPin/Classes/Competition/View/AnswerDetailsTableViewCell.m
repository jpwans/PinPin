//
//  AnswerDetailsTableViewCell.m
//  PinPin
//
//  Created by MoPellet on 15/8/8.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "AnswerDetailsTableViewCell.h"

@implementation AnswerDetailsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)settingData:(AnsWerDetails *)ansWerDetails {
    _myChoose.text = ansWerDetails.myChoose;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"status";
    AnswerDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AnswerDetailsTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
