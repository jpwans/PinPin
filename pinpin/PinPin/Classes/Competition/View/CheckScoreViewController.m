//
//  CheckScoreViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/29.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "CheckScoreViewController.h"
#import "FormalTestTableViewController.h"
@interface CheckScoreViewController ()<UITextFieldDelegate,ImagePlayerViewDelegate,MWPhotoBrowserDelegate>
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, strong) NSMutableArray *arrays;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) StudentScore *studentScore;
@end

@implementation CheckScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}
-(void)viewInit{
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    _checkScoreTextField = [[UITextField alloc] init];
    _checkScoreTextField.layer.borderColor=[UIColor grayColor].CGColor;
    _checkScoreTextField.layer.borderWidth=1;
    _checkScoreTextField.text = ShareAppDelegate.SignUpCompetition.partCode;
    _checkScoreTextField.delegate =self;
    _checkScoreTextField.textAlignment=NSTextAlignmentCenter;
    [_contentScrollView addSubview:_checkScoreTextField];
    
    _checkScoreTextField.frame = CGRectMake(0, ImagePlayerHeight+8, SCREEN_WIDTH, 40);
    _queryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _queryButton.adjustsImageWhenHighlighted  = NO;
    _queryButton.layer.masksToBounds = YES;
    _queryButton.layer.cornerRadius = 6.0;
    _queryButton.backgroundColor = THEME_COLOR;
    
    [_queryButton setTitle:@"查分" forState:UIControlStateNormal];
    [_queryButton addTarget: self action:@selector(queryAction:) forControlEvents:UIControlEventTouchUpInside];
    _queryButton.frame = CGRectMake(10, _checkScoreTextField.frame.origin.y+_checkScoreTextField.frame.size.height+8, SCREEN_WIDTH-20, 40);
    [_contentScrollView addSubview:_queryButton];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDownToKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    _contentScrollView.backgroundColor = BACKGROUND_COLOR;
    
    _contentScrollView.showsVerticalScrollIndicator = NO;//设置垂直滚动条
    
    
    [self setImagePlayerView];
    
}
- (void)touchDownToKeyboard:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


#pragma mark textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.textAlignment= NSTextAlignmentLeft;
    CATransition *animation = [CATransition animation];
    [animation setDuration:1.0];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setType:@"rippleEffect"];// rippleEffect
    [animation setSubtype:kCATransitionFromTop];
    [textField.layer addAnimation:animation forKey:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.textAlignment= NSTextAlignmentCenter;
    CATransition *animation = [CATransition animation];
    [animation setDuration:1.0];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setType:@"rippleEffect"];// rippleEffect
    [animation setSubtype:kCATransitionFromTop];
    [textField.layer addAnimation:animation forKey:nil];
}



