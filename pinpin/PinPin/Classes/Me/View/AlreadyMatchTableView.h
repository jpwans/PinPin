//
//  AlreadyMatchTableView.h
//  PinPin
//
//  Created by MoPellet on 15/7/28.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlreadyMatchTableView : UITableView<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSMutableArray *arrays;
@end
