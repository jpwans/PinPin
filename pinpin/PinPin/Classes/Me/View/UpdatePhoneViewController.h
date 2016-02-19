//
//  UpdatePhoneViewController.h
//  PinPin
//
//  Created by MoPellet on 15/7/19.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePhoneViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *inputPhoneField;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *authCodeButton;
- (IBAction)authCodeAction:(id)sender;
@end
