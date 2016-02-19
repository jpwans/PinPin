//
//  SignUpDetailsViewController.h
//  PinPin
//
//  Created by MoPellet on 15/7/31.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic)  ImagePlayerView *imagePlayerView;
@property (strong, nonatomic)  UIButton *signUpButton;

@end
