//
//  StudentScoreTableViewCell.m
//  PinPin
//
//  Created by MoPellet on 15/8/8.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "StudentScoreTableViewCell.h"

@implementation StudentScoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)settingData:(StudentScore *)studentScore {
   _competitionName.text = studentScore.compName;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"status";
    StudentScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StudentScoreTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
