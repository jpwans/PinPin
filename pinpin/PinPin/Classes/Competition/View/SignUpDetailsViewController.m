//
//  SignUpDetailsViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/31.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "SignUpDetailsViewController.h"
#import "ChooseTableViewController.h"
#import "CheckScoreViewController.h"
#import "FormalTestTableViewController.h"
#import "SimulationTestTableViewController.h"
@interface SignUpDetailsViewController ()<ImagePlayerViewDelegate,MWPhotoBrowserDelegate>
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, strong) NSMutableArray *arrays;
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation SignUpDetailsViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     [self viewiInit];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:DatabaseName];
}

//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    [MBProgressHUD hideHUD];
//}

-(void)viewiInit{
    
    self.title =@"赛事介绍";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = BACKGROUND_COLOR;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    _contentScrollView.backgroundColor = BACKGROUND_COLOR;
    _contentScrollView.showsVerticalScrollIndicator = NO;//设置垂直滚动条
    
//    [MBProgressHUD showMessage:@"正在加载中..." toView:self.view];
    [MBProgressHUD showHUDAddedTo:_contentScrollView animated:YES];
    
    
//    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT+NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [view setBackgroundColor:BACKGROUND_COLOR];
//    view.alpha=1;
//    [window addSubview:view];
    
 if([[Config Instance] isLogin]){
     
    
    [[CompetitionHandle instance]findStudentStatusForOneCompWithCompletionHandler:ShareAppDelegate.SignUpCompetition.comptitionId WithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            
            if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
                if (dictionary[Y_Data]) {
                            dictionary = dictionary[Y_Data];
                       
                            Competition  *competition = [Competition objectWithKeyValues:dictionary ];
                             ShareAppDelegate.SignUpCompetition  = competition;
                    
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self setSignUpButton];
                    [self setImagePlayerView];
                    [self createDescribeView];
//                    [view removeFromSuperview];
                    [MBProgressHUD hideHUDForView:self.view];
                });
            }
            else{
//                [view removeFromSuperview];
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showError:dictionary[Y_Message]];
            }
        }
        else{
//            [view removeFromSuperview];
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:[error localizedDescription]];
        }
    }];
     
     
 }else{
     [self setSignUpButton];
     [self setImagePlayerView];
     [self createDescribeView];
     [MBProgressHUD hideHUDForView:self.view];
 }
    
}
/*
 *图片轮播
 */
-(void)setImagePlayerView{
    _imagePlayerView = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, ImagePlayerHeight)];
    _imagePlayerView .backgroundColor = [UIColor grayColor];
    [_contentScrollView addSubview:_imagePlayerView];
    if (ShareAppDelegate.competition) {
        NSArray * array = [ShareAppDelegate.SignUpCompetition.photo componentsSeparatedByString:@"&#"];
        NSMutableArray *photoArray  = [NSMutableArray new];
        for (int i=0; i<array.count-1; i++) {
            [photoArray addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_QINIU,array[i]]]];
        }
        [self ImageViewWithArray:photoArray];
        _imageURLs = photoArray;
    }
    else{
        [self ImageViewWithArray:nil];
    }
}

/**
 *  设置报名按钮
 */
