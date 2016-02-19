//
//  NavigationViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/14.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
//+(void)initialize{ //第一次调用这个类的时候
    //设置导航栏主题
//    UINavigationBar *navBar = [UINavigationBar appearance];

    
//    [navBar setBarTintColor:[UIColor whiteColor]];
//    [navBar setTintColor:[UIColor whiteColor]];
    
  
//        viewController.navigationItem.backBarButtonItem = backItem;
 
//
//    NSMutableDictionary *dicts = [NSMutableDictionary dictionary];
//    dicts[NSForegroundColorAttributeName] =  [UIColor whiteColor];
//    dicts[NSFontAttributeName] = [UIFont systemFontOfSize:20];
//    navBar.titleTextAttributes = dicts;
//    // 设置barbutton
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
//    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
//    itemAttrs[NSForegroundColorAttributeName] =  [UIColor blackColor];
//    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
//    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
//    
    //设置返回按钮背景
//    [item setBackButtonBackgroundImage: [UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [item setBackButtonBackgroundImage: [UIImage imageNamed:@"icon_back_light"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//        [item setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
//    
    
//}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"返回";
    viewController.navigationItem.backBarButtonItem = backItem;
    [super pushViewController:viewController animated:animated];
}

@end
