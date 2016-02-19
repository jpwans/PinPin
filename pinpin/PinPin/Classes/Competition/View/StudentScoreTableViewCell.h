//
//  StudentScoreTableViewCell.h
//  PinPin
//
//  Created by MoPellet on 15/8/8.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentScoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *competitionName;

-(void)settingData:(StudentScore *)studentScore ;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
