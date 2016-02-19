//
//  CompetitionViewController.h
//  PinPin
//
//  Created by MoPellet on 15/7/16.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVoiceBubble.h"
#import "ImagePlayerView.h"
@interface CompetitionViewController : UIViewController

@property (weak, nonatomic) IBOutlet FSVoiceBubble *playVoice;
@property (strong, nonatomic)    ImagePlayerView *imagePlayerView;
@property (strong, nonatomic)  UIButton *startButton;


@property (strong, nonatomic)  UITextField *queryTextField;
@property (strong, nonatomic)  UIButton *queryButton;
@end
