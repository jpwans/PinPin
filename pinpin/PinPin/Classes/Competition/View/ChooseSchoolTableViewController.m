//
//  ChooseSchoolTableViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/24.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "ChooseSchoolTableViewController.h"
#import "ChooseTableViewController.h"
@interface ChooseSchoolTableViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSMutableArray *schoolArray;
@end

@implementation ChooseSchoolTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.tableFooterView = [UIView new];
    [self getSchoolArray];
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"Default"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"该站点没有添加任何学校学校";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"请点击返回之后重新选择对应的站点";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0]};
    
    return [[NSAttributedString alloc] initWithString:@"返回" attributes:attributes];
}


- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return BACKGROUND_COLOR;
}
-(void)getSchoolArray{
    
    [[CompetitionHandle instance]getSchoolInfoWithOfficeId:_office.officeId WithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
                if (dictionary[Y_Data]) {
                    if (dictionary[Y_Data][@"records"]) {
                        dictionary =dictionary[Y_Data][@"records"];
                        _schoolArray = [NSMutableArray new];
                        for (NSDictionary *dict in dictionary) {
                            // 创建模型对象
                            School *school = [School objectWithKeyValues:dict];
                            // 添加模型对象到数组中
                            [_schoolArray addObject:school];
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
    return _schoolArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"show";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    //数据显示
    School *school = _schoolArray[indexPath.row];
    // 设置cell的数据
    cell.textLabel.text = school.schoolName;
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
    School *school = _schoolArray[indexPath.row];
    NSArray *viewControllers=[self.navigationController viewControllers];
    ChooseTableViewController *popVC=[viewControllers objectAtIndex:viewControllers.count-2];
    popVC.school = school;
    popVC.chooseType = C_School;
    [self.navigationController popToViewController:popVC animated:YES];
    
}

@end
