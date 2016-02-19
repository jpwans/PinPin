//
//  SetTableViewController.h
//  PinPin
//
//  Created by MoPellet on 15/7/17.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetTableViewController : UITableViewController
- (IBAction)logoutAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *name;

@end
