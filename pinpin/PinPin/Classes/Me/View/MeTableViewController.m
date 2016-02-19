//
//  MeTableViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/17.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "MeTableViewController.h"

@interface MeTableViewController ()

@end

@implementation MeTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self viewInit];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
}
-(void)viewInit{
    
    if([[Config Instance] isLogin]){
        _name.text = [SYSTEM_USERDEFAULTS objectForKey:Y_name];
        _phone.text = [NSString stringWithFormat:@"手机号：%@" ,[SYSTEM_USERDEFAULTS objectForKey:Y_phone]];
    }else{
        _name.text = @"游客";
        _phone.text = [NSString stringWithFormat:@"手机号：%@" ,@"15800000000"];
    }
    
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
        return 1.0f;
    return 10.0f;
}


- (NSString*) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    } else {
        // return some string here ...
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![[Config Instance] isLogin]){
        UIStoryboard * storyBoard =  [UIStoryboard storyboardWithName:@"UserHandle" bundle:nil];
        ShareAppDelegate.window.rootViewController = [storyBoard instantiateInitialViewController];
    }

    
}


@end
