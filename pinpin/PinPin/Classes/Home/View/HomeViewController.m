//
//  HomeViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/15.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "HomeViewController.h"
#import "KrVideoPlayerController.h"
#import "Competition.h"
#import "UIImage+MJ.h"
#define PlayImageViewSize 60
#define PlayerButtonHeight 140
@interface HomeViewController ()<UIActionSheetDelegate,UMSocialUIDelegate>
@property (nonatomic, strong) KrVideoPlayerController *videoController;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UIImageView *playBackgroundImageView;
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) UILabel *speakLable;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, assign) float  marginTop;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation HomeViewController

-(void)getVideo{
    [[CompetitionHandle instance ] getComptitionWithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
                if (dictionary[Y_Data]) {
                    ShareAppDelegate.competition =  [Competition objectWithKeyValues:dictionary[Y_Data]];
                    _video =ShareAppDelegate.competition.video;
                    [_speakLable setText:ShareAppDelegate.competition.name];
                }
            }
            else{
                [MBProgressHUD showError:dictionary[Y_Message]];
            }
        }
        else{
            [MBProgressHUD showError:NetError];
        }
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.videoController.view .hidden =NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
    [self  viewInitScroll];
    [self getVideo];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.videoController.view .hidden =YES;
    [self.videoController pauseButtonClick];
}
/**
 *  初始化
 */
-(void)viewInit{
    if (iPhone4) {
        _marginTop= 10;
    }
    else if(iPhone5){
        _marginTop = 40;
    }
    else if(iPhone6){
        _marginTop = 60;
    }
    else if(iPhone6plus){
        _marginTop =60;
    }
    
    
//    _speakLable = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT+_marginTop, SCREEN_WIDTH, 60)];
//    _speakLable.layer.masksToBounds = YES;
//    _speakLable.layer.cornerRadius = 6.0;
//    _speakLable.font = [UIFont boldSystemFontOfSize:14];
//    _speakLable.textAlignment = NSTextAlignmentCenter;
//    [_speakLable setTextColor:THEME_COLOR];
//    [self.view addSubview:_speakLable];
//    
//    UIView *bubbles1 = [UIView new];
//    bubbles1 .frame = CGRectMake(200, NAVIGATION_HEIGHT+STATUS_HEIGHT+20+_marginTop, 10, 10);
//    [bubbles1.layer setCornerRadius:CGRectGetHeight([bubbles1 bounds]) / 2];
//    bubbles1.layer.masksToBounds = YES;
//    bubbles1.layer.borderWidth = 1;
//    bubbles1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    [self.view addSubview:bubbles1];
//    
//    UIView *bubbles2 = [UIView new];
//    bubbles2 .frame = CGRectMake(170, NAVIGATION_HEIGHT+STATUS_HEIGHT+5+_marginTop, 15, 15);
//    [bubbles2.layer setCornerRadius:CGRectGetHeight([bubbles2 bounds]) / 2];
//    bubbles2.layer.masksToBounds = YES;
//    bubbles2.layer.borderWidth = 1;
//    bubbles2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    [self.view addSubview:bubbles2];
    
    
    _playBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shiping"]];
//    _playBackgroundImageView.transform = CGAffineTransformMakeTranslation(0,_marginTop);
    _playBackgroundImageView.frame =CGRectMake(0, _marginTop, SCREEN_WIDTH, _playBackgroundImageView.frame.size.height);
    
    [self.view addSubview:_playBackgroundImageView];
    
    //    _playImageView =[[UIImageView alloc]  initWithFrame:CGRectMake(SCREEN_WIDTH/2-20, SCREEN_WIDTH*(7.0/8.0)/2-20, 100, 100)];
    _playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bofang"]];
    _playImageView.center = CGPointMake(SCREEN_WIDTH/2, _playBackgroundImageView.frame.size.height/2+_marginTop);
    _playImageView .image = [UIImage imageNamed:@"bofang"];
    [self.view addSubview:_playImageView];
    
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame =CGRectMake(1, _marginTop, _playBackgroundImageView.frame.size.width, _playBackgroundImageView.frame.size.height);
    [_playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
//    _playButton.backgroundColor=[UIColor blackColor];
    _playButton.alpha = 0.9;
    [self.view addSubview:_playButton];
    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: _playButton.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = _playButton .bounds;
//    maskLayer.path = maskPath.CGPath;
//    _playButton .layer.mask = maskLayer;
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, SCREEN_WIDTH*(9.0/16.0)+PlayerButtonHeight+_marginTop, SCREEN_WIDTH-2, 77)];
//    imageView.image = [UIImage imageNamed:@"icon_mac_panel"];
//    [self.view addSubview:imageView];
    