- (void)queryAction:(UIButton *)sender {
    //    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentCompetitionScoreTableViewController"];
    //    [self.navigationController  pushViewController:vc animated:YES];
    [[CompetitionHandle instance] getStudentInfoByCode:[_checkScoreTextField.text trimString] WithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            
            if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
                if (dictionary[Y_Data]) {
                    if (dictionary[Y_Data][Y_Records]) {
                        dictionary =dictionary[Y_Data][Y_Records];
                        NSLog(@"%@",dictionary);
                        _studentScore = [[StudentScore alloc] init];
                        for (NSDictionary *dict in dictionary) {
                            // 创建模型对象
                            
                            _studentScore  = [StudentScore objectWithKeyValues:dict];
                            // 添加模型对象到数组中
                        }
                        
                        _studentView = [UIView new];
                        CGFloat labelW = (SCREEN_WIDTH-10*3)/2;
                        
                        _qualifiedButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        _qualifiedButton.adjustsImageWhenDisabled = NO;
                        _qualifiedButton.layer.masksToBounds = YES;
                        _qualifiedButton.layer.cornerRadius = 6.0;
                        _qualifiedButton.backgroundColor =[UIColor whiteColor];
                        [_qualifiedButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
                        NSString * qualified = [_studentScore.score intValue]>=[_studentScore.scoreLine intValue]?@"合格":@"不合格";
                        [_qualifiedButton setTitle:qualified forState:UIControlStateNormal];
                        [_qualifiedButton.titleLabel setFont:[UIFont systemFontOfSize:14 weight:2]];
                        [_qualifiedButton.titleLabel setTextColor:[UIColor whiteColor]];
                        _qualifiedButton.frame = CGRectMake((SCREEN_WIDTH -labelW)/2, 0, labelW, 30);
                        [_qualifiedButton addTarget:self action:@selector(lookQualified:) forControlEvents:UIControlEventTouchUpInside];
                        
                        _nameLable = [UILabel new];
                        [_nameLable setText:[NSString stringWithFormat:@"姓名：%@",_studentScore.studentName]];
                        _nameLable.frame = CGRectMake(10, _qualifiedButton.frame.origin.y+_qualifiedButton.frame.size.height+8, labelW, 30);
                        _nameLable.font = SystemFont(14);
                        
                        _groupLable = [UILabel new];
                        _groupLable.frame = CGRectMake(_nameLable.frame.origin.x+_nameLable.frame.size.width+10,_nameLable.frame.origin.y , _nameLable.frame.size.width, _nameLable.frame.size.height);
                        [_groupLable setText:[NSString stringWithFormat:@"人群组：%@",_studentScore.groupValue]];
                        _groupLable.font = SystemFont(14);
                        
                        _totalScoreLable = [UILabel new];
                        _totalScoreLable.frame = CGRectMake(_nameLable.frame.origin.x,_nameLable.frame.origin.y+_nameLable.frame.size.height+8 , _nameLable.frame.size.width, _nameLable.frame.size.height);
                        [_totalScoreLable setText:[NSString stringWithFormat:@"总分：%@",_studentScore.score]];
                        _totalScoreLable.font = SystemFont(14);
                        
                        _fractionalLineLable = [UILabel new];
                        _fractionalLineLable.frame = CGRectMake(_nameLable.frame.origin.x+_nameLable.frame.size.width+10,_totalScoreLable.frame.origin.y , _nameLable.frame.size.width, _nameLable.frame.size.height);
                        [_fractionalLineLable setText:[NSString stringWithFormat:@"分数线：%@",_studentScore.scoreLine]];
                        _fractionalLineLable.font = SystemFont(14);
                        
                        
                        _errorLable = [UILabel new];
                        _errorLable.frame = CGRectMake(_nameLable.frame.origin.x,_totalScoreLable.frame.origin.y+_totalScoreLable.frame.size.height+8 , _nameLable.frame.size.width, _nameLable.frame.size.height);
                        [_errorLable setText:[NSString stringWithFormat:@"错误题数：%@",_studentScore.mistakeNum]];
                        _errorLable.font = SystemFont(14);
                        
                        _correctLable = [UILabel new];
                        _correctLable.frame = CGRectMake(_nameLable.frame.origin.x+_nameLable.frame.size.width+10,
                                                         _errorLable.frame.origin.y , _nameLable.frame.size.width, _nameLable.frame.size.height);
                        [_correctLable setText:[NSString stringWithFormat:@"正确题数：%@",_studentScore.correctNum]];
                        _correctLable.font = SystemFont(14);
                        
                        _officeRankingLable = [UILabel new];
                        _officeRankingLable.frame = CGRectMake(_nameLable.frame.origin.x,_errorLable.frame.origin.y+_errorLable.frame.size.height+8 , _nameLable.frame.size.width, _nameLable.frame.size.height);
                        [_officeRankingLable setText:[NSString stringWithFormat:@"站内排名：%@",_studentScore.stationRank]];
                        _officeRankingLable.font = SystemFont(14);
                        
                        
                        _schoolRankingLable = [UILabel new];
                        _schoolRankingLable.frame = CGRectMake(_nameLable.frame.origin.x+_nameLable.frame.size.width+10,_officeRankingLable.frame.origin.y , _nameLable.frame.size.width, _nameLable.frame.size.height);
                        [_schoolRankingLable setText:[NSString stringWithFormat:@"学校排名：%@",_studentScore.schoolRank]];
                        _schoolRankingLable.font = SystemFont(14);
                        
                        _studentView.frame =CGRectMake(0,_queryButton.frame.origin.y+_queryButton.frame.size.height+10 , SCREEN_WIDTH,  _schoolRankingLable.frame.origin.y+ _schoolRankingLable.frame.size.height);
                        
                        [_studentView addSubview:_qualifiedButton];
                        [_studentView addSubview:_nameLable];
                        [_studentView addSubview:_groupLable];
                        [_studentView addSubview:_totalScoreLable];
                        [_studentView addSubview:_fractionalLineLable];
                        [_studentView addSubview:_errorLable];
                        [_studentView addSubview:_correctLable];
                        [_studentView addSubview:_officeRankingLable];
                        [_studentView addSubview:_schoolRankingLable];
                        [_contentScrollView addSubview:_studentView];
                        _studentView.backgroundColor = BACKGROUND_COLOR;
                        
                        _contentScrollView .contentSize =  CGSizeMake(SCREEN_WIDTH, _studentView.frame.origin.y+ _studentView.frame.size.height);
                    }
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

-(void)lookQualified:(UIButton *)button{
    [MBProgressHUD showMessage:nil];
    
   
    
    [[CompetitionHandle instance] getAnswerDetails:_studentScore WithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        //            NSLog(@"%@",dictionary);
        
        if (!error) {
            if (dictionary[Y_Data]) {
                if (dictionary[Y_Data][@"records"]) {
                    dictionary =dictionary[Y_Data][@"records"];
                    NSMutableArray * resultArray = [NSMutableArray new];
                    for (NSDictionary *dict in dictionary) {
                        // 创建模型对象
                        LibraryBank *libraryBank = [LibraryBank objectWithKeyValues:dict];
                        // 添加模型对象到数组中
                        [resultArray addObject:libraryBank];
                    }
                         ShareAppDelegate.cId =    [[CoreDateManager instance] isCheckHaveTestStatus:TestStatusFormal];
                    
                     NSMutableArray *testArrays = [NSMutableArray new];
                     testArrays =     [[CoreDateManager instance] queryFormalTestResultArraysWithcId:ShareAppDelegate.cId :resultArray ];
                    if (testArrays.count == 0) {
                        [[CoreDateManager instance] downloadWith:ShareAppDelegate.SignUpCompetition TestStatus:TestStatusFormal WithCompletionHandler:^{
                             ShareAppDelegate.cId =    [[CoreDateManager instance] isCheckHaveTestStatus:TestStatusFormal];
                            [[CoreDateManager instance] queryFormalTestResultArraysWithcId:ShareAppDelegate.cId :resultArray ];
                            
                            ShareAppDelegate.SignUpCompetition.duration = 0;
                            FormalTestTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FormalTestTableViewController"];
                            vc.isCheckScore = YES;
                            vc.checkArrays =resultArray;
                            [MBProgressHUD hideHUD];
                            [self.navigationController pushViewController:vc animated:YES];
                            
                        }];
                    
                    }else{

                    ShareAppDelegate.SignUpCompetition.duration = 0;
                    FormalTestTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FormalTestTableViewController"];
                    vc.isCheckScore = YES;
                    vc.checkArrays =resultArray;
                    [MBProgressHUD hideHUD];
                    [self.navigationController pushViewController:vc animated:YES];
                    }
                }
            }
            
        }
        
    }];
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


@end
