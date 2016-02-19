//
//  AppDelegate.m
//  PinPin
//
//  Created by MoPellet on 15/7/13.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
@interface AppDelegate ()
{
    UITabBarController *tabBarController;
}
@property (nonatomic, strong) UIStoryboard *storyboard;
@end

@implementation AppDelegate
@synthesize startView,splashView;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    sleep(1.5);
    
     [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.testsEngine = [[TestsEngine alloc] initWithDefaultSettings];
    [self.testsEngine useCache];
    
    [self appInit];
    [self umengTrack];
    [self umShareInit];
    
    return YES;
}

/**
 *  初始化App
 */
-(void)appInit{
//    if ( [[UserHandle instance] isFirstStart]) {
//        _storyboard = [UIStoryboard storyboardWithName:@"StartPage" bundle:nil];
//        ShareAppDelegate.window.rootViewController = [_storyboard instantiateInitialViewController];
//    }
//    else{
        if ( [SYSTEM_USERDEFAULTS objectForKey:Y_IsLogin]
            ) {
            _storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ShareAppDelegate.window.rootViewController = [_storyboard instantiateInitialViewController];
            [self initTabBarController];
            UserInfo *userInfo = [UserInfo new];
            userInfo.phone =[SYSTEM_USERDEFAULTS objectForKey:Y_phone];
            userInfo.password  = [DES3Util  decrypt:[SYSTEM_USERDEFAULTS objectForKey:Y_password]];
            [[UserHandle instance] loginWithUserInfo:userInfo withCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
                if (!error) {
                    if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
                        UserInfo *loginUserInfo   = [UserInfo objectWithKeyValues:dictionary[Y_Data]];
//                        NSString *phone = [SYSTEM_USERDEFAULTS objectForKey:Y_phone];
//                        if (phone.isEmptyString || ![phone isEqualToString:loginUserInfo.phone]) {
                            [[Config Instance] saveLoginUserInfo:loginUserInfo];
//                        }
                        
                    }
                }
            }];
        }else{
            _storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ShareAppDelegate.window.rootViewController = [_storyboard instantiateInitialViewController];
            [self initTabBarController];
            
//            _storyboard = [UIStoryboard storyboardWithName:@"UserHandle" bundle:nil];
//            ShareAppDelegate.window.rootViewController = [_storyboard instantiateInitialViewController]; 
        }

        
//    }
    
    
}

-(void)umShareInit{
    [SMSSDK registerApp:SMSAPPKEY withSecret:SMSAPPSECRET];//短信注册
    
    //    [UMSocialData setAppKey:@"53290df956240b6b4a0084b3"];
    [UMSocialData setAppKey:UMENG_APPKEY];
    //设置友盟社会化组件appkey
    
    //打开调试log的开关
    [UMSocialData openLog:NO];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:WeiXinAppId appSecret:WeiXinAppSecret url:@"http://www.umeng.com/social"];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
    
}
- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    //    [MobClick updateOnlineConfig];  //在线参数配置
    //    [MobClick getConfigParams];
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
    
    
}
- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}
-(void)initTabBarController
{
    tabBarController = (UITabBarController *)self.window.rootViewController;
    
    UITabBar *tabBar = tabBarController.tabBar;
    
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    
    tabBarItem1.title = @"首页";
    tabBarItem2.title = @"竞赛";
    tabBarItem3.title = @"我";
    
    
    
    [tabBar setBackgroundColor:[UIColor whiteColor]];
    tabBar.tintColor = RGBCOLOR(242, 87, 82);
    [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_home_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_home_unselected"]];
    [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_race_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_race_unselected"]];
    [tabBarItem3 setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_my_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_my_unselected"]];
    
    // Change the title color of tab bar items
    [[UITabBarItem appearance] setTitleTextAttributes: @{ NSForegroundColorAttributeName:[UIColor lightGrayColor], NSFontAttributeName:[UIFont systemFontOfSize:11], UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]} forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes: @{ NSForegroundColorAttributeName:RGBCOLOR(235, 75, 44), NSFontAttributeName:[UIFont systemFontOfSize:11], UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]} forState:UIControlStateSelected];
    
    //        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"AGShareImageBG"] forBarMetrics:UIBarMetricsDefault];
    //        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:60.0/255.0 green:116.0/255.0 blue:230.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ UITextAttributeTextColor:[UIColor whiteColor],NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"ArialMT" size:18], UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetZero]}];
    //    }
}

//- (BOOL)application:(UIApplication *)application
//      handleOpenURL:(NSURL *)url
//{
//    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
//}
/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

//iOS 4.2+
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation
//{
//    return [ShareSDK handleOpenURL:url
//                 sourceApplication:sourceApplication
//                        annotation:annotation
//                        wxDelegate:self];
//}
- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

//- (void)applicationDidBecomeActive:(UIApplication *)application {
//}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
