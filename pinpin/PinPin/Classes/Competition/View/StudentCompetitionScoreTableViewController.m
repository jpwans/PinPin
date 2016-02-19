//
//  StudentCompetitionScoreTableViewController.m
//  PinPin
//
//  Created by MoPellet on 15/8/8.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "StudentCompetitionScoreTableViewController.h"
#import "StudentScoreTableViewCell.h"
#import "AnswerDetailsTableViewController.h"
@interface StudentCompetitionScoreTableViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray *scoreArrays;
@end

@implementation StudentCompetitionScoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getScoreArrays];
    [self viewInit];
}
-(void)viewInit{
    self.title = @"考试信息";
}
-(void)getScoreArrays{
    [[CompetitionHandle instance] getStudentCompetitionInfoWithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            if ([dictionary[Y_Code] integerValue] ==Y_Code_Success) {
                if (dictionary[Y_Data][Y_Records]) {
                    dictionary = dictionary[Y_Data][Y_Records];
                    _scoreArrays  = [NSMutableArray new];
                    for (NSDictionary *dict  in dictionary) {
                        StudentScore *studenScore = [StudentScore objectWithKeyValues:dict];
                        [_scoreArrays addObject:studenScore];
                    }
                    [self.tableView reloadData];
                }
                else{
                    [self.view makeToast:@"没有查到您的分数，请稍后再查！" duration:1.5f position:@"center"];
                }
            }
            else{
                [MBProgressHUD showError:dictionary[Y_Message]];
            }
        }
        else{
            [MBProgressHUD showError:[error localizedDescription]];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _scoreArrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentScore *studentScore = _scoreArrays[indexPath.row];
    // 1.创建cell
    StudentScoreTableViewCell *cell =[StudentScoreTableViewCell cellWithTableView:tableView];
    // 2.设置数据
    [cell settingData:studentScore ];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerDetailsTableViewController *answerDetailsTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AnswerDetailsTableViewController"];
    answerDetailsTableViewController.studentScore =_scoreArrays[indexPath.row];
    [self.navigationController pushViewController:answerDetailsTableViewController animated:YES];
}
@end
