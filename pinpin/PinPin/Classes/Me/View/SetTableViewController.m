//
//  SetTableViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/17.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "SetTableViewController.h"

@interface SetTableViewController ()<UIActionSheetDelegate>

@end

@implementation SetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
   
        _name.text = [SYSTEM_USERDEFAULTS objectForKey:Y_name];
    
    
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 6.0;
    _headImageView.layer.borderWidth = 1.0;
    _headImageView.layer.borderColor = [[UIColor clearColor] CGColor];
    UIImage *savedImage =  [UIImage imageWithData:[SYSTEM_USERDEFAULTS objectForKey:Y_headPhoto]];
    UIImage *defaultImage = savedImage?savedImage:[UIImage imageNamed:@"Default"];
    NSString  *photoId=  [SYSTEM_USERDEFAULTS objectForKey:Y_photo];
    _headImageView.layer.contents = (id)[defaultImage CGImage];
    if (0==photoId.length) return;
    NSString *urlStr  = [NSString stringWithFormat:@"%@%@",URL_QINIU,photoId];
    NSURL *url = [NSURL URLWithString:urlStr];;
    [self.headImageView sd_setImageWithURL:url placeholderImage:defaultImage];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0)
        return 0.1f;
    return 10;
}

- (IBAction)logoutAction:(id)sender {
    UIActionSheet  *sheet = [[UIActionSheet alloc] initWithTitle:@"退出后不会删除任何历史数据，下次登陆依然可以使用本账号。" delegate:self cancelButtonTitle:@"容我想想" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}

#pragma mark actions
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [MBProgressHUD showMessage:@"正在退出。。。"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
                   [[UserHandle instance]logout];
        });
 
    }
}
@end
