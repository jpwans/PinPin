//
//  CompetitionTableViewCell.m
//  PinPin
//
//  Created by MoPellet on 15/7/30.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "CompetitionTableViewCell.h"





@implementation CompetitionTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = BACKGROUND_COLOR;
    _bannerImageView.layer.masksToBounds = YES;
    _bannerImageView.layer.cornerRadius = 6.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)settingData:(Competition *)competition {

    NSURL *url =  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_QINIU,competition.icon]];
    [_bannerImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Default"]];
    
//    _statusUILabel.frame = CGRectMake(_bannerImageView.frame.size.width-10, statusHight, 80, 20);
    
    
   
    
    
    NSString *statusText = @"";
    switch ([competition.status intValue]) {
        case StudentStatusNotSignUp:
        {
//            _angleImageView.image = [UIImage imageNamed:@"Figure-angle_red"];
            statusText = @"未报名";
            [self addStatusLabel:statusText];
            break;
        }
           
        case StudentStatusAlreadySignUp:
        {
//            _angleImageView.image = [UIImage imageNamed:@"Figure-angle"];
            statusText = @"已报名";
            [self addStatusLabel:statusText];
            break;
        }
            
        case StudentStatusAlreadyMatch:
        {
//            _angleImageView.image = [UIImage imageNamed:@"Figure-angle_blue"];
            statusText = @"已参赛";
            [self addStatusLabel:statusText];
            break;
        }
            
        default:
            break;
    }
}

-(void)addStatusLabel:(NSString*)statusText
{
    _statusUILabel = [UILabel dynamicHeightLabelWithPointX:SCREEN_WIDTH-80 pointY:BannerHeight*13/16 width:50 strContent:statusText color:[UIColor whiteColor] font:[UIFont fontWithName:@"Helvetica" size:16.0] textAlignmeng:NSTextAlignmentLeft];
    [_bannerImageView addSubview:_statusUILabel];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"status";
    CompetitionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CompetitionTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
