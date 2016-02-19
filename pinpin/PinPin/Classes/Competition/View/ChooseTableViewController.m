//
//  ChooseTableViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/24.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "ChooseTableViewController.h"
#import "ChooseOfficeTableViewController.h"
#import "ChooseSchoolTableViewController.h"
#import "ChooseGroupTableViewController.h"
@interface ChooseTableViewController ()<UITableViewDelegate,ImagePlayerViewDelegate ,MWPhotoBrowserDelegate>
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation ChooseTableViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_chooseType==C_Office) {
        _officeLable.text = _office.officeName;
    }
    else if(_chooseType == C_School){
        _schoolLable.text = _school.schoolName;
    }
    else if(_chooseType==C_Group){
        _groupLable.text = _group.groupName;
    }
    _doneButton.layer.masksToBounds = YES;
    _doneButton.layer.cornerRadius = 6.0;
    _doneButton.backgroundColor = THEME_COLOR;
    
    if (ShareAppDelegate.SignUpCompetition) {
        NSArray * array = [ShareAppDelegate.SignUpCompetition.photo componentsSeparatedByString:@"&#"];
        NSMutableArray *photoArray  = [NSMutableArray new];
        for (int i=0; i<array.count-1; i++) {
            [photoArray addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_QINIU,array[i]]]];
        }
        _imageURLs = photoArray;
        [self ImageViewWithArray:photoArray];
    }
    else{
        [self ImageViewWithArray:nil];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int status =(int)indexPath.row;
    switch (status) {
        case 1:
        {
            ChooseOfficeTableViewController *chooseOfficeTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseOfficeTableViewController"];
            [self.navigationController pushViewController:chooseOfficeTableViewController animated:YES];
            chooseOfficeTableViewController.title = @"站点";
        }
            break;
        case 2:{
            if (_office) {
                ChooseSchoolTableViewController *chooseSchoolTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseSchoolTableViewController"];
                chooseSchoolTableViewController.office = _office;
                [self.navigationController pushViewController:chooseSchoolTableViewController animated:YES];
                chooseSchoolTableViewController.title = @"学校";
                
            }
            else{
                [self.view makeToast:@"请先选择站点！" duration:1.5f position:@"center"];
            }
            
        }
            break;
        case 3:{
            ChooseGroupTableViewController *chooseGroupTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseGroupTableViewController"];
            [self.navigationController pushViewController:chooseGroupTableViewController animated:YES];
            chooseGroupTableViewController.title = @"人群组";
        }
            break;
            
        default:
            break;
    }
}



- (IBAction)doneAction:(id)sender {
    SignUpInfo *signUpInfo = [SignUpInfo new];
    if (_office.officeId==nil||_school.schoolId==nil||_group.groupId==nil) {
        return;
    }
    signUpInfo.officeId = _office.officeId;
    signUpInfo.schoolId = _school.schoolId;
    signUpInfo.groupId = _group.groupValue;
    signUpInfo.compCode = ShareAppDelegate.SignUpCompetition.compCode;
    signUpInfo.comptitionId = ShareAppDelegate.SignUpCompetition.comptitionId;
    signUpInfo.studentCode = [SYSTEM_USERDEFAULTS objectForKey:Y_studentCode];
    [[CompetitionHandle instance ]signUpWith:signUpInfo WithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        if(!error){
            if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
                [MBProgressHUD showSuccess:dictionary[Y_Message]];
                [[NSNotificationCenter defaultCenter]      postNotificationName:Notif_RefreshCompetition    object:nil];
                NSArray *viewControllers=[self.navigationController viewControllers];
                    UIViewController *popVC=[viewControllers objectAtIndex:viewControllers.count-3];
                [self.navigationController popToViewController:popVC animated:YES];
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
    [self jumplook];
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
