//
//  FeedbackViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/27.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _feedbackTextView = [UIPlaceholderTextView new];
    _feedbackTextView.placeholder = @"您的反馈我们将尽快为您答复";
    _feedbackTextView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _feedbackTextView.layer.borderWidth=1;
    _feedbackTextView.layer.masksToBounds=YES;
    _feedbackTextView.layer.cornerRadius = 6;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _feedbackTextView.frame = CGRectMake(10, 72, SCREEN_WIDTH-20, SCREEN_HEIGHT/2);
    [self.view addSubview:_feedbackTextView];
    [self createBtn];
}
/**
 *  创建提交按钮
 */
-(void)createBtn{
    UIBarButtonItem *  rightButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = rightButton;
}
-(void)submit{
    if([_feedbackTextView.text trimString].length){
//        [MBProgressHUD showMessage:nil];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[MeHandle instance] uploadFeedback:_feedbackTextView.text WithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
            if (!error) {
//                        [MBProgressHUD hideHUD];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
                    UIAlertView *alertView =[ [UIAlertView alloc] initWithTitle:@"提示" message:@"您的意见我们已收到，我们将尽快为您处理，感谢您的支持。" delegate:self cancelButtonTitle:@"继续吐槽" otherButtonTitles:@"下次再吐", nil];
                    [alertView show];
                }
                else{
                        [MBProgressHUD hideHUD];
                    [self.view makeToast:dictionary[Y_Message] duration:1.5f position:@"center"];
                }
            }
            else{
                    [MBProgressHUD hideHUD];
                [MBProgressHUD showError:[error localizedDescription]];
            }
        }];
    }
    else{
        [self.view makeToast:@"客官，还没有填写反馈信息哟。" duration:1.5f position:@"center"];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        _feedbackTextView.text = @"";
    }
    else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
