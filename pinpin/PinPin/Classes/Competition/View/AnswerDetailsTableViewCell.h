//
//  AnswerDetailsTableViewCell.h
//  PinPin
//
//  Created by MoPellet on 15/8/8.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myChoose;

-(void)settingData:(AnsWerDetails *)ansWerDetails ;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
