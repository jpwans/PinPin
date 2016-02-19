//
//  AppDelegate.h
//  PinPin
//
//  Created by MoPellet on 15/7/13.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestsEngine.h"
#import "Competition.h"
#import "AudioPlayer.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
 @property (strong, nonatomic)  AudioPlayer *audioPlayer;
@property (strong, nonatomic) TestsEngine *testsEngine;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong)  Competition *competition;
@property (nonatomic, strong)  Competition *SignUpCompetition;
@property(nonatomic,strong)NSMutableArray *testArrays;
@property (nonatomic,strong) NSMutableDictionary *answerDictionary;
@property (nonatomic,strong) NSMutableArray *answerArrays;
@property (nonatomic,strong) NSString *cId;
-(void)initTabBarController;

@property (nonatomic, strong) UIView *startView;
@property (nonatomic, strong) UIImageView *splashView;
@end

