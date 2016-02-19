//
//  MyCompetitionViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/28.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "MyCompetitionViewController.h"
#define SegmentedHeight 50
#import "AlreadyMatchTableView.h"
#import "AlreadySignUpTableView.h"
#import "CheckScoreViewController.h"
@interface MyCompetitionViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) AlreadySignUpTableView *signUpTableView;
@property (nonatomic, strong) AlreadyMatchTableView *matchTableView;
@property(nonatomic,strong) NSMutableArray *alreadySignUpArrays;
@property(nonatomic,strong) NSMutableArray *alreadyMatchArrays;
@end

@implementation MyCompetitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}

-(void)viewInit{
    
    self.title = @"我的竞赛";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    CGFloat viewHeight =SCREEN_HEIGHT-NAVIGATION_HEIGHT-STATUS_HEIGHT-SegmentedHeight;
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGHT+STATUS_HEIGHT, viewWidth, SegmentedHeight)];
    self.segmentedControl.sectionTitles = @[@"已报名", @"已比赛"];
    self.segmentedControl.selectedSegmentIndex = 1;
    
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    
    UIFont* font = [UIFont fontWithName:@"Arial-ItalicMT" size:16.0];
    NSDictionary* textAttributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:[UIColor grayColor]};
    self.segmentedControl.titleTextAttributes =textAttributes;
    
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    self.segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8];
    self.segmentedControl.selectionIndicatorColor =THEME_COLOR;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, 200) animated:YES];
    }];
    
    [self.view addSubview:self.segmentedControl];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGHT+STATUS_HEIGHT+SegmentedHeight, viewWidth,viewHeight )];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(viewWidth * 2, 200);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(viewWidth, 0, viewWidth, 200) animated:NO];
    [self.view addSubview:self.scrollView];
    
    _signUpTableView = [[AlreadySignUpTableView alloc] initWithFrame:CGRectMake(0, 8, viewWidth, viewHeight)];
    [self.scrollView addSubview:_signUpTableView];
    _signUpTableView.backgroundColor = BACKGROUND_COLOR;
    _signUpTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _matchTableView = [[AlreadyMatchTableView alloc] initWithFrame:CGRectMake(viewWidth, 8, viewWidth, viewHeight)];
    [self.scrollView addSubview:_matchTableView];
    _matchTableView.backgroundColor = BACKGROUND_COLOR;
    _matchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self reloadTableView];
    
    /**
     *注册监听
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popViewController) name:Notif_Back object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkRow:) name:Notif_SendValue object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView) name:Notif_RefreshCompetition object:nil];
}

-(void)checkRow:(NSNotification *)note{
    Competition *competition =[[note userInfo] objectForKey:@"Competition"];
    ShareAppDelegate.SignUpCompetition = nil;
    ShareAppDelegate.SignUpCompetition = competition;
    UIViewController *signUpDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpDetailsViewController"];
    [self.navigationController pushViewController:signUpDetailsViewController animated:YES];
//    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970]*1000;
//    NSTimeInterval competitionStart = [competition.competitionStart doubleValue];
//    NSTimeInterval competitionEnd = [competition.competitionEnd doubleValue];
//    switch ([competition.status intValue]) {
//        case StudentStatusAlreadySignUp:{
//            //已报名
//            //赛事开始时间未到 参加模拟比赛
//            if ((competitionStart-nowTime)>0) {
//                SimulationMatchViewController * simulationMatchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SimulationMatchViewController"];
//                simulationMatchViewController.competition = competition;
//                [self.navigationController pushViewController:simulationMatchViewController animated:YES];
//            }
//            //赛事开始时间到了 并且赛事结束时间未到 参加正式比赛
//            else if ( (competitionStart-nowTime)<=0 && (competitionEnd-nowTime)>0){
//                NSLog(@"参加正式比赛");
//                FormalMatchViewController *formalMatchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FormalMatchViewController"];
//                formalMatchViewController.competition = competition;
//                [self.navigationController pushViewController:formalMatchViewController animated:YES];
//            }
//            //赛事结束时间到了 显示错过比赛页面
//            else if((competitionEnd-nowTime)<0){
//                [MBProgressHUD showError:@"您已经错过了比赛"];
//            }
//        }
//            break;
//        case  StudentStatusAlreadyMatch:{
//            //已比赛
//            //竞赛还没结束 等待查分
//            if ((competitionEnd-nowTime)>0) {
//                NSLog(@"等待查分");
//            }
//            //竞赛已结束 查分
//            else if((competitionEnd-nowTime)<=0){
//                CheckScoreViewController * checkScoreViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckScoreViewController"];
//                checkScoreViewController .competition = competition;
//                [self.navigationController pushViewController:checkScoreViewController animated:YES];
//            }
//        }
//            break;
//        default:
//            break;
//    }
    
    
}

-(void)reloadTableView{
    _alreadySignUpArrays = [NSMutableArray new];
    _alreadyMatchArrays = [NSMutableArray new];
//    [MBProgressHUD showMessage:@"加载中..."];
    [[CompetitionHandle instance]findStudentStatusWithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            [MBProgressHUD hideHUD];
            NSLog(@"%@",dictionary);
            if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
                if (dictionary[Y_Data]) {
                    if (dictionary[Y_Data][Y_Records]) {
                        dictionary = dictionary[Y_Data][Y_Records];
                        for (NSDictionary *dict in dictionary) {
                            // 创建模型对象
                            Competition  *competition = [Competition objectWithKeyValues:dict ];
                            if ([competition.status  intValue]==StudentStatusAlreadySignUp) {
                                [_alreadySignUpArrays addObject:competition];
                            }
                            else if([competition.status intValue]==StudentStatusAlreadyMatch){
                                [_alreadyMatchArrays addObject:competition];
                            }
                        }
                        
                        _signUpTableView.arrays = _alreadySignUpArrays;
                        [_signUpTableView reloadData];
                        _matchTableView.arrays = _alreadyMatchArrays;
                        [_matchTableView reloadData];
                        
                    }
                }
            }
            else{
                [MBProgressHUD showError:dictionary[Y_Message]];
            }
        }
        else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:[error localizedDescription]];
        }
    }];
}
-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    //    NSLog(@"当前选中:%ld", (long)segmentedControl.selectedSegmentIndex);
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notif_Back object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notif_SendValue object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notif_RefreshCompetition object:nil];
    
}

@end