//    _playBackgroundImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, _marginTop, SCREEN_WIDTH, SCREEN_WIDTH*(7.0/8.0))];
//    _playBackgroundImageView.image =[UIImage imageNamed:@"shiping"];
    
    
    
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.adjustsImageWhenHighlighted = NO;
    _shareButton.frame = CGRectMake(SCREEN_WIDTH -20-20, _playBackgroundImageView.frame.size.height+_marginTop-20, 20, 20);
    [_shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareButton];
    
    UIImageView *shareImageView =[UIImageView new];
    shareImageView.frame = CGRectMake(SCREEN_WIDTH -20-20, _playBackgroundImageView.frame.size.height+_marginTop-20, 20, 20);
    shareImageView.image = [UIImage imageNamed:@"share"];
    
    [self.view  addSubview:shareImageView];
    
    
    
//    UIImageView *petImageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 85+_marginTop, 59, 59)];
//    petImageView.image = [UIImage imageNamed:@"icon_owl"];
//    [self.view addSubview:petImageView];
    
    
    
//    _playImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, PlayerButtonHeight+_marginTop, SCREEN_WIDTH, SCREEN_WIDTH*(9.0/16.0))];
//    _playImageView .image = [UIImage imageNamed:@"videoDefault"];
//    [self.view addSubview:_playImageView];
//    
//    UIBezierPath *imageMaskPath = [UIBezierPath bezierPathWithRoundedRect: _playImageView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
//    CAShapeLayer *imageMaskLayer = [[CAShapeLayer alloc] init];
//    imageMaskLayer.frame = _playImageView .bounds;
//    imageMaskLayer.path = imageMaskPath.CGPath;
//    _playImageView.layer.mask = imageMaskLayer;
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shareButton:) name:Notif_Share_Video object:nil];
}
-(void) viewInitScroll{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _playBackgroundImageView.frame.size.height+_marginTop-4, SCREEN_WIDTH, 460)];
    
    UIImage *img =[UIImage imageNamed:@"dise"];
    img = [UIImage reSizeImage:img toSize:CGSizeMake(SCREEN_WIDTH,460)];
    [_scrollView setBackgroundColor:[UIColor colorWithPatternImage:img]];
   
    
    // 是否支持滑动最顶端
    //    scrollView.scrollsToTop = NO;
  
    
    // 是否反弹
        _scrollView.bounces = YES;
    // 是否分页
    //    scrollView.pagingEnabled = YES;
    // 是否滚动
        _scrollView.scrollEnabled = YES;
    //    scrollView.showsHorizontalScrollIndicator = NO;
    // 设置indicator风格
    //    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    // 设置内容的边缘和Indicators边缘
    //    scrollView.contentInset = UIEdgeInsetsMake(0, 50, 50, 0);
    //    scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    // 提示用户,Indicators flash
    [_scrollView flashScrollIndicators];
    // 是否同时运动,lock
    _scrollView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollView];
    
    
