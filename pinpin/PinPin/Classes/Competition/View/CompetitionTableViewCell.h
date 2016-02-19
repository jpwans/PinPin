//
//  CompetitionTableViewCell.h
//  PinPin
//
//  Created by MoPellet on 15/7/30.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+NEO.h"
@interface CompetitionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
//@property (weak, nonatomic) IBOutlet UIImageView *angleImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (nonatomic, strong) UILabel *statusUILabel;



-(void)settingData:(Competition *)competition ;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
