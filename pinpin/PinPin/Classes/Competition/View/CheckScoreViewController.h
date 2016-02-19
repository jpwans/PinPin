//
//  CheckScoreViewController.h
//  PinPin
//
//  Created by MoPellet on 15/7/29.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Competition.h"
@interface CheckScoreViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic)   ImagePlayerView *imagePlayerView;
@property (strong, nonatomic)  UITextField *checkScoreTextField;

@property (strong, nonatomic)  UIButton *queryButton;
- (void)queryAction:(UIButton *)sender;



@property (strong, nonatomic)  UIView *studentView;
@property (strong, nonatomic)  UIButton *qualifiedButton;
@property (strong, nonatomic)  UILabel *nameLable;
@property (strong, nonatomic)  UILabel *groupLable;
@property (strong, nonatomic)  UILabel *totalScoreLable;
@property (strong, nonatomic)  UILabel *fractionalLineLable;
@property (strong, nonatomic)  UILabel *errorLable;
@property (strong, nonatomic)  UILabel *correctLable;
@property (strong, nonatomic)  UILabel *officeRankingLable;
@property (strong, nonatomic)  UILabel *schoolRankingLable;
@end
