//
//  MeHandle.m
//  PinPin
//
//  Created by MoPellet on 15/7/17.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "MeHandle.h"

@implementation MeHandle
static MeHandle *instance = nil;

+ (MeHandle*)instance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[super alloc] init];
    });
    return instance;
}

-(void)updatePersonalInfoWithUserInfo:(UserInfo *)userInfo  withCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [RestClient getAFHTTPRequestOperationManagerPutheaderPost];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userInfo.sex?userInfo.sex:NULL_VALUE ,@"sex",
                                userInfo.name?userInfo.name:NULL_VALUE,@"name",
                                userInfo.birthday?userInfo.birthday:NULL_VALUE,@"birthday",
                                userInfo.phone?userInfo.photo:NULL_VALUE,@"phone",
                                nil];
    [manager POST:API_BASE_URL_STRING(URL_UpdateStudentInfo) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary= responseObject;
        if (block) {
            block(dictionary,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        if (block) {
            block([NSDictionary dictionary],error);
        }
    }];
}
/**
 *获取token
 */
-(void) getTokenWithCompletionHandler: (void (^)(NSDictionary *dictionary,NSError *error))block{
    
    AFHTTPRequestOperationManager *manager = [RestClient getAFHTTPRequestOperationManagerPutheaderPost];
    [manager GET:API_BASE_URL_STRING(URL_TOKEN) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary= responseObject;
        if (block) {
            block(dictionary,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSDictionary dictionary],error);
        }
    }];
}

/**
 *  修改头像
 */
-(void)updateHeadPhoto:(NSString *)photoKey WithCompletionHandler: (void (^)(NSDictionary *dictionary,NSError *error))block{
    AFHTTPRequestOperationManager *manager = [RestClient getAFHTTPRequestOperationManagerPutheaderPost];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                photoKey,@"photo",
                                nil];
    [manager POST:API_BASE_URL_STRING(URL_UpdatePhoto) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary= responseObject;
        if (block) {
            block(dictionary,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSDictionary dictionary],error);
        }
    }];
}


/**
 *上传头像到气流云
 */
-(void)uploadheadPhoto:(NSData *)imageData {
    [[MeHandle instance]getTokenWithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            if (dictionary[Y_Data]) {
                QNUploadManager *upManager = [[QNUploadManager alloc] init];
                NSString *photokey = [NSString stringWithFormat:@"%d", (int)[NSDate timeIntervalSinceReferenceDate]];
                [upManager putData:imageData key:photokey token:dictionary[Y_Data]
                          complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                              
                              NSLog(@"%@", info);
                              NSLog(@"%@", resp);
                              [[MeHandle instance]updateHeadPhoto:photokey WithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
                                  if (!error) {
                                      NSLog(@"%@",dictionary);
                                      if(dictionary[Y_Data]){
                                          /**
                                           *  存储图片和图片的ID
                                           */
                                          [SYSTEM_USERDEFAULTS setObject:imageData forKey:Y_headPhoto];
                                          [SYSTEM_USERDEFAULTS setObject: dictionary[Y_Data]forKey:Y_photo];
                                          NSString *ss = [SYSTEM_USERDEFAULTS objectForKey:Y_photo];
                                          [SYSTEM_USERDEFAULTS synchronize];
                                      }
                                  }
                                  else{
                                      [MBProgressHUD showError:NetError];
                                  }
                              }];
                          } option:nil];
            }
        }
    }];
}

/**
 *  上传意见反馈
 */
-(void)uploadFeedback:(NSString *)text WithCompletionHandler: (void (^)(NSDictionary *dictionary,NSError *error))block{
    AFHTTPRequestOperationManager *manager = [RestClient getAFHTTPRequestOperationManagerPutheaderPost];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:text,@"comment",nil];
    [manager POST:API_BASE_URL_STRING(URL_Feedback) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary= responseObject;
        if (block) {
            block(dictionary,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSDictionary dictionary],error);
        }
    }];
}

/**
 *删除报名信息
 */
-(void)deleteCompetition:(Competition *)competition WithCompletionHandler: (void (^)(NSDictionary *dictionary,NSError *error))block{
    AFHTTPRequestOperationManager *manager = [RestClient getAFHTTPRequestOperationManagerPutheaderPost];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:competition.partId,@"partId",nil];
    [manager POST:API_BASE_URL_STRING(URL_DeleteComptition) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary= responseObject;
        if (block) {
            block(dictionary,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSDictionary dictionary],error);
        }
    }];
    
}

@end