-(void)setSignUpButton{
    _signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];;
    _signUpButton.frame =CGRectMake(0, SCREEN_HEIGHT-44-64, SCREEN_WIDTH, 44);
    _signUpButton.backgroundColor = THEME_COLOR;
    _signUpButton.adjustsImageWhenHighlighted = NO;
    [_signUpButton setTitle:@"点击报名" forState:UIControlStateNormal];
    
    [self.view addSubview:_signUpButton];
    if([[Config Instance] isLogin]){
        
    }else{
        [_signUpButton setTitle:@"点击开始报名" forState:UIControlStateNormal];
        [_signUpButton addTarget:self action:@selector(signUpAction) forControlEvents:UIControlEventTouchUpInside];
        return;
    }
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSTimeInterval attendStart = [ShareAppDelegate.SignUpCompetition.attendStart doubleValue];
    NSTimeInterval attendEnd = [ShareAppDelegate.SignUpCompetition.attendEnd doubleValue];
    NSTimeInterval competitionStart = [ShareAppDelegate.SignUpCompetition.competitionStart doubleValue];
    NSTimeInterval competitionEnd = [ShareAppDelegate.SignUpCompetition.competitionEnd doubleValue];
    switch ([ShareAppDelegate.SignUpCompetition.status intValue]) {
        case StudentStatusNotSignUp:
        {
            /**
             *  未报名在报名的开始时间和结束时间之间才能报名
             */
            if ((attendStart-nowTime)<=0&&(attendEnd-nowTime)>0) {
                //未报名
                [_signUpButton setTitle:@"点击开始报名" forState:UIControlStateNormal];
                [_signUpButton addTarget:self action:@selector(signUpAction) forControlEvents:UIControlEventTouchUpInside];
            }
            else if((attendStart-nowTime)>0){
                [_signUpButton setTitle:@"报名还未开始" forState:UIControlStateNormal];
            }
            else if((attendEnd-nowTime)<0){
                [_signUpButton setTitle:@"报名已结束" forState:UIControlStateNormal];
            }
        }
            break;
        case StudentStatusAlreadySignUp:{
            //已报名
            [self createBtn];
            //赛事开始时间未到 参加模拟比赛
            if ((competitionStart-nowTime)>0) {
                [_signUpButton setTitle:@"前往参加模拟比赛" forState:UIControlStateNormal];
                //                      [_signUpButton addTarget:self action:@selector(checkScore) forControlEvents:UIControlEventTouchUpInside];
                [_signUpButton addTarget:self action:@selector(jumpSimulationMatch) forControlEvents:UIControlEventTouchUpInside];
                //                                [_signUpButton addTarget:self action:@selector(jumpFormalMatch) forControlEvents:UIControlEventTouchUpInside];
            }
            //赛事开始时间到了 并且赛事结束时间未到 参加正式比赛
            else if ( (competitionStart-nowTime)<=0 && (competitionEnd-nowTime)>0){
                self.navigationItem.rightBarButtonItem = nil;
                [_signUpButton setTitle:@"前往参加正式比赛" forState:UIControlStateNormal];
                [_signUpButton addTarget:self action:@selector(jumpFormalMatch) forControlEvents:UIControlEventTouchUpInside];
            }
            //赛事结束时间到了 显示错过比赛页面
            else if((competitionEnd-nowTime)<0){
                self.navigationItem.rightBarButtonItem = nil;
                [_signUpButton setTitle:@"比赛已结束" forState:UIControlStateNormal];
            }
        }
            break;
        case  StudentStatusAlreadyMatch:{
            //已比赛
            //竞赛还没结束 等待查分
            self.navigationItem.rightBarButtonItem = nil;
            if ((competitionEnd-nowTime)>0) {
                [_signUpButton setTitle:@"等待查分" forState:UIControlStateNormal];
            }
            //竞赛已结束 查分
            else if((competitionEnd-nowTime)<=0){
                
                [_signUpButton setTitle:@"前往查分" forState:UIControlStateNormal];
                [_signUpButton addTarget:self action:@selector(checkScore) forControlEvents:UIControlEventTouchUpInside];
            }
        }
            break;
        default:
            break;
    }
}
/**
 *  报名
 */
-(void)signUpAction{
    
    if([[Config Instance] isLogin]){
        ChooseTableViewController *chooseTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseTableViewController"];
        [self.navigationController pushViewController:chooseTableViewController animated:YES];
    }else{
        UIStoryboard * storyBoard =  [UIStoryboard storyboardWithName:@"UserHandle" bundle:nil];
        ShareAppDelegate.window.rootViewController = [storyBoard instantiateInitialViewController];
    }
   
}
/**
 *查分
 */
-(void)checkScore{
    CheckScoreViewController * checkScoreViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckScoreViewController"];
    [self.navigationController pushViewController:checkScoreViewController animated:YES];
}
/**
 *  正式比赛
 */
