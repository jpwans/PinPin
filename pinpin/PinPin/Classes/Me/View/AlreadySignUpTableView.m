//
//  AlreadySignUpTableView.m
//  PinPin
//
//  Created by MoPellet on 15/7/28.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "AlreadySignUpTableView.h"
#import "CompetitionTableViewCell.h"
@implementation AlreadySignUpTableView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        self.dataSource =self;
        self.delegate=self;
    }
    return self;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"Default"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您没有报名任何竞赛";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"请前往竞赛报名";
    
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
    
    return [[NSAttributedString alloc] initWithString:@"点我返回" attributes:attributes];
}


- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter]      postNotificationName:Notif_Back    object:nil];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return BACKGROUND_COLOR;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrays.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Competition *competition = self.arrays[indexPath.row];
    // 1.创建cell
    CompetitionTableViewCell *cell =[CompetitionTableViewCell cellWithTableView:tableView];
    // 2.设置数据
    [cell settingData:competition];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BannerHeight +8;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Competition *competition = _arrays[indexPath.row];
    NSDictionary *comDic = [NSDictionary dictionaryWithObject:competition forKey:@"Competition"];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notif_SendValue object:self userInfo:comDic];

}


@end
