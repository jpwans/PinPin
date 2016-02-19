//
//  RadioButton.m
//  RadioButton
//
//  Created by ohkawa on 11/03/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RadioButton.h"

@interface RadioButton()
-(void)defaultInit;
-(void)otherButtonSelected:(id)sender;
-(void)handleButtonTap:(id)sender;
@end

@implementation RadioButton

@synthesize groupId=_groupId;
@synthesize index=_index;

static const NSUInteger kRadioButtonWidth=22;
static const NSUInteger kRadioButtonHeight=22;

static NSMutableArray *rb_instances=nil;
static NSMutableDictionary *rb_instancesDic=nil;  // 识别不同的组
static NSMutableDictionary *rb_observers=nil;
static NSMutableDictionary *rb_singleOrMore = nil;
#pragma mark - Observer

//+(void)addObserverForGroupId:(NSString*)groupId observer:(id)observer
+(void)addObserverForGroupId:(NSString*)groupId observer:(id)observer chosenType:(NSString * )chosenType
{
    if(!rb_observers){
        rb_observers = [[NSMutableDictionary alloc] init];
    }
    if (!rb_singleOrMore) {
        rb_singleOrMore = [[NSMutableDictionary alloc] init];
    }
    
    if ([groupId length] > 0 && observer) {
        [rb_observers setObject:observer forKey:groupId];
        // Make it weak reference
        [rb_singleOrMore setObject:chosenType forKey:groupId];
    }
    
    
}

#pragma mark - Manage Instances

+(void)registerInstance:(RadioButton*)radioButton withGroupID:(NSString *)aGroupID{
    
    if(!rb_instancesDic){
        rb_instancesDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    }
    
    if ([rb_instancesDic objectForKey:aGroupID]) {
        [[rb_instancesDic objectForKey:aGroupID] addObject:radioButton];
        [rb_instancesDic setObject:[rb_instancesDic objectForKey:aGroupID] forKey:aGroupID];
        
    }else {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:16];
        [arr addObject:radioButton];
        
        [rb_instancesDic setObject:arr forKey:aGroupID];
    }
}

#pragma mark - Class level handler

+(void)buttonSelected:(RadioButton*)radioButton{
    
    
    
    
    // Notify observers
    if (rb_observers) {
        id observer= [rb_observers objectForKey:radioButton.groupId];
        
        if(observer && [observer respondsToSelector:@selector(radioButtonSelectedAtIndex:inGroup:)]){
            
            //            [observer radioButtonSelectedAtIndex:radioButton.index inGroup:radioButton.groupId];
            [observer radioButtonSelectedAtIndex:[NSString stringWithFormat:@"%lu",(unsigned long)radioButton.index ] inGroup:radioButton.groupId];
            
        }
    }
    
    // Unselect the other radio buttons
    
    // 初始化按钮数组
    rb_instances = [rb_instancesDic objectForKey:radioButton.groupId];
    //NSLog(@"%@---%@-----%lu",rb_instances,radioButton.groupId,(unsigned long)rb_instances.count);
    if (rb_instances) {
        for (int i = 0; i < [rb_instances count]; i++) {
            RadioButton *button = [rb_instances objectAtIndex:i];
            if (![button isEqual:radioButton]) {
                [button otherButtonSelected:radioButton];
            }
        }
    }
}

#pragma mark - Object Lifecycle

-(id)initWithGroupId:(NSString*)groupId index:(NSUInteger)index{
    self = [self init];
    if (self) {
        _groupId = groupId;
        _index = index;
        
        [self defaultInit];  // 移动至此
    }
    return  self;
}




#pragma mark - Set Default Checked

- (void) setChecked:(BOOL)isChecked
{
    if (isChecked) {
        [_button setSelected:YES];
    }else {
        [_button setSelected:NO];
    }
}

#pragma mark - Tap handling

-(void)handleButtonTap:(id)sender{
    
    [_button setSelected:!_button.isSelected];
    
    NSLog(@"%lu----%@",(unsigned long)self.index,self.groupId);
    
    NSInteger  choseType = [[rb_singleOrMore objectForKey:self.groupId] integerValue];
    NSLog(@"%ld",(long)choseType);
    
    
    if (choseType ==ChosenTypeSingle) {
        if (_button.isSelected) {
            [RadioButton buttonSelected:self];
        }
        else{
            [ShareAppDelegate.answerDictionary removeObjectForKey:self.groupId];
            
        }
    }
    else{
        if (_button.isSelected) {
            //            if (rb_observers) {
            //                id observer= [rb_observers objectForKey:self.groupId];
            //
            //                if(observer && [observer respondsToSelector:@selector(radioButtonSelectedAtIndex:inGroup:)]){
            //
            //                    [observer radioButtonSelectedAtIndex:[NSString stringWithFormat:@"%lu",(unsigned long)self.index] inGroup:self.groupId];
            //                }
            //            }
            //获取原有的值
            NSString  *chose =  [ShareAppDelegate.answerDictionary objectForKey:self.groupId];
            //检查里面有没有
            if (chose.length) {//有值
                NSRange range = [chose rangeOfString:[NSString stringWithFormat:@"%lu",(unsigned long)self.index]];
                if(range.location == NSNotFound)//如果找不到 就添加
                {
                    [ShareAppDelegate.answerDictionary setObject:[NSString stringWithFormat:@"%@,%lu",chose,(unsigned long)self.index]  forKey:self.groupId];
                }
            }
            else{
                [ShareAppDelegate.answerDictionary setObject:[NSString stringWithFormat:@"%lu",self.index]  forKey:self.groupId];
            }
        }
        else{
            
            NSString  *chose =  [ShareAppDelegate.answerDictionary objectForKey:self.groupId];
            if (chose.length) {
                
                NSMutableArray * array = [[NSMutableArray alloc] init];
                array =   [[ToolKit instance]arrayWithString:chose];
                NSString *indexStr = [NSString stringWithFormat:@"%lu",(unsigned long)self.index];
                for (int i=0;i<array.count;i++) {
                    if ([indexStr isEqualToString:[array  objectAtIndex:i]]) {
                        [array removeObjectAtIndex:i];
                    }
                }
                
                if (array.count) {
                    chose = [[ToolKit instance] stringWithArray:array];
                    [ShareAppDelegate.answerDictionary setObject:chose  forKey:self.groupId];
                }
                else{
                    [ShareAppDelegate.answerDictionary removeObjectForKey:self.groupId];
                }
            }
        }
        
    }
    //多选的时候
    
    NSLog(@"%@",ShareAppDelegate.answerDictionary);
}

-(void)otherButtonSelected:(id)sender{
    // Called when other radio button instance got selected
    if(_button.selected){
        [_button setSelected:NO];
    }
}

#pragma mark - RadioButton init

-(void)defaultInit{
    // Setup container view
    self.frame = CGRectMake(0, 0, kRadioButtonWidth, kRadioButtonHeight);
    
    // Customize UIButton
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 0,kRadioButtonWidth, kRadioButtonHeight);
    _button.adjustsImageWhenHighlighted = NO;
    
    [_button setImage:[UIImage imageNamed:@"icon_Unchecked_"]  forState:UIControlStateNormal];
    [_button setImage:[UIImage imageNamed:@"icon_ Checked"] forState:UIControlStateSelected];
    
    [_button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_button];
    
    //   [RadioButton registerInstance:self];
    
    // update follow:
    [RadioButton registerInstance:self withGroupID:self.groupId];
    
}


@end
