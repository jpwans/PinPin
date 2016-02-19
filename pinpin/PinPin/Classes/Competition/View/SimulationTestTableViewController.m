//
//  SimulationTestTableViewController.m
//  PinPin
//
//  Created by MoPellet on 15/8/7.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "SimulationTestTableViewController.h"
#import "TopLable.h"
#import "TestTableViewCell.h"
#import "UIView+Toast.h"

#define fontHeight 14 //字体高度 字体多大就多高
@interface SimulationTestTableViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) NSMutableArray *testArrays;
@property(nonatomic,assign)BOOL timeOver;
@property (nonatomic ,strong)   UIAlertView *alertView ;
@property (nonatomic ,strong) UIButton * assistiveTouch;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation SimulationTestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView =[ [UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    
    self.tableView.dataSource =self;
    self.tableView.delegate =self;
    _assistiveTouch = [UIButton buttonWithType:UIButtonTypeCustom];
    _assistiveTouch.adjustsImageWhenHighlighted = NO;
    _assistiveTouch.frame = CGRectMake(SCREEN_WIDTH-46, SCREEN_HEIGHT-50-70, 50, 50);
    [_assistiveTouch setImage:[UIImage imageNamed:@"icon_滑动"] forState:UIControlStateNormal];
    [_assistiveTouch addTarget:self action:@selector(toucheIn:) forControlEvents:UIControlEventTouchUpInside];
    _assistiveTouch.alpha = 0.8;
    [self.view addSubview:_assistiveTouch];
    [self.view bringSubviewToFront:_assistiveTouch];
    

    ShareAppDelegate.answerDictionary = [NSMutableDictionary new];
    
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
    UIBarButtonItem *item1 =    [[UIBarButtonItem alloc ] initWithTitle:@"交卷" style:UIBarButtonItemStylePlain target:self action:@selector(submitTest)];
    UILabel *countdownLabe = [UILabel new];
    countdownLabe.frame = CGRectMake(0,0, 50, 30);
    [countdownLabe setTextColor:THEME_COLOR ];
    UIBarButtonItem *item3 =[[UIBarButtonItem alloc] initWithCustomView:countdownLabe];
    
    self.navigationItem.rightBarButtonItems = @[item1,item3];
    
    if (!_isHave) {
        [self startTimeWithButton:countdownLabe];
    }
    
    //将返回按钮的文字position设置不在屏幕上显示
    //    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    //       self.navigationItem.backBarButtonItem
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backUpClick) ];
    
    self.navigationItem.leftBarButtonItem = leftBar;
        [self getTestArrays];
}
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//}

-(void)toucheIn:(UIButton *)button{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)backUpClick{
    if (_timeOver) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        _alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您确定返回，并提交吗？" delegate:self cancelButtonTitle:@"容我想想" otherButtonTitles:@"我要交卷", nil];
        [_alertView show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==111) {
        if (buttonIndex==1) {
            //   chakan
//               [self.view makeToast:@"查看分数" duration:1.5f position:@"center"];
            //   1、查询
            //   2、错题
            //   3、 
//            NSLog(@"%@",ShareAppDelegate.cId);
            ShareAppDelegate.answerDictionary = nil;
             ShareAppDelegate.answerDictionary = [NSMutableDictionary new];
            _testArrays = [[NSMutableArray alloc] init];
      _testArrays =        [[CoreDateManager instance]  queryTestResultArraysWithcId:ShareAppDelegate.cId];
            
            [self.tableView reloadData];
            self.navigationItem.rightBarButtonItems  =nil;
            self.navigationItem.leftBarButtonItem=nil;
            
            _timeOver = YES;
        }
    }
    else{
        if (buttonIndex==1) {
            [self submitTest];
            //交卷并返回
            _timeOver = YES;
        }
    }

    
    
}

