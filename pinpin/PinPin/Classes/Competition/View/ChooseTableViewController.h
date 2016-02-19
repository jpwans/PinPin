//
//  ChooseTableViewController.h
//  PinPin
//
//  Created by MoPellet on 15/7/24.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Competition.h"
@interface ChooseTableViewController : UITableViewController
@property (nonatomic, strong) Office *office;
@property (nonatomic, strong) School *school;
@property (nonatomic, strong)  Group *group;
@property (nonatomic, assign) int  chooseType;
@property (weak, nonatomic) IBOutlet UILabel *officeLable;
@property (weak, nonatomic) IBOutlet UILabel *schoolLable;
@property (weak, nonatomic) IBOutlet UILabel *groupLable;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)doneAction:(id)sender;

@property (weak, nonatomic) IBOutlet ImagePlayerView *imagePlayerView;

//@property (nonatomic, strong) Competition *competition;
@end
