//
//  AnswerDetailsTableViewController.m
//  PinPin
//
//  Created by MoPellet on 15/8/8.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "AnswerDetailsTableViewController.h"
#import "AnswerDetailsTableViewCell.h"
@interface AnswerDetailsTableViewController ()
@property(strong,nonatomic) NSMutableArray *answerArrays;
@end

@implementation AnswerDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"答题详情";
    [self getAnswerArrays];
}

-(void)getAnswerArrays{

[[CompetitionHandle instance] getAnswerDetails:_studentScore WithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
    if (!error) {
        NSLog(@"%@",dictionary);
        if ([dictionary[Y_Code] integerValue] ==Y_Code_Success) {
            if (dictionary[Y_Data][Y_Records]) {
                dictionary = dictionary[Y_Data][Y_Records];
                _answerArrays  = [NSMutableArray new];
                for (NSDictionary *dict  in dictionary) {
                    AnsWerDetails *ansWerDetails = [AnsWerDetails objectWithKeyValues:dict];
                    [_answerArrays addObject:ansWerDetails];
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
    return _answerArrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnsWerDetails *ansWerDetails = _answerArrays[indexPath.row];
    // 1.创建cell
    AnswerDetailsTableViewCell *cell =[AnswerDetailsTableViewCell cellWithTableView:tableView];
    // 2.设置数据
    [cell settingData:ansWerDetails ];
    return cell;
}



@end
