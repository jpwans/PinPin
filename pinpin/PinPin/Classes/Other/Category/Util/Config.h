

#import <Foundation/Foundation.h>

#import "UserInfo.h"
@interface Config : NSObject


////是否已经登录
//@property BOOL isLogin;
//
////是否具备网络链接
//@property BOOL isNetworkRunning;



+(Config *) Instance;
+(id)allocWithZone:(NSZone *)zone;

/**
 *  保存用户信息到沙盒
 */
-(void)saveLoginUserInfo:(UserInfo *)loginUserInfo ;

/**
 *是否登录
 */
-(BOOL)isLogin;


- (void)myTask ;

/**
 *  清空偏好设置里面的内容
 */
-(void)removeObjectFromUserDefaults;
//
//格式化日期
- (NSString*)getFormatterDate:(NSDate*)date;

-(NSString*)getUserDisplayName:name  user_role:(NSUInteger)userRole gender:(NSString*)gender;

-(NSString*)getGroupDisplayName:(NSString*)jid;


@end