//    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-50, 40)];
//    label1.backgroundColor = [UIColor redColor];
//    label1.text = @"拼拼英语——爱拼才会赢全国英语大赛";
//    label1.textColor = [UIColor whiteColor];
//    [label1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]];
   
    NSString *labelTextString1  = @"拼拼英语——爱拼才会赢全国英语大赛";
    UILabel *label1 = [UILabel dynamicHeightLabelWithPointX:20 pointY:20 width:SCREEN_WIDTH-28 strContent:labelTextString1 color:[UIColor whiteColor] font:[UIFont fontWithName:@"Helvetica-Bold" size:14.0] textAlignmeng:NSTextAlignmentLeft];
     [_scrollView addSubview:label1];
    
    NSString *labelTextString2  = @"拼拼英语联合CCTV中学生频道、爱拼才会赢栏目组，为全国中小学生打造国内最大英语电视盛宴！";
    UILabel *label2 = [UILabel dynamicHeightLabelWithPointX:20 pointY:40+label1.frame.size.height width:SCREEN_WIDTH-28 strContent:labelTextString2 color:[UIColor whiteColor] font:[UIFont fontWithName:@"Helvetica" size:14.0] textAlignmeng:NSTextAlignmentLeft];
    [_scrollView addSubview:label2];
    
    
    NSString *labelTextString3  = @"上CCTV晒英语，让全国小伙伴齐围观——威！";
    UILabel *label3 = [UILabel dynamicHeightLabelWithPointX:20 pointY:10+label2.frame.size.height+label2.frame.origin.y width:SCREEN_WIDTH-28 strContent:labelTextString3 color:[UIColor whiteColor] font:[UIFont fontWithName:@"Helvetica" size:14.0] textAlignmeng:NSTextAlignmentLeft];
    [_scrollView addSubview:label3];
    
    
    NSString *labelTextString4  = @"全国超过一百万学生共同竞技——大型！";
    UILabel *label4 = [UILabel dynamicHeightLabelWithPointX:20 pointY:10+label3.frame.size.height+label3.frame.origin.y width:SCREEN_WIDTH-28 strContent:labelTextString4 color:[UIColor whiteColor] font:[UIFont fontWithName:@"Helvetica" size:14.0] textAlignmeng:NSTextAlignmentLeft];
    [_scrollView addSubview:label4];
    
    NSString *labelTextString5  = @"国内顶尖英语专家组评委——干货！";
    UILabel *label5 = [UILabel dynamicHeightLabelWithPointX:20 pointY:10+label4.frame.size.height+label4.frame.origin.y width:SCREEN_WIDTH-28 strContent:labelTextString5 color:[UIColor whiteColor] font:[UIFont fontWithName:@"Helvetica" size:14.0] textAlignmeng:NSTextAlignmentLeft];
    [_scrollView addSubview:label5];
    
    NSString *labelTextString6  = @"去北京跟摄影组进影棚录制节目——好玩！";
    UILabel *label6= [UILabel dynamicHeightLabelWithPointX:20 pointY:10+label5.frame.size.height+label5.frame.origin.y width:SCREEN_WIDTH-28 strContent:labelTextString6 color:[UIColor whiteColor] font:[UIFont fontWithName:@"Helvetica" size:14.0] textAlignmeng:NSTextAlignmentLeft];
    [_scrollView addSubview:label6];
    CGFloat scrollviewHight =label1.frame.size.height+label2.frame.size.height+label3.frame.size.height +label4.frame.size.height+label5.frame.size.height+label6.frame.size.height+100;
    
    CGRect newFrame = _scrollView.frame;
    newFrame.size.height = scrollviewHight;
    _scrollView.frame = newFrame;
    
    // 设置内容大小
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH-30, scrollviewHight+80);
    
    
}
/**
 *开始
 */
-(void)playVideo{
    [_playButton removeFromSuperview];
    [_playImageView removeFromSuperview];
    [_playBackgroundImageView removeFromSuperview];
    [self getVideoUrl];
    [self addVideoPlayerWithURL:_videoUrl];
}
/**
 *判断播放的视频
 */
-(void )getVideoUrl{
    if ([_video isEmptyString]||_video==nil) {
        [MBProgressHUD showError:NetError];
        return;
    }
    if ([[[SYSTEM_USERDEFAULTS objectForKey:VideoName] trimString]isEmptyString]) {
        //当获取不到的时候，就存入URL地址  拿服务器
        [self downloadFileTapped];
        _videoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",URL_QINIU,_video]];
    }
    else{
        //当获取得到的时候就想作对比
        if ([_video isEqualToString:[SYSTEM_USERDEFAULTS objectForKey:VideoName]]) {//相等 拿本地
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cachesDirectory = paths[0];
            NSString *downloadPath = [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",_video]];
            NSURL *localVideoUrl = [NSURL fileURLWithPath:downloadPath];
            NSLog(@"%@",localVideoUrl);
            _videoUrl =localVideoUrl;
            BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:downloadPath];
            if (!blHave) {
                NSLog(@"no  have");
                [self downloadFileTapped];
                _videoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",URL_QINIU,_video]];
                return ;
            }else {
                NSLog(@" have");
            }
        }
        else {//不等的时候 拿服务器
            
            _videoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",URL_QINIU,_video]];
            [self deleteVideoWithVideoNmae:[SYSTEM_USERDEFAULTS objectForKey:VideoName]];
        }
    }
}
/**
 *删除本地存储的视频
 */
