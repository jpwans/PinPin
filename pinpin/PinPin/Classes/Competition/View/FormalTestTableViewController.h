//
//  FormalTestTableViewController.h
//  PinPin
//
//  Created by MoPellet on 15/8/17.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionBank.h"
#import "LibraryBank.h"
@interface FormalTestTableViewController : UIViewController
@property(nonatomic,assign)BOOL isCheckScore;
@property(nonatomic,strong) NSArray *checkArrays;
@end