-(void)startTimeWithButton:(UILabel *)authCodeButton{
    
    
    __block int timeout=[ShareAppDelegate.SignUpCompetition.duration intValue] *60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        //超时 或者 离开答题界面（_timeOver ＝ yes），应关闭计时器
        if (timeout <= 0 || _timeOver == YES) {
            dispatch_source_cancel(_timer);
            //设置界面的按钮显示 根据自己需求设置
            [authCodeButton setText:@"00:00"];
            _timeOver = YES;
        }
        
        if(timeout<=0 && _timeOver == YES) { //倒计时结束，关闭
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_alertView dismissWithClickedButtonIndex:0 animated:YES];
                [self submitTest];
            });
        }else{
            _timeOver = NO;
            int minutes = timeout / 60;
            NSString *minutesStr = minutes>10?[NSString stringWithFormat:@"%d",minutes]:[NSString stringWithFormat:@"0%d",minutes];
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [authCodeButton setText:[NSString stringWithFormat:@"%@:%@",minutesStr,strTime] ];
            });
            timeout--;
        }
        
    });
    dispatch_resume(_timer);
}

/**
 *提交试卷
 */
-(void)submitTest{
    //已经提交不能再交
   int  count =  [[CoreDateManager instance]queryCount:ShareAppDelegate.cId];

    if (count) {
        [MBProgressHUD showSuccess:@"您已经提交过试卷。"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    //交卷并返回
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    for (int i=0; i<_testArrays.count; i++) {
        QuestionBank *questionBank = [_testArrays objectAtIndex:i];
        NSString *libraryTypeId = questionBank.libraryTypeId;
        for (int n = 0; n<questionBank.libraryBankArrays.count; n++) {
            LibraryBank *libraryBank =[questionBank.libraryBankArrays objectAtIndex:n];
            NSString *   libraryBankId = libraryBank.libraryBankId;
            NSString *key =[NSString stringWithFormat:@"%@_%@",libraryTypeId,libraryBankId];
            if(![[ShareAppDelegate.answerDictionary  allKeys] containsObject:key]){
                [ShareAppDelegate.answerDictionary  setObject:@"-1" forKey:key];
            }
        }
    }
    NSLog(@"%@",ShareAppDelegate.answerDictionary);
    NSString *simulationCount= [[CoreDateManager instance] getSimulationCountWith:ShareAppDelegate.cId];
    //    NSMutableDictionary *answerdict = [NSMutableDictionary new];
    //    NSMutableArray *answerArrays = [NSMutableArray new];
    for (id key in ShareAppDelegate.answerDictionary) {
        
        NSArray * urlArray = [key componentsSeparatedByString:@"_"];
        
        NSString *libraryTypeId = [urlArray firstObject];//通过libraryTypeId查分数 sql 语句
        //        NSLog(@"---------libraryTypeId:%@",libraryTypeId);
        NSString *trueScore = [[CoreDateManager instance] queryScoreByLibraryTypeId:libraryTypeId];
        NSString *libraryBankId = [urlArray lastObject];//通过libraryBankId  去数据库查正确选项
        NSString *trueChoose =  [[CoreDateManager instance] queryTrueChooseByLibraryBankId:libraryBankId];
        
        NSMutableArray *chooseArrays  =  [[ToolKit instance] arrayWithString:[ShareAppDelegate.answerDictionary objectForKey:key] ];
        
        NSArray *array = [chooseArrays sortedArrayUsingComparator:cmptr];
        
        NSMutableArray *chooseAnd = [NSMutableArray new];
        for ( int n=0; n<array.count;n++) {
            NSString *choose =[[ToolKit instance] withABC:[[array  objectAtIndex:n] integerValue]];
            [chooseAnd addObject:choose];
        }
        NSString *myChoose =[NSString new];
        
        for (int i = 0; i<chooseAnd.count; i++) {
            myChoose = [NSString stringWithFormat:@"%@%@",myChoose,chooseAnd[i]];
        }
        //
        //        NSLog(@"------------myChoose:%@",myChoose); //根据选项查询当前的正确选项
        //判断插入记录表 正确就加分   错误就是0分;
        RecordModel  * recordModel = [RecordModel new];
        recordModel.cId = ShareAppDelegate.cId;
        recordModel.isTrue = @"0";
        recordModel.libraryBankId = libraryBankId;
        recordModel.myChoose = myChoose;
        recordModel.score = @"0";
        recordModel.recordId = [CoreDateManager uuid];
        recordModel.simulationCount = simulationCount;
        if ([trueChoose isEqualToString:myChoose]) {
            recordModel.isTrue = @"1";
            recordModel.score = trueScore;
        }
        //插入到记录表
        [[CoreDateManager instance] insertRecordDB:recordModel];
    }
    
    
    
    
//    [MBProgressHUD showMessage:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUD];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        Scores *scores =     [[CoreDateManager instance] queryScore:ShareAppDelegate.cId];
        NSString *title = [NSString stringWithFormat:@"你当前考试考了%.1f分！",scores.score];
        NSString *message = [NSString stringWithFormat:@"做对了%d题，做错了%d题！",scores.trueCount,scores.errorCount];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"查看", nil];
        alertView.tag =111;
        [alertView show];
    });
    
}