-(void)deleteVideoWithVideoNmae:(NSString *)videoName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = paths[0];
    NSString *downloadPath = [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[SYSTEM_USERDEFAULTS objectForKey:VideoName]]];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:downloadPath];
    if (!blHave) {
        NSLog(@"no  have");
        [self downloadFileTapped];
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [[NSFileManager defaultManager] removeItemAtPath:downloadPath error:nil];
        if (blDele) {
            NSLog(@"dele success");
            [self downloadFileTapped];
        }else {
            NSLog(@"dele fail");
        }
    }
}
//开始播放
- (void)addVideoPlayerWithURL:(NSURL *)url{
    if (!self.videoController) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, _marginTop, width, _playBackgroundImageView.frame.size.height)];
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:   self.videoController .view.bounds byRoundingCorners:
//                                  UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame =    self.videoController .view.bounds;
//        maskLayer.path = maskPath.CGPath;
//        self.videoController .view.layer.mask = maskLayer;
        
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
            
        }];
        [self.videoController setWillBackOrientationPortrait:^{
            [weakSelf toolbarHidden:NO];
//            weakSelf.videoController .view.layer.mask=maskLayer;
        }];
        [self.videoController setWillChangeToFullscreenMode:^{
            [weakSelf toolbarHidden:YES];
            
        }];
        [self.view addSubview:self.videoController.view];
    }
    self.videoController.contentURL = url;
    
}
//隐藏navigation tabbar 电池栏
- (void)toolbarHidden:(BOOL)Bool{
//    self.navigationController.navigationBar.hidden = Bool;
//    self.tabBarController.tabBar.hidden = Bool;
//    [[UIApplication sharedApplication] setStatusBarHidden:Bool withAnimation:UIStatusBarAnimationFade];
}

- (void)shareButtonAction:(id)sender {
    [UMSocialData defaultData].extConfig.wechatSessionData.url =[NSString stringWithFormat:@"%@%@",URL_QINIU,_video];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"拼拼竞赛";
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:[NSString stringWithFormat:@"%@",_speakLable.text]
                                     shareImage:[UIImage imageNamed:@"pin"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToSms,UMShareToEmail,nil]
                                       delegate:self];
}
//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
-(void)dealloc{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notif_Share_Video object:nil];
}

-(void)downloadFileTapped {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = paths[0];
    NSString *downloadPath = [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",_video]];
    NSLog(@"%@",downloadPath);
    self.downloadOperation = [ShareAppDelegate.testsEngine downloadFatAssFileFrom:[NSString stringWithFormat:@"%@%@",URL_QINIU,_video]
                                                                           toFile:downloadPath];
    
    [self.downloadOperation onDownloadProgressChanged:^(double progress) {
        
        DLog(@"%.2f", progress*100.0);
        //        self.downloadProgessBar.progress = progress;
    }];
    
    __weak HomeViewController *weakSelf = self;
    [self.downloadOperation addCompletionHandler:^(MKNetworkOperation* completedRequest) {
        
        DLog(@"%@", completedRequest);
        //        weakSelf.downloadProgessBar.progress = 0.0f;
        [SYSTEM_USERDEFAULTS setObject:weakSelf.video forKey:VideoName];
        [SYSTEM_USERDEFAULTS synchronize];
    }
                                    errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
                                        
                                        DLog(@"%@", error);
                                        //                                        [UIAlertView showWithError:error];
                                        [MBProgressHUD showError:error];
                                    }];
    
}

@end
