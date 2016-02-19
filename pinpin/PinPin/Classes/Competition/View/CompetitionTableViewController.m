//
//  CompetitionTableViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/27.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "CompetitionTableViewController.h"
#import "Competition.h"
#import "ChooseTableViewController.h"
#import "CheckScoreViewController.h"
#import "ChooseTableViewController.h"
#import "CompetitionTableViewCell.h"
#import "SegmentationTableViewCell.h"
#import "SignUpDetailsViewController.h"
@interface CompetitionTableViewController ()<UITableViewDataSource,UITableViewDelegate,ImagePlayerViewDelegate,MWPhotoBrowserDelegate>
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, strong) Competition *competition;
@property (nonatomic, strong) NSMutableArray *arrays;
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation CompetitionTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if([[Config Instance] isLogin]){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getArrays) name:Notif_RefreshCompetition object:nil];
    }else{
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getComptitionArrays) name:Notif_RefreshCompetition object:nil];
    }
    
    [self viewInit];
    [self addHeaderRefresh];
}


-(void)viewInit{
    _imagePlayerView = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT+NAVIGATION_HEIGHT, self.view.bounds.size.width, ImagePlayerHeight)];
    _imagePlayerView .backgroundColor = [UIColor grayColor];
    self.tableView.tableHeaderView=_imagePlayerView;
    
    if (ShareAppDelegate.competition) {
        NSArray * array = [ShareAppDelegate.competition.photo componentsSeparatedByString:@"&#"];
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
    if([[Config Instance] isLogin]){
         [self getArrays];
    }else{
        [self getComptitionArrays];
    }
   
}

-(void)getArrays{
    _arrays = [NSMutableArray new];
//    [MBProgressHUD showMessage:@"加载中..."];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT+NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
//    [view setBackgroundColor:BACKGROUND_COLOR];
//    view.alpha=1;
//    [window addSubview:view];
    
    
    [[CompetitionHandle instance]findStudentStatusWithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
   

            NSLog(@"%@",dictionary);
            if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
                if (dictionary[Y_Data]) {
                    if (dictionary[Y_Data][Y_Records]) {
                        dictionary = dictionary[Y_Data][Y_Records];
                        for (NSDictionary *dict in dictionary) {
                            // 创建模型对象
                            Competition  *competition = [Competition objectWithKeyValues:dict ];
                            // 添加模型对象到数组中
                            [_arrays addObject:competition];
                        }
                        [self.tableView reloadData];
                        [self.tableView.header    endRefreshing];
                    }
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [view removeFromSuperview];
//                    [MBProgressHUD hideHUD];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }
            else{
//                [view removeFromSuperview];
//                [MBProgressHUD hideHUD];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showError:dictionary[Y_Message]];
            }
        }
        else{
//            [view removeFromSuperview];
//            [MBProgressHUD hideHUD];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:[error localizedDescription]];
        }
    }];
    
}

-(void)getComptitionArrays{
    _arrays = [NSMutableArray new];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [[CompetitionHandle instance]getComptitionsWithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            NSLog(@"%@",dictionary);
            if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
                if (dictionary[Y_Data]) {
                    if (dictionary[Y_Data][Y_Records]) {
                        dictionary = dictionary[Y_Data][Y_Records];
                        for (NSDictionary *dict in dictionary) {
                            // 创建模型对象
                            Competition  *competition = [Competition objectWithKeyValues:dict ];
                            // 添加模型对象到数组中
                            [_arrays addObject:competition];
                        }
                        [self.tableView reloadData];
                        [self.tableView.header    endRefreshing];
                    }
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }
            else{
               
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showError:dictionary[Y_Message]];
            }
        }
        else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:[error localizedDescription]];
        }
    }];
    
}


/**
 *创建图片轮播
 */
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
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.imageURLs.count>0) {
            [imageView sd_setImageWithURL:[self.imageURLs objectAtIndex:index] placeholderImage:[UIImage imageNamed:@"image"]];
        }
        else{
            [imageView setImage:[UIImage imageNamed:@"image"]];
        }
        
//    });
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    NSLog(@"did tap index = %d", (int)index);//点击了那个图片
    [self jumplook];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrays.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        static NSString *cellID = @"status";
        SegmentationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SegmentationTableViewCell" owner:nil options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BACKGROUND_COLOR;
        return cell;
    }
    else{
        Competition *competition = self.arrays[indexPath.row-1];
        // 1.创建cell
        CompetitionTableViewCell *cell =[CompetitionTableViewCell cellWithTableView:tableView];
        // 2.设置数据
        [cell settingData:competition ];
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 35;
    }
    return BannerHeight +8;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath .row==0)return;
    _competition = _arrays[indexPath.row-1];
    //    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970]*1000;
    //    NSTimeInterval competitionStart = [_competition.competitionStart doubleValue];
    //    NSTimeInterval competitionEnd = [_competition.competitionEnd doubleValue];
    ShareAppDelegate.SignUpCompetition=nil;
    ShareAppDelegate.SignUpCompetition = _competition;
    SignUpDetailsViewController *signUpDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpDetailsViewController"];
    [self.navigationController pushViewController:signUpDetailsViewController animated:YES];
    
    //    switch ([_competition.status intValue]) {
    //        case StudentStatusNotSignUp:
    //        {
    //            /**
    //             *  未报名在报名的开始时间和结束时间之间才能报名
    //             */
    ////            if ((attendStart-nowTime)<=0&&(attendEnd-nowTime)>0) {
    //                //未报名
    //                //                ChooseTableViewController *chooseTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseTableViewController"];
    //                ShareAppDelegate.SignUpCompetition = _competition;
    //
    //                //                [self.navigationController pushViewController:chooseTableViewController animated:YES];
    //                SignUpDetailsViewController *signUpDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpDetailsViewController"];
    //                [self.navigationController pushViewController:signUpDetailsViewController animated:YES];
    ////            }
    ////            else{
    ////                //                NSLog(@"现在不是报名时间");
    ////                [MBProgressHUD showError:@"现在不是报名时间"];
    ////            }
    //        }
    //            break;
    //        case StudentStatusAlreadySignUp:{
    //            //已报名
    //            //赛事开始时间未到 参加模拟比赛
    //            if ((competitionStart-nowTime)>0) {
    //                SimulationMatchViewController * simulationMatchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SimulationMatchViewController"];
    //                simulationMatchViewController.competition = _competition;
    //                [self.navigationController pushViewController:simulationMatchViewController animated:YES];
    //            }
    //            //赛事开始时间到了 并且赛事结束时间未到 参加正式比赛
    //            else if ( (competitionStart-nowTime)<=0 && (competitionEnd-nowTime)>0){
    //                NSLog(@"参加正式比赛");
    //                FormalMatchViewController *formalMatchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FormalMatchViewController"];
    //                formalMatchViewController.competition = _competition;
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
    //                [self.view makeToast:@"等待查分" duration:1.5f position:@"center"];
    //            }
    //            //竞赛已结束 查分
    //            else if((competitionEnd-nowTime)<=0){
    //                CheckScoreViewController * checkScoreViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckScoreViewController"];
    //                checkScoreViewController .competition = _competition;
    //                [self.navigationController pushViewController:checkScoreViewController animated:YES];
    //            }
    //        }
    //            break;
    //        default:
    //            break;
    //    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notif_RefreshCompetition object:nil];
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


- (void)addHeaderRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
       
        if([[Config Instance] isLogin]){
             [self getArrays];
        }else{
             [self getComptitionArrays];
        }
    }];
    
}



@end
