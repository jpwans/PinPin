//
//  ChooseGroupTableViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/24.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "ChooseGroupTableViewController.h"
#import "ChooseTableViewController.h"
#import "Group.h"
@interface ChooseGroupTableViewController ()<UITableViewDelegate,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *groupArray;
@end

@implementation ChooseGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getGroupArray];
}

-(void)getGroupArray{
    [[CompetitionHandle instance]getGroupWithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
                if (dictionary[Y_Data]) {
                    if (dictionary[Y_Data][@"records"]) {
                        dictionary =dictionary[Y_Data][@"records"];
                        _groupArray = [NSMutableArray new];
                        for (NSDictionary *dict in dictionary) {
                            // 创建模型对象
                            Group *group = [Group objectWithKeyValues:dict];
                            // 添加模型对象到数组中
                            [_groupArray addObject:group];
                        }
                        [self.tableView reloadData];
                        
                    }
                }
            }
        }
        else{
            [MBProgressHUD showError:NetError];
        }
    }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _groupArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"show";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    //数据显示
    Group *group = _groupArray[indexPath.row];
    // 设置cell的数据
    cell.textLabel.text = group.groupName;
    // 设置cell右边指示器的类型
    cell.accessoryType = UITableViewCellAccessoryNone;
    UIView *V = [[UIView alloc] init];
    V.frame = CGRectMake(0, 43, SCREEN_WIDTH, 1);
    V.backgroundColor = RGBCOLOR(227, 228, 228);
    [cell addSubview:V];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Group *group = _groupArray[indexPath.row];
    NSArray *viewControllers=[self.navigationController viewControllers];
    ChooseTableViewController *popVC=[viewControllers objectAtIndex:viewControllers.count-2];
    popVC.group = group;
    popVC.chooseType = C_Group;
    [self.navigationController popToViewController:popVC animated:YES];
    
}

@end