-(void)getTestArrays{
//    [MBProgressHUD showMessage:@"正在加载中..."];
    [MBProgressHUD showMessage:@"正在加载中..." toView:self.view];
    
    
    self.tableView.backgroundColor =BACKGROUND_COLOR;
    _testArrays = [NSMutableArray new];
    //    _testArrays = ShareAppDelegate.testArrays;
    
    if (_isHave) {
        ShareAppDelegate.answerDictionary = nil;
        ShareAppDelegate.answerDictionary = [NSMutableDictionary new];
        _testArrays =        [[CoreDateManager instance]  queryTestResultArraysWithcId:ShareAppDelegate.cId];
        self.navigationItem.rightBarButtonItems =nil;
        self.navigationItem.leftBarButtonItem = nil;
    }
    else{
    _testArrays=  [[CoreDateManager instance]  queryTestArraysWithcId:ShareAppDelegate.cId];
    }
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT+NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [view setBackgroundColor:[UIColor whiteColor]];
//    [view setBackgroundColor:TEST_SMALLBACKGROUND_COLOR];
    view.alpha=1;
    [window addSubview:view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [view removeFromSuperview];
        [MBProgressHUD hideHUDForView:self.view];
    });
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //    return 1;
    return _testArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    return _testArrays.count;
    QuestionBank *questionBank = _testArrays[section];
    return questionBank.libraryBankArrays.count;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor clearColor];
}

/**
 *大题高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    QuestionBank *questionBank = _testArrays[section];
    NSString * chosenString = [[NSString alloc] init];
    switch ([[questionBank chosenType] intValue]) {
        case ChosenTypeSingle:
            chosenString =@"单选";
            break;
        case ChosenTypeMore:
            chosenString =@"多选";
            break;
        case ChosenTypeMultiple:
            chosenString =@"不定项";
            break;
        default:
            break;
    }
    
    NSString *string = [NSString stringWithFormat:@"%@、%@(%@，每题%@分)\n",   [[ToolKit instance]  withNum:section +1],questionBank.libraryDescription,chosenString,questionBank.score];
    UIFont *font = [UIFont systemFontOfSize:fontHeight];
  
   CGSize heightSize= [string sizeForString:string font:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ];
    
    return heightSize.height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    UILabel *lable = [UILabel new];
    QuestionBank *questionBank = _testArrays[section];
    NSString * chosenString = [[NSString alloc] init];
    switch ([[questionBank chosenType] intValue]) {
        case ChosenTypeSingle:
            chosenString =@"单选";
            break;
        case  ChosenTypeMore:
            chosenString =@"多选";
            break;
        case ChosenTypeMultiple:
            chosenString =@"不定项";
            break;
        default:
            break;
    }
    
    
    NSString *string = [NSString stringWithFormat:@"%@、%@(%@，每题%@分)\n",   [[ToolKit instance]  withNum:section +1],questionBank.libraryDescription,chosenString,questionBank.score];
    [lable setText:string];
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:fontHeight];
    // 計算出顯示完內容需要的最小尺寸
//    CGSize heightSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize heightSize= [string sizeForString:string font:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ];
    
    lable.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, heightSize.height);
    [lable setTextAlignment:NSTextAlignmentCenter];
    lable.font =  [UIFont boldSystemFontOfSize: fontHeight];
    lable.numberOfLines = 0;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:2];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
    [lable setAttributedText:attributedString1];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, heightSize.height);
    view.backgroundColor = TEST_BIGBACKGROUND_COLOR;
    [view addSubview:lable];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestTableViewCell *cell = (TestTableViewCell *)[self tableView:tableView  cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
    QuestionBank *questionBank = _testArrays[indexPath.section];
    // 1.创建cell
    TestTableViewCell *cell =[TestTableViewCell cellWithTableView:tableView];
    // 2.设置数据
    [cell settingData:questionBank  cellRow : indexPath.row ];
    return cell;
}





@end
