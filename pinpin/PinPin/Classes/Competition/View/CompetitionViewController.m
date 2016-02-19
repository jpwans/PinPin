//
//  CompetitionViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/16.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "CompetitionViewController.h"
#import "Competition.h"
#import <AVFoundation/AVFoundation.h>
#import "ChooseTableViewController.h"

@interface CompetitionViewController ()<ImagePlayerViewDelegate>
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, strong) Competition *competition;
@end

@implementation CompetitionViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    _playVoice.contentURL = [[NSBundle mainBundle] URLForResource:@"5188" withExtension:@"wav"];
    
    [self viewInit];
    
}

-(void)viewInit{
    
    [self createImagePlayerView];
    [self createSignUpView];
    //    [self createQueryView];
    /**
     *  赛事
     */
    [[CompetitionHandle instance ] getComptitionWithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
                if (dictionary[Y_Data]) {
                    _competition   = [Competition objectWithKeyValues:dictionary[Y_Data]];
                    NSArray * array = [_competition.photo componentsSeparatedByString:@"&#"];
                    NSMutableArray *photoArray  = [NSMutableArray new];
                    for (int i=0; i<array.count-1; i++) {
                        [photoArray addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_QINIU,array[i]]]];
                    }
                    [self ImageViewWithArray:photoArray];
                }
            }
            else{
                [MBProgressHUD showError:dictionary[Y_Message]];
            }
        }
        else{
            [MBProgressHUD showError:NetError];
            [self ImageViewWithArray:nil];
        }
    }];
    [_startButton setTitle:@"点击报名" forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(signUpAction:) forControlEvents:UIControlEventTouchUpInside];
    //查询学生状态
    //    [[CompetitionHandle instance] findStudentStatusWithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
    //        if (!error) {
    //            NSLog(@"%@",dictionary);
    //            if ([dictionary[Y_Code] intValue ]==0) {
    ////                [_startButton setTitle:@"点击报名" forState:UIControlStateNormal];
    ////                [_startButton addTarget:self action:@selector(signUpAction:) forControlEvents:UIControlEventTouchUpInside];
    //            }
    //            else{
    //                [_startButton setTitle:@"开始比赛" forState:UIControlStateNormal];
    //            }
    //        }
    //        else{
    //            [MBProgressHUD showError:NetError];
    //        }
    //    }];
}

#pragma mark -createViews
/**
 *  创建图片轮播
 */
-(void)createImagePlayerView{
//    _imagePlayerView = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT+NAVIGATION_HEIGHT, self.view.bounds.size.width, ImagePlayerHeight)];
        _imagePlayerView = [[ImagePlayerView alloc] init];
    _imagePlayerView .backgroundColor = [UIColor grayColor];
    [self.view addSubview:_imagePlayerView];
    _imagePlayerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //距离左边
    NSLayoutConstraint *constraint =   [NSLayoutConstraint constraintWithItem:_imagePlayerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.f];
    [self.view addConstraint:constraint];
    
    //距离右边
    constraint =   [NSLayoutConstraint constraintWithItem:_imagePlayerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.f];
    [self.view addConstraint:constraint];
    
    //距离上面
    constraint =[NSLayoutConstraint constraintWithItem:_imagePlayerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:STATUS_HEIGHT+NAVIGATION_HEIGHT];
    [self.view addConstraint:constraint];
    //宽度
//    constraint = [NSLayoutConstraint constraintWithItem:_imagePlayerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:SCREEN_WIDTH];
//    [self.view addConstraint:constraint];
   //高度
    constraint = [NSLayoutConstraint constraintWithItem:_imagePlayerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:ImagePlayerHeight];
    [self.view addConstraint:constraint];
}
/**
 *  创建报名的View
 */
-(void)createSignUpView{
    _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _startButton.adjustsImageWhenHighlighted = NO;
    _startButton .frame = CGRectMake((SCREEN_WIDTH-120)/2, STATUS_HEIGHT+NAVIGATION_HEIGHT + ImagePlayerHeight +30, 120, 30);
    [_startButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    _startButton.layer.masksToBounds = YES;
    _startButton.layer.cornerRadius = 6;
    _startButton.layer.borderWidth = 1;
    _startButton.layer.borderWidth = 1;
    _startButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:_startButton];
}
/**
 *  创建查询
 */
-(void)createQueryView{
    _queryTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, STATUS_HEIGHT+NAVIGATION_HEIGHT + ImagePlayerHeight +30, SCREEN_WIDTH-40, 30)];
    _queryTextField.layer.masksToBounds = YES;
    _queryTextField.layer.cornerRadius = 6.0;
    _queryTextField.layer.borderWidth = 1.0;
    _queryTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.view addSubview:_queryTextField];
    
    _queryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_queryButton setTitle:@"查询" forState:UIControlStateNormal];
    _queryButton.adjustsImageWhenHighlighted = NO;
    _queryButton .frame = CGRectMake((SCREEN_WIDTH-120)/2, _queryTextField.frame.origin.y+30+20, 120, 30);
    _queryButton.layer.masksToBounds = YES;
    _queryButton.layer.cornerRadius = 6;
    [_queryButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    _queryButton.backgroundColor = THEME_COLOR;
    [_queryButton addTarget:self action:@selector(queryScoreAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_queryButton];
    
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //        imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[self.imageURLs objectAtIndex:index]]];
        [imageView sd_setImageWithURL:[self.imageURLs objectAtIndex:index] placeholderImage:[UIImage imageNamed:@"image"]];
    });
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    NSLog(@"did tap index = %d", (int)index);//点击了那个图片
}

#pragma mark   -ButtionActions
/**
 *开始报名
 */
- (void)signUpAction:(id)sender {
    //    ChooseGroupViewController *chooseGroupViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseGroupViewController"];
    //    chooseGroupViewController.competition = _competition;
    ChooseTableViewController * chooseTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseTableViewController"];
//    chooseTableViewController.competition = _competition;
    [self.navigationController pushViewController:chooseTableViewController animated:YES];
}
/**
 *模拟考试
 */
-(void)simulationAction:(id)sender{
    
}
/**
 * 正式考试
 */
-(void)formalTestAction:(id)sender{
    
}
/**
 * 查询分数
 */
-(void)queryScoreAction:(id)sender{
    
}




@end