-(void)jumpFormalMatch{
    ShareAppDelegate.cId =    [[CoreDateManager instance] isCheckHaveTestStatus:TestStatusFormal];
    FormalTestTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FormalTestTableViewController"];
    ShareAppDelegate.testArrays =[NSMutableArray new];
    if (ShareAppDelegate.cId) {//存在 跳转到比赛页面
        //        ShareAppDelegate.testArrays=  [[CoreDateManager instance]  queryTestArraysWithcId:cId];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [[CoreDateManager instance] downloadWith:ShareAppDelegate.SignUpCompetition TestStatus:TestStatusFormal WithCompletionHandler:^{
            ShareAppDelegate.cId =    [[CoreDateManager instance] isCheckHaveTestStatus:TestStatusFormal];
            //            ShareAppDelegate.testArrays=  [[CoreDateManager instance]  queryTestArraysWithcId:cId];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    
}
/**
 *  模拟比赛
 */
-(void)jumpSimulationMatch{
    ShareAppDelegate.cId=    [[CoreDateManager instance] isCheckHaveTestStatus:TestStatusSimulation];
    SimulationTestTableViewController  *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SimulationTestTableViewController"];
    
    ShareAppDelegate.testArrays =[NSMutableArray new];
    
//    UIView  *view = [[UIApplication sharedApplication].windows lastObject];
////    [self.view bringSubviewToFront:view];
//    [view setTag:99];
//    [MBProgressHUD showMessage:@"考题正在加载中..." toView:view];
    
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = @"考题正在加载中...";
//    hud.margin = 10.f;
//    hud.yOffset = self.view.frame.size.height/4;
//    hud.removeFromSuperViewOnHide = YES;

//    [MBProgressHUD showMessage:@"考题正在加载中..." toView:[self activityViewController].view];
    
    
    if (ShareAppDelegate.cId) {//存在 跳转到比赛页面
        
        /**
         *  既然本地数据库中有就是参加了 既然参加了应该显示的就是题目答题完成之后的内容
         */
//        ShareAppDelegate.cId=    [[CoreDateManager instance] isCheckHaveTestStatus:TestStatusSimulation];
//        //根据CID删除数据库
//        [[CoreDateManager instance] deleteRecordDB:ShareAppDelegate.cId];
    vc.isHave=    [[CoreDateManager instance] queryRecordDB:ShareAppDelegate.cId];
        
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [[CoreDateManager instance] downloadWith:ShareAppDelegate.SignUpCompetition TestStatus:TestStatusSimulation WithCompletionHandler:^{
            ShareAppDelegate.cId =    [[CoreDateManager instance] isCheckHaveTestStatus:TestStatusSimulation];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
}


//获取当前屏幕显示的viewcontroller
// 获取当前处于activity状态的view controller
- (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}


-(void)createDescribeView{
    
    UIView *describeView = [UIView new];
    
    UIView *intervalView = [UIView new];
    intervalView .frame =CGRectMake(0, 0, SCREEN_WIDTH, 8);
    intervalView .backgroundColor = BACKGROUND_COLOR;
    [describeView addSubview:intervalView];
    
#define fontHeight 16 //字体高度 字体多大就多高
    
    UILabel *lable = [UILabel new];
    NSString *string  =[NSString stringWithFormat:@"%@",
                        ShareAppDelegate.SignUpCompetition.name];
    [lable setText:string];
    lable.textColor = RGBACOLOR(0, 0, 0, 0.9);
    // 用何種字體進行顯示
    UIFont *font =SystemFont(fontHeight)
    // 計算出顯示完內容需要的最小尺寸
//    CGSize heightSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    
    CGSize heightSize= [string sizeForString:string font:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ];
    
    lable.frame = CGRectMake(10, fontHeight/2+ intervalView.frame.size.height, SCREEN_WIDTH-20, heightSize.height+4);
    
    [lable setTextAlignment:NSTextAlignmentCenter];
    lable.font = SystemFont(fontHeight)
    lable.numberOfLines = 0;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:2];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
    [lable setAttributedText:attributedString1];
    
    
    int status = [ShareAppDelegate.SignUpCompetition.status intValue];
    
    CGFloat  infoHeight = 0  ;
    if(status == StudentStatusAlreadySignUp || status==StudentStatusAlreadyMatch){
        
        
        NSString  *no = [NSString stringWithFormat:@"编号：%@", ShareAppDelegate.SignUpCompetition.partCode];
        NSString  *group = [NSString stringWithFormat:@"组别：%@-%@-%@",ShareAppDelegate.SignUpCompetition.officeName,ShareAppDelegate.SignUpCompetition.schoolName,ShareAppDelegate.SignUpCompetition.groupName];
        
        UILabel *noLable =[UILabel new];
        noLable.font = SystemFont(14);
        [noLable setText: no];
        noLable.frame = CGRectMake(20, lable.frame.origin.y+lable.frame.size.height, SCREEN_WIDTH-20, 20);
        [describeView addSubview:noLable];
        
        UILabel *groupLable =[UILabel new];
        groupLable.font = SystemFont(14);
        [groupLable setText: group];
        groupLable.frame = CGRectMake(20, noLable.frame.origin.y+ noLable.frame.size.height , SCREEN_WIDTH-20, 20);
        [describeView addSubview:groupLable];
        infoHeight = groupLable.frame.origin.y+ groupLable.frame.size.height-noLable.frame.origin.y;
        
        noLable.textColor = RGBACOLOR(0, 0, 0, 0.72);
        groupLable.textColor = RGBACOLOR(0, 0, 0, 0.72);
    }
    
    UIView *intervalView2 = [UIView new];
    intervalView2 .frame =CGRectMake(0, lable.frame.origin.y+lable.frame.size.height + infoHeight , SCREEN_WIDTH, 8);
    intervalView2 .backgroundColor = BACKGROUND_COLOR;
    [describeView addSubview:intervalView2];
    
    UIImageView *startSignUPImage =[UIImageView new];
    startSignUPImage.frame  = CGRectMake(10, intervalView2.frame.origin.y+intervalView2.frame.size.height+5+2, 14, 14);
    startSignUPImage.image = [UIImage imageNamed:@"icon_enroll"];
    [describeView addSubview:startSignUPImage];
    //
    UILabel *startLable =[UILabel new];
    startLable.font = SystemFont(fontHeight);
    NSString *attendStart = [[ToolKit timeStampConversion:[ShareAppDelegate.SignUpCompetition.attendStart doubleValue] ] substringToIndex:10];
    NSString *attendEnd =[[ToolKit timeStampConversion:[ShareAppDelegate.SignUpCompetition.attendEnd doubleValue]] substringToIndex:10];
    startLable.font =SystemFont(15);
    startLable.textColor = RGBACOLOR(0, 0, 0, 0.65);
    [startLable setText: [NSString stringWithFormat:@"报名：%@ ~ %@",attendStart,attendEnd]];
    startLable.frame = CGRectMake(10+fontHeight+5,    startSignUPImage.frame.origin.y, SCREEN_WIDTH-fontHeight-fontHeight, fontHeight);
    [describeView addSubview:startLable];
    //
    //
    UIImageView *endSignUPImage =[UIImageView new];
    endSignUPImage.frame  = CGRectMake(10, startLable.frame.origin.y+startLable.frame.size.height+5+2, 14, 14);
    endSignUPImage.image = [UIImage imageNamed:@"icon_race"];
    [describeView addSubview:endSignUPImage];
    
    UILabel *endLable =[UILabel new];
    endLable.font = SystemFont(fontHeight);
    NSString *competitionStart =[[ToolKit timeStampConversion:[ShareAppDelegate.SignUpCompetition.competitionStart doubleValue]] substringToIndex:10];
    NSString *competitionEnd =[[ToolKit timeStampConversion:[ShareAppDelegate.SignUpCompetition.competitionEnd doubleValue]] substringToIndex:10];
    endLable.font =SystemFont(15);
    endLable.textColor = RGBACOLOR(0, 0, 0, 0.65);
    [endLable setText: [NSString stringWithFormat:@"比赛：%@ ~ %@",competitionStart,competitionEnd]];
    endLable.frame = CGRectMake(10+fontHeight+5,    endSignUPImage.frame.origin.y, SCREEN_WIDTH-fontHeight*2, fontHeight);
    [describeView addSubview:endLable];
    //
    
    
    
    
    describeView.frame = CGRectMake(0, ImagePlayerHeight, SCREEN_WIDTH, endLable.frame.origin.y+endLable.frame.size.height+5);
    describeView.backgroundColor = [UIColor whiteColor];
    [describeView addSubview:lable];
    
    
    UIView *remarkView =[UIView new];
    
    UIImageView *remarkImageView =[UIImageView new];
    remarkImageView.frame  =CGRectMake(10, 5, 16, 16);
    remarkImageView.image = [UIImage imageNamed:@"icon_race_introduce"];
    [remarkView addSubview:remarkImageView];
    
    
    UILabel *remarkTitle = [UILabel new];
    remarkTitle.frame = CGRectMake(10+16 +8, 5, 100, 16);
    [remarkTitle setText:@"赛事介绍"];
    remarkTitle.font = SystemFont(15);
    remarkTitle.textColor = RGBACOLOR(0, 0, 0, 0.78);
    [remarkView addSubview:remarkTitle];
    
    
    
    UILabel *remarkLable = [UILabel new];
    NSString *remark  =[NSString stringWithFormat: @"%@\n", ShareAppDelegate.SignUpCompetition.comptitionRemarks];
    [remarkLable setText:remark];
    
    // 用何種字體進行顯示
    font = SystemFont(14);
    // 計算出顯示完內容需要的最小尺寸
//    heightSize = [remark sizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-16, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    heightSize= [remark sizeForString:remark font:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-16, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ];
    
    remarkLable.frame = CGRectMake(8, remarkTitle.frame .size.height+5, SCREEN_WIDTH-16, heightSize.height+20);
    
    [remarkLable setTextAlignment:NSTextAlignmentCenter];
    remarkLable.font =  SystemFont(14)
    remarkLable.numberOfLines = 0;
    
    attributedString1 = [[NSMutableAttributedString alloc] initWithString:remark];
    paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:2];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [remark length])];
    [remarkLable setAttributedText:attributedString1];
    remarkView .frame =CGRectMake(0, describeView.frame.origin.y+describeView.frame.size.height +8, SCREEN_WIDTH, remarkLable.frame.origin.y+remarkLable.frame.size.height);
    remarkView .backgroundColor =[UIColor whiteColor];
    [remarkView addSubview:remarkLable];
    [remarkLable setTextColor:RGBACOLOR(0, 0, 0, 0.55)];
    //
    
    
    [_contentScrollView addSubview:describeView];
    
    [_contentScrollView addSubview:remarkView];
    
    //    UIView *view =
    double height =describeView.frame.origin.y+describeView.frame.size.height +8+remarkLable.bounds.size.height +20;
    NSLog(@"height:%f",height);
    if (height>SCREEN_HEIGHT) {
        _contentScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, height);
    }
    else{
        _contentScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_HEIGHT-NAVIGATION_HEIGHT);
    }
    
    
    
}

