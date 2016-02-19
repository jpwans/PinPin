//
//  TestTableViewCell.h
//  PinPin
//
//  Created by MoPellet on 15/8/10.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioButton.h"
#import "AudioPlayer.h"
#import "RadioButton.h"
@interface TestTableViewCell : UITableViewCell<RadioButtonDelegate> 
@property (strong, nonatomic)  AudioButton *audioButton;
@property (strong, nonatomic)  UILabel *titleNum;
@property (strong, nonatomic)  UILabel *textDesc;
@property(strong,nonatomic) NSString *groupId;
-(void)settingData:(QuestionBank *)questionBank  cellRow :(NSInteger )row;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
