//
//  SetUpNewPhoneViewController.h
//  PinPin
//
//  Created by MoPellet on 15/7/21.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetUpNewPhoneViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *inputNewPhoneField;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *authCodeButton;
- (IBAction)authCodeAction:(id)sender;
@end