-(void)ImageViewWithArray:(NSMutableArray *)array{
    
    self.imageURLs = array;
    
    self.imagePlayerView.imagePlayerViewDelegate = self;
    
    // set auto scroll interval to x seconds
    self.imagePlayerView.scrollInterval = 3.0f;
    
    // adjust pageControl position
    self.imagePlayerView.pageControlPosition = ICPageControlPosition_BottomCenter;
    
    // hide pageControl or not
    self.imagePlayerView.hidePageControl = NO;
    
    // adjust edgeInset  调整填充
    //    self.imagePlayerView.edgeInsets = UIEdgeInsetsMake(10, 20, 30, 40);
    
    [self.imagePlayerView reloadData];
    
}
#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    
    return self.imageURLs.count?self.imageURLs.count:1;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //        imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[self.imageURLs objectAtIndex:index]]];
        [imageView sd_setImageWithURL:[self.imageURLs objectAtIndex:index] placeholderImage:[UIImage imageNamed:@"image"]];
    });
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    [self jumplook];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

- (void)jumplook {
    // Browser
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL autoPlayOnAppear = NO;
    
    
    for (int i = 0; i<_imageURLs.count; i++) {
        photo = [MWPhoto photoWithURL:_imageURLs[i]];
        [photos addObject:photo];
    }
    // Options
    enableGrid = NO;
    self.photos = photos;
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:0];
    
    [self.navigationController pushViewController:browser animated:YES];
    //    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    //    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //    [self presentViewController:nc animated:YES completion:nil];
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

/**
 *  创建取消报名按钮
 */
-(void)createBtn{
    UIBarButtonItem *  rightButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = rightButton;
}
-(void)submit{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您确定要取消报名吗？" delegate:self cancelButtonTitle:@"容我想想" otherButtonTitles:@"我意已决", nil];
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [[MeHandle instance] deleteCompetition:ShareAppDelegate.SignUpCompetition WithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
            if (!error) {
                NSLog(@"%@",dictionary);
                if ( [dictionary[Y_Code] intValue]==Y_Code_Success) {
                    [[NSNotificationCenter defaultCenter]      postNotificationName:Notif_RefreshCompetition    object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                  ShareAppDelegate.cId=    [[CoreDateManager instance] isCheckHaveTestStatus:TestStatusSimulation];
                //根据CID删除数据库
                    [[CoreDateManager instance] deleteRecordDB:ShareAppDelegate.cId];
                    [[CoreDateManager instance] deleteAllData:ShareAppDelegate.cId];
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
}



@end
