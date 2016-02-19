//
//  CompetitionHandle.m
//  PinPin
//
//  Created by MoPellet on 15/7/20.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "CompetitionHandle.h"

@implementation CompetitionHandle
static CompetitionHandle *instance = nil;

+ (CompetitionHandle*)instance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[super alloc] init];
    });
    return instance;
}

/**
 *获取赛事
 */
-(void)getComptitionWithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [RestClient getAFHTTPRequestOperationManagerPutheaderPost];
    [manager POST:API_BASE_URL_STRING(URL_Comptition) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *获取单个学生竞赛状态
 */
-(void)findStudentStatusForOneCompWithCompletionHandler:(NSString *)compitionId WithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [RestClient getAFHTTPRequestOperationManagerPutheaderPost];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                compitionId,@"comptitionId",
                                nil];
    [manager POST:API_BASE_URL_STRING(URL_FindStudentStatusForOneComp) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *获取学生竞赛状态
 */
-(void)findStudentStatusWithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [RestClient getAFHTTPRequestOperationManagerPutheaderPost];
    NSLog(@"ddddddd==%@",API_BASE_URL_STRING(URL_FindStudentStatus));
    [manager POST:API_BASE_URL_STRING(URL_FindStudentStatus) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *获取竞赛列表
 */
-(void)getComptitionsWithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [RestClient getAFHTTPRequestOperationManagerPutheaderPost];
  
    [manager POST:API_BASE_URL_STRING(URL_GetComptitions) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *学生报名
 */
-(void)signUpWith:( SignUpInfo*)signUpInfo  WithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [RestClient getAFHTTPRequestOperationManagerPutheaderPost];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                signUpInfo.officeId,@"officeId",
                                signUpInfo.schoolId,@"schoolId",
                                signUpInfo.groupId,@"groupId",
                                signUpInfo.comptitionId,@"comptitionId",
                                signUpInfo.compCode,@"compCode",
                                nil];
    [manager POST:API_BASE_URL_STRING(URL_SignUp) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *  获取站点
 */
-(void)getOfficeInfoWithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [RestClient getAFHTTPRequestOperationManagerPutheaderPost];
    
    [manager POST:API_BASE_URL_STRING(URL_OfficeInfo) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *获取学校
 */
-(void)getSchoolInfoWithOfficeId:(NSString *)officeId WithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block
{
    
    AFHTTPRequestOperationManager *manager =[RestClient getAFHTTPRequestOperationManagerPutheaderPost];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:officeId,@"officeId",nil];
    [manager POST:API_BASE_URL_STRING(URL_SchoolInfo) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *  获取人群组
 */
-(void)getGroupWithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [RestClient getAFHTTPRequestOperationManagerPutheaderPost];
    [manager POST:API_BASE_URL_STRING(URL_GroupInfo) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *获取随机题库
 */
-(void)getLibrarhyBanksCompetition:(Competition*)competition TestStatus:(TestStatus )testStatus WithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block
{
    
    AFHTTPRequestOperationManager *manager = [RestClient getAFHTTPRequestOperationManagerPutheaderPost];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                competition.groupId,@"groupId",
                                competition.comptitionId ,@"comptitionId",
                                [NSString stringWithFormat:@"%d",testStatus],@"type",
                                nil];
    [manager POST:API_BASE_URL_STRING(URL_GetLibrarhyBanks) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *获取学生竞赛信息
 */
-(void)getStudentCompetitionInfoWithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [RestClient getAFHTTPRequestOperationManagerPutheaderPost];
    [manager POST:API_BASE_URL_STRING(URL_StudentCompetitionInfo) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *  根据竞赛编号获取学生信息
 */
-(void)getStudentInfoByCode:(NSString *)partCode WithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block{
    
    AFHTTPRequestOperationManager *manager = [RestClient getAFHTTPRequestOperationManagerPutheaderPost];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                partCode  ,@"partCode",
                                ShareAppDelegate.SignUpCompetition.comptitionId ,@"comptitionId",
                                nil];
    [manager POST:API_BASE_URL_STRING(URL_FindStudentInfoByCode) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *  获取答题详情
 */
-(void)getAnswerDetails:(StudentScore *)studentScore WithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block{
    
    AFHTTPRequestOperationManager *manager = [RestClient getAFHTTPRequestOperationManagerPutheaderPost];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                studentScore.partId,@"partId",
                                nil];
    [manager POST:API_BASE_URL_STRING(URL_BanksDetails) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *提交题库
 */
-(void)submitTest:(NSDictionary *)dictionary WithCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))block{
    

    AFHTTPRequestOperationManager *manager = [RestClient getAFHTTPRequestOperationManagerPutheaderPost];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                ShareAppDelegate.SignUpCompetition.partId,@"partId",
                                ShareAppDelegate.SignUpCompetition.comptitionId,@"comptitionId",
                                    [dictionary JSONString],@"library",
                                nil];
    [manager POST:API_BASE_URL_STRING(URL_SubmitTest) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

//-(void)downloadWithLibraryBankVoice:(NSString *)voice{
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cachesDirectory = paths[0];
//    NSString *downloadPath = [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aac",voice]];
//    NSLog(@"%@",downloadPath);
//    self.downloadOperation = [ShareAppDelegate.testsEngine downloadFatAssFileFrom:[NSString stringWithFormat:@"%@%@",URL_QINIU,voice]
//                                                                           toFile:downloadPath];
//    
//    [self.downloadOperation onDownloadProgressChanged:^(double progress) {
//        
//        DLog(@"%.2f", progress*100.0);
//        //        self.downloadProgessBar.progress = progress;
//    }];
//    
//    
//    [self.downloadOperation addCompletionHandler:^(MKNetworkOperation* completedRequest) {
//        
//        DLog(@"%@", completedRequest);
//        //        weakSelf.downloadProgessBar.progress = 0.0f;
//    }
//                                    errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
//                                        DLog(@"%@", error);
//                                        [UIAlertView showWithError:error];
//                                    }];
//}

@end
