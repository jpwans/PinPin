//
//  UpdateSexTableViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/19.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "UpdateSexTableViewController.h"
#import "PersonalInfoTableViewController.h"
@interface UpdateSexTableViewController ()<UITableViewDelegate>
@property (nonatomic, assign)   int sexIndex;
@end

@implementation UpdateSexTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}

-(void)viewInit{
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    _sexIndex = [[SYSTEM_USERDEFAULTS objectForKey:Y_sex] intValue];
    
    if (_sexIndex==1) {
        _maleImageView.image = [UIImage imageNamed:@"check_true"];
        _femaleImageView.image = [UIImage imageNamed:@""];
    }
    else{
        _femaleImageView.image = [UIImage imageNamed:@"check_true"];
        _maleImageView.image = [UIImage imageNamed:@""];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int status =(int)indexPath.row;
    
    switch (status) {
        case 0:
        {
         
            [self saveWithSex:Y_sex_male];
        }
            break;
        case 1:{
             [self saveWithSex:Y_sex_female];

        }
            
        default:
            break;
    }
}
-(void)saveWithSex:(NSString *)sex{
    NSArray *viewControllers=[self.navigationController viewControllers];
    PersonalInfoTableViewController *popVC=[viewControllers objectAtIndex:viewControllers.count-2];
    popVC.updateType = P_sex;
    [self.navigationController popToViewController:popVC animated:YES];
    
    UserInfo *userInfo = [UserInfo new];
    userInfo.sex =sex;
    [SYSTEM_USERDEFAULTS setObject:sex forKey:Y_sex];
    [SYSTEM_USERDEFAULTS synchronize];
    [[MeHandle instance ] updatePersonalInfoWithUserInfo:userInfo withCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
                NSLog(@"%@",dictionary[Y_Message]);
    
            }
            else{
                [MBProgressHUD showError:dictionary[Y_Message]];
            }
        }else{
            [MBProgressHUD showError:NetError];
            
        }
    }];
    
}
@end
