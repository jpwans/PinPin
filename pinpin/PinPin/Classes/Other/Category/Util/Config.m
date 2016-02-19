//
//  Config.m
//  UnisouthParents
//
//  Created by neo on 14-3-26.
//  Copyright (c) 2014年 unisouth. All rights reserved.
//

#import "Config.h"

@implementation Config


static Config * instance = nil;
+(Config *) Instance
{
    @synchronized(self)
    {
        if(nil == instance)
        {
            [self new];
        }
    }
    return instance;
}


+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}



-(void)saveLoginUserInfo:(UserInfo *)loginUserInfo {
    
    
    [self removeObjectFromUserDefaults];
    
    [SYSTEM_USERDEFAULTS setObject:loginUserInfo.name forKey:Y_name];
    [SYSTEM_USERDEFAULTS setObject:loginUserInfo.phone forKey:Y_phone];
    [SYSTEM_USERDEFAULTS setObject:loginUserInfo.password forKey:Y_password];
    [SYSTEM_USERDEFAULTS setObject:loginUserInfo.photo forKey:Y_photo];
    [SYSTEM_USERDEFAULTS setObject:loginUserInfo.type forKey:Y_type];
    [SYSTEM_USERDEFAULTS setObject:loginUserInfo.sex forKey:Y_sex];
    [SYSTEM_USERDEFAULTS setObject:loginUserInfo.userId forKey:Y_userId];
    [SYSTEM_USERDEFAULTS setObject:loginUserInfo.age forKey:Y_age];
    [SYSTEM_USERDEFAULTS setObject:loginUserInfo.studentCode forKey:Y_studentCode];
        [SYSTEM_USERDEFAULTS setObject:loginUserInfo.birthday forKey:Y_birthday];
    [SYSTEM_USERDEFAULTS setBool:YES  forKey:Y_IsLogin];
    [SYSTEM_USERDEFAULTS synchronize];
}

-(BOOL)isLogin{
  
    NSString *userId = [SYSTEM_USERDEFAULTS objectForKey:Y_userId];
    if (userId) {
        return YES;
    }else{
        return NO;
    }
   
}



/**
 *  清空偏好设置里面的内容
 */
-(void)removeObjectFromUserDefaults{
    NSDictionary * dict = [SYSTEM_USERDEFAULTS dictionaryRepresentation];
    for (id key in dict) {
        if ([key isEqualToString:Y_IsFirstStart]) continue;
        [SYSTEM_USERDEFAULTS removeObjectForKey:key];
    }
    [SYSTEM_USERDEFAULTS synchronize];
}

- (void)myTask {
    sleep(3);
}




- (NSString*)getFormatterDate:(NSDate*)date
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    NSCalendar *calendar = [NSCalendar currentCalendar];//日历
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *formatterDate = [date copy];
    NSDate *endDate = [formatter dateFromString: [formatter stringFromDate:date]] ;
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date] toDate:endDate options:0];
    long year = [components year];
    long month = [components month];
    long day = [components day];
    //三天以内更改显示格式
    NSString *messageDate;
    //  NSString *title;
    if (year == 0 && month == 0 && day < 3) {
        if (day == 0) {
            //   title = NSLocalizedString(@"今天",@"11");
            [formatter setDateFormat:@"HH:mm"];
            messageDate =[NSString stringWithFormat:@"%@",[formatter stringFromDate:formatterDate]];
        } else if (day == 1) {
            //  title = NSLocalizedString(@"昨天",nil);
            [formatter setDateFormat:@"HH:mm"];
            messageDate =[NSString stringWithFormat:@"%@%@",@"昨天",[formatter stringFromDate:formatterDate]];
        }else if (day == 2) {
            //  title = NSLocalizedString(@"前天",nil);
            [formatter setDateFormat:@"HH:mm"];
            messageDate =[NSString stringWithFormat:@"%@%@",@"前天",[formatter stringFromDate:formatterDate]];
        }
    }else if(year>0){
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        messageDate =[NSString stringWithFormat:@"%@",[formatter stringFromDate:formatterDate]];
    }else{
        [formatter setDateFormat:@"MM-dd HH:mm"];
        messageDate =[NSString stringWithFormat:@"%@",[formatter stringFromDate:formatterDate]];
    }
    
    return messageDate;
}




@end
