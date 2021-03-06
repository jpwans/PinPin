

#import "CoreDateManager.h"

@implementation CoreDateManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static CoreDateManager *instance = nil;

+ (CoreDateManager*)instance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[super alloc] init];
    });
    return instance;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:Model withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:DatabaseName];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.??????Documents??????
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



#pragma mark - ?????????
/**
 *??????libraryBank??????
 */
- (void)insertLibraryDB:(QuestionBank*)questionBank cId:(NSString *)cId
{
    NSManagedObjectContext *context = [self managedObjectContext];
    QuestionBankDB *questionBankDB =  [NSEntityDescription insertNewObjectForEntityForName:QuestionBankTable inManagedObjectContext:context];
    NSString *subjectId = [CoreDateManager uuid];
    questionBankDB.choiceShowType = questionBank.choiceShowType;
    questionBankDB.libraryDescription=questionBank.libraryDescription;
    questionBankDB.librarySetting=questionBank.librarySetting;
    questionBankDB.libraryTypeId = questionBank.libraryTypeId;
    questionBankDB.score = questionBank.score;
    questionBankDB.chosenType = questionBank.chosenType;
    questionBankDB.cId = cId;
    questionBankDB.subjectId =subjectId;
    NSError *error;
    
    for (LibraryBank *libraryBank in questionBank.libraryBankArrays ) {
        LibraryBankDB *libraryBankDB =[NSEntityDescription insertNewObjectForEntityForName:LibraryBankTbale inManagedObjectContext:context];
        libraryBankDB.libraryBankAnswers =libraryBank.libraryBankAnswers;
        libraryBankDB.libraryBankChoice =[NSString stringWithFormat:@"%@", libraryBank.libraryBankChoice];
        libraryBankDB.libraryBankChoiceType =libraryBank.libraryBankChoiceType;
        libraryBankDB.libraryBankContent =libraryBank.libraryBankContent;
        libraryBankDB.libraryBankId =libraryBank.libraryBankId;
        libraryBankDB.libraryBankPic =libraryBank.libraryBankPic;
        libraryBankDB.libraryBankVoice =libraryBank.libraryBankVoice;
        libraryBankDB.subjectId = subjectId;
        if (![context save:&error]) {
            NSLog(@"Error:%@",[error localizedDescription]);
        }
    }
    
}
/**
 *??????ComptitionDB??????
 */
- (NSString *)insertComptitionDB:(Competition *)competition TestStatus:(TestStatus )testStatus
{
    NSString *uuid = [CoreDateManager uuid];
    NSManagedObjectContext *context = [self managedObjectContext];
    ComptitionDB *comptitionDB = [NSEntityDescription insertNewObjectForEntityForName:ComptitionTable inManagedObjectContext:context];
    comptitionDB.cId = uuid;
    comptitionDB.comptitonId = competition.comptitionId;
    comptitionDB.comptitonName = competition.name;
    comptitionDB.groupName = competition.groupName;
    comptitionDB.groupType = competition.groupId;
    comptitionDB.testType = [NSString stringWithFormat:@"%d", testStatus] ;
    comptitionDB.createTime = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    comptitionDB.createUser = [SYSTEM_USERDEFAULTS objectForKey:Y_userId];
    comptitionDB.isSubmit = [NSString  stringWithFormat:@"%d",SubmitStatusNot];
    NSError *error;
    BOOL isSaveSuccess=[context save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",[error localizedDescription]);
        return NULL_VALUE;
    }else{
        NSLog(@"Save successful!");
        return uuid;
    }
}

-(void)downloadWith:(Competition *)competition TestStatus:(TestStatus )testStatus WithCompletionHandler:(void (^)())block {
    [[CompetitionHandle instance] getLibrarhyBanksCompetition:competition  TestStatus:testStatus  WithCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            
            if ([dictionary[Y_Code] intValue]==Y_Code_Success) {
                if (dictionary[Y_Data][Y_Records]==nil) {
                    return ;
                }
                NSString *uuid = [self insertComptitionDB:competition TestStatus:testStatus];
                if (![uuid isEmptyString]) {
                    ShareAppDelegate.testArrays = [NSMutableArray new];
                    for (NSDictionary *dict in dictionary[Y_Data][Y_Records]) {
                        // ??????????????????
                        QuestionBank *questionBank = [QuestionBank objectWithKeyValues:dict];
                        questionBank.libraryBankArrays = [NSMutableArray new];
                        for(NSDictionary *parents in [dict objectForKey:@"libraryBank"] ){
                            LibraryBank *libraryBank = [LibraryBank objectWithKeyValues:parents];
                            [questionBank.libraryBankArrays addObject:libraryBank];
                        }
                        [self insertLibraryDB:questionBank cId:uuid];
                    }
                    if (block) {
                        block();
                    }
                }
            }
            else{
                [MBProgressHUD showError:dictionary[Y_Message]];
            }
        }
        else{
            [MBProgressHUD showError:[error localizedDescription]];
        }
    }];
    
}

+(NSString*)uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

/**
 *  ????????????????????????
 */
-(NSString *)isCheckHaveTestStatus:(TestStatus )testStatus{
    //        NSManagedObjectContext *context = [self managedObjectContext];
    // 0.????????????????????????????????????
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:DatabaseName ];
    
    // 1.???????????????????????????
    self.db = [FMDatabase databaseWithPath:filename];
    //    NSMutableArray *resultArray = [NSMutableArray array];
    
    // 2.???????????????
    if ( [self.db open] ) {
        NSLog(@"?????????????????????");
        NSString *sql = [NSString stringWithFormat:@"select ZCID  from ZCOMPTITIONDB  where  ZcomptitonId = '%@' and ztestType = '%u' ;",ShareAppDelegate.SignUpCompetition.comptitionId,testStatus];
        // 1.????????????
        FMResultSet *rs = [self.db executeQuery:sql];
        NSString *cId ;
        // 2.???????????????
        while (rs.next) {
            cId = [rs stringForColumn:@"ZCID"];
        }
        return cId;
    }
    return nil;
}

/**
 *  ???????????????????????????
 */
-(NSMutableArray *)queryTestArraysWithcId:(NSString *)cId{
    //    NSManagedObjectContext *context = [self managedObjectContext];
    // 0.????????????????????????????????????
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:DatabaseName];
    
    // 1.???????????????????????????
    self.db = [FMDatabase databaseWithPath:filename];
    NSMutableArray *resultArray = [NSMutableArray array];
    // 2.???????????????
    if ( [self.db open] ) {
        NSString *sql = [NSString stringWithFormat:@"select * from ZQUESTIONBANKDB   where  ZCID ='%@';",cId];
        // 1.????????????
        FMResultSet *rs = [self.db executeQuery:sql];
        // 2.???????????????
        while (rs.next) {
            QuestionBank *questionBank = [QuestionBank new];
            questionBank.chosenType = [rs stringForColumn:@"zchosenType"];
            questionBank.choiceShowType = [rs stringForColumn:@"zchoiceShowType"];
            questionBank.libraryDescription = [rs stringForColumn:@"zlibraryDescription"];
            questionBank.librarySetting = [rs stringForColumn:@"zlibrarySetting"];
            questionBank.libraryTypeId = [rs stringForColumn:@"zlibraryTypeId"];
            questionBank.score = [rs stringForColumn:@"zscore"];
            questionBank.libraryBankArrays = [NSMutableArray new];
            sql = [NSString stringWithFormat:@"select * from ZLIBRARYBANKDB where  zsubjectid = '%@';",[rs stringForColumn:@"zsubjectId"]];
            NSLog(@"rs:%@",[rs stringForColumn:@"zsubjectId"]);
            FMResultSet *twors = [self.db executeQuery:sql];
            while (twors.next) {
                LibraryBank * libraryBank = [LibraryBank new];
                libraryBank.libraryBankChoice = [twors stringForColumn:@"zlibraryBankChoice"];
                libraryBank.libraryBankAnswers = [twors stringForColumn:@"zlibraryBankAnswers"];
                libraryBank.libraryBankChoiceType = [twors stringForColumn:@"zlibraryBankChoiceType"];
                libraryBank.libraryBankContent = [twors stringForColumn:@"zlibraryBankContent"];
                libraryBank.libraryBankId = [twors stringForColumn:@"zlibraryBankId"];
                libraryBank.libraryBankPic = [twors stringForColumn:@"zlibraryBankPic"];
                libraryBank.libraryBankVoice = [twors stringForColumn:@"zlibraryBankVoice"];
                
                
                [questionBank.libraryBankArrays addObject:libraryBank];
            }
            [resultArray addObject:questionBank];
        }
    }
    return resultArray;
}

/**
 *  ?????????????????????????????????
 */
-(NSMutableArray *)queryTestResultArraysWithcId:(NSString *)cId{
    //    NSManagedObjectContext *context = [self managedObjectContext];
    // 0.????????????????????????????????????
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:DatabaseName];
    
    // 1.???????????????????????????
    self.db = [FMDatabase databaseWithPath:filename];
    NSMutableArray *resultArray = [NSMutableArray array];
    // 2.???????????????
    if ( [self.db open] ) {
        NSString *sql = [NSString stringWithFormat:@"select * from ZQUESTIONBANKDB   where  ZCID ='%@';",cId];
        // 1.????????????
        FMResultSet *rs = [self.db executeQuery:sql];
        // 2.???????????????
        while (rs.next) {
            QuestionBank *questionBank = [QuestionBank new];
            questionBank.chosenType = [rs stringForColumn:@"zchosenType"];
            questionBank.choiceShowType = [rs stringForColumn:@"zchoiceShowType"];
            questionBank.libraryDescription = [rs stringForColumn:@"zlibraryDescription"];
            questionBank.librarySetting = [rs stringForColumn:@"zlibrarySetting"];
            questionBank.libraryTypeId = [rs stringForColumn:@"zlibraryTypeId"];
            questionBank.score = [rs stringForColumn:@"zscore"];
            questionBank.libraryBankArrays = [NSMutableArray new];
            sql = [NSString stringWithFormat:@"select * from ZLIBRARYBANKDB where  zsubjectid = '%@';",[rs stringForColumn:@"zsubjectId"]];
            
            FMResultSet *twors = [self.db executeQuery:sql];
            while (twors.next) {
                LibraryBank * libraryBank = [LibraryBank new];
                libraryBank.libraryBankChoice = [twors stringForColumn:@"zlibraryBankChoice"];
                libraryBank.libraryBankAnswers = [twors stringForColumn:@"zlibraryBankAnswers"];
                libraryBank.libraryBankChoiceType = [twors stringForColumn:@"zlibraryBankChoiceType"];
                libraryBank.libraryBankContent = [twors stringForColumn:@"zlibraryBankContent"];
                libraryBank.libraryBankId = [twors stringForColumn:@"zlibraryBankId"];
                libraryBank.libraryBankPic = [twors stringForColumn:@"zlibraryBankPic"];
                libraryBank.libraryBankVoice = [twors stringForColumn:@"zlibraryBankVoice"];
                sql = [NSString stringWithFormat:@"SELECT zmyChoose,zistrue from  ZRECORDDB  where  zlibraryBankId = '%@' ;",libraryBank.libraryBankId];
                FMResultSet *threers = [self.db executeQuery:sql];
                while (threers.next) {
                    libraryBank.isTrue = [threers stringForColumn:@"zistrue"];
                    libraryBank.myChoose = [threers stringForColumn:@"zmyChoose"];
                }
                [questionBank.libraryBankArrays addObject:libraryBank];
            }
            [resultArray addObject:questionBank];
        }
    }
    return resultArray;
}

/**
 *  ???????????????????????????????????????
 */
-(NSMutableArray *)queryFormalTestResultArraysWithcId:(NSString *)cId :(NSArray *)testArray{
    //    NSManagedObjectContext *context = [self managedObjectContext];
    // 0.????????????????????????????????????
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:DatabaseName];
    
    // 1.???????????????????????????
    self.db = [FMDatabase databaseWithPath:filename];
    NSMutableArray *resultArray = [NSMutableArray array];
    // 2.???????????????
    if ( [self.db open] ) {
        NSString *sql = [NSString stringWithFormat:@"select * from ZQUESTIONBANKDB   where  ZCID ='%@';",cId];
        // 1.????????????
        FMResultSet *rs = [self.db executeQuery:sql];
        // 2.???????????????
        while (rs.next) {
            QuestionBank *questionBank = [QuestionBank new];
            questionBank.chosenType = [rs stringForColumn:@"zchosenType"];
            questionBank.choiceShowType = [rs stringForColumn:@"zchoiceShowType"];
            questionBank.libraryDescription = [rs stringForColumn:@"zlibraryDescription"];
            questionBank.librarySetting = [rs stringForColumn:@"zlibrarySetting"];
            questionBank.libraryTypeId = [rs stringForColumn:@"zlibraryTypeId"];
            questionBank.score = [rs stringForColumn:@"zscore"];
            questionBank.libraryBankArrays = [NSMutableArray new];
            sql = [NSString stringWithFormat:@"select * from ZLIBRARYBANKDB where  zsubjectid = '%@';",[rs stringForColumn:@"zsubjectId"]];
            
            FMResultSet *twors = [self.db executeQuery:sql];
            while (twors.next) {
                LibraryBank * libraryBank = [LibraryBank new];
                libraryBank.libraryBankChoice = [twors stringForColumn:@"zlibraryBankChoice"];
                libraryBank.libraryBankAnswers = [twors stringForColumn:@"zlibraryBankAnswers"];
                libraryBank.libraryBankChoiceType = [twors stringForColumn:@"zlibraryBankChoiceType"];
                libraryBank.libraryBankContent = [twors stringForColumn:@"zlibraryBankContent"];
                libraryBank.libraryBankId = [twors stringForColumn:@"zlibraryBankId"];
                libraryBank.libraryBankPic = [twors stringForColumn:@"zlibraryBankPic"];
                libraryBank.libraryBankVoice = [twors stringForColumn:@"zlibraryBankVoice"];
                for (int i=0; i<testArray.count; i++) {
                    LibraryBank *testlibraryBank = [testArray objectAtIndex:i];
                    if ( [testlibraryBank.libraryBankId isEqualToString:libraryBank.libraryBankId]) {
                        libraryBank.isTrue =@"0";
                        if ([testlibraryBank.myChoose isEqualToString:testlibraryBank.correctChoose] ) {
                             libraryBank.isTrue = @"1";
                        }
                        libraryBank.libraryBankAnswers  =testlibraryBank .correctChoose;
                        libraryBank.myChoose =testlibraryBank.myChoose;
                    }
                }
                [questionBank.libraryBankArrays addObject:libraryBank];
            }
            [resultArray addObject:questionBank];
        }
    }
    return resultArray;
}




-(NSString *)getFileName{
    
    return  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:DatabaseName];
}

/**
 *  ??????????????????
 */
-(NSString *)getSimulationCountWith:(NSString *)cId{
    // 0.????????????????????????????????????
    NSString *filename =[self getFileName];
    NSLog(@"%@",filename);
    // 1.???????????????????????????
    self.db = [FMDatabase databaseWithPath:filename];
    NSString *SimulationCount  = [NSString new];
    // 2.???????????????
    if ( [self.db open] ) {
        NSString *sql = [NSString stringWithFormat:@"select zsimulationCount from zRecordDB   where  ZCID ='%@';",cId];
        // 1.????????????
        FMResultSet *rs = [self.db executeQuery:sql];
        
        // 2.???????????????
        while (rs.next) {
            SimulationCount  = [rs stringForColumn:@"zsimulationCount"];
        }
        
    }
    SimulationCount  =[NSString stringWithFormat:@"%d", [SimulationCount intValue] +1];
    return SimulationCount;
}

/**
 *??????LibraryTypeId ?????????
 */
-(NSString *)queryScoreByLibraryTypeId:(NSString *)LibraryTypeId{
    NSString *filename =[self getFileName];
    // 1.???????????????????????????
    self.db = [FMDatabase databaseWithPath:filename];
    NSString *score  = [NSString new];
    // 2.???????????????
    if ( [self.db open] ) {
        NSString *sql = [NSString stringWithFormat:@"select ZSCORE  from ZQUESTIONBANKDB where ZLIBRARYTYPEID = '%@';",LibraryTypeId];
        // 1.????????????
        FMResultSet *rs = [self.db executeQuery:sql];
        
        // 2.???????????????
        while (rs.next) {
            score  = [rs stringForColumn:@"ZSCORE"];
        }
    }
    return score;
}
/**
 *  LibraryBankId ???????????????
 */
-(NSString *)queryTrueChooseByLibraryBankId:(NSString *)LibraryBankId{
    NSString *filename =[self getFileName];
    // 1.???????????????????????????
    self.db = [FMDatabase databaseWithPath:filename];
    NSString *trueChoose  = [NSString new];
    // 2.???????????????
    if ( [self.db open] ) {
        NSString *sql = [NSString stringWithFormat:@"select  ZLIBRARYBANKANSWERS from ZLIBRARYBANKDB where  ZLIBRARYBANKID = '%@';",LibraryBankId];
        // 1.????????????
        FMResultSet *rs = [self.db executeQuery:sql];
        
        // 2.???????????????
        while (rs.next) {
            trueChoose  = [rs stringForColumn:@"ZLIBRARYBANKANSWERS"];
        }
    }
    return trueChoose;
    
}



-(void)insertRecordDB:(RecordModel *)recordModel{
    NSManagedObjectContext *context = [self managedObjectContext];
    RecordDB *recordDB = [NSEntityDescription insertNewObjectForEntityForName:RecordTable inManagedObjectContext:context];
    
    recordDB.cId =recordModel.cId;
    recordDB.isTrue =recordModel.isTrue;
    recordDB.libraryBankId =recordModel.libraryBankId;
    recordDB.myChoose =recordModel.myChoose;
    recordDB.recordId =recordModel.recordId;
    recordDB.score =recordModel.score;
    recordDB.simulationCount =recordModel.simulationCount;
    NSError *error;
    BOOL isSaveSuccess=[context save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",[error localizedDescription]);
    }else{
        NSLog(@"Save successful!");
    }
}

/**
 *  ??????CID??????
 */
-( BOOL)deleteRecordDB:(NSString *)cId{
    NSString *filename =[self getFileName];
    // 1.???????????????????????????
    self.db = [FMDatabase databaseWithPath:filename];
    // 2.???????????????
    BOOL  b =NO;
    if ( [self.db open] ) {
        NSString *sql = [NSString stringWithFormat:@"delete  from  ZRECORDDB where ZCID = '%@';",cId];
        // 1.????????????
        b = [self.db executeUpdate:sql];
    }
    return b;
}

/**
 *?????????????????????
 */
-(BOOL)queryRecordDB:(NSString *)cId{
    NSString *filename =[self getFileName];
    // 1.???????????????????????????
    self.db = [FMDatabase databaseWithPath:filename];
    // 2.???????????????
    BOOL  b =NO;
    int count = 0;
    if ( [self.db open] ) {
        NSString *sql = [NSString stringWithFormat:@"select count(*) count  from  ZRECORDDB where ZCID = '%@';",cId];
        // 1.????????????
        FMResultSet *rs = [self.db executeQuery:sql];
        while (rs.next) {
            count  = [[rs stringForColumn:@"count"] intValue];
        }
        if (count) {
            b=YES;
        }
    }
    return b;
}

/**
 *????????????
 */
-(Scores * )queryScore:(NSString *)cId {
    NSString *filename =[self getFileName];
    // 1.???????????????????????????
    self.db = [FMDatabase databaseWithPath:filename];
    Scores *scores = [[Scores alloc] init];
    // 2.???????????????
    if ( [self.db open] ) {
        NSString *sql = [NSString stringWithFormat:@"select sum(zscore)  score  ,(select  count(*) from ZRECORDDB WHERE zscore !='0' AND ZCID = '%@') trueCount ,(select  count(*) from ZRECORDDB WHERE zscore ='0'  AND ZCID = '%@') errorCount   from ZRECORDDB  where ZCID = '%@';",cId,cId,cId];
        // 1.????????????
        FMResultSet *rs = [self.db executeQuery:sql];
        
        // 2.???????????????
        while (rs.next) {
            scores.score  = [[rs stringForColumn:@"score"] floatValue];
            scores.trueCount  = [[rs stringForColumn:@"trueCount"] intValue];
            scores.errorCount  = [[rs stringForColumn:@"errorCount"] intValue];
        }
    }
    return scores;
}


/**
 *  ????????????????????????????????????????????????
 */
-(int )queryCount:(NSString *)cId {
    NSString *filename =[self getFileName];
    // 1.???????????????????????????
    self.db = [FMDatabase databaseWithPath:filename];
    int count = 0;
    // 2.???????????????
    if ( [self.db open] ) {
        NSString *sql = [NSString stringWithFormat:@"select count(*) count  from  ZRECORDDB where ZCID = '%@';",cId];
        // 1.????????????
        FMResultSet *rs = [self.db executeQuery:sql];
        
        // 2.???????????????
        while (rs.next) {
            count  = [[rs stringForColumn:@"count"] floatValue];
            
        }
    }
    return count;
}

-(void)deleteAllData:(NSString *)cId{
    
    NSString *filename =[self getFileName];
    // 1.???????????????????????????
    self.db = [FMDatabase databaseWithPath:filename];
    // 2.???????????????
    if ( [self.db open] ) {
        NSString *subjectId = [NSString new];
        NSString *sql = [NSString stringWithFormat:@"select zsubjectid from zquestionbankdb  where ZCID = '%@';",cId];
        // 1.????????????
        FMResultSet *rs = [self.db executeQuery:sql];
        
        // 2.???????????????
        while (rs.next) {
            subjectId  = [rs stringForColumn:@"zsubjectid"];
            if (subjectId.length) {
                sql = [NSString stringWithFormat:@"delete  from zLibraryBankDB  where zsubjectid = '%@';",subjectId];
                // 1.????????????
                BOOL b =    [ self.db executeUpdate:sql];
                if (b) {
                    NSLog(@"delete  zLibraryBankDB  successful");
                }
            }
        }
        
        sql = [NSString stringWithFormat:@"delete  from zquestionbankdb  where zcid = '%@';",cId];
        
        BOOL b =    [ self.db executeUpdate:sql];
        if (b) {
            NSLog(@"delete  zquestionbankdb  successful");
        }
        sql = [NSString stringWithFormat:@"delete from zComptitionDB where zcid = '%@'",cId];
        b =    [ self.db executeUpdate:sql];
        if (b) {
            NSLog(@"delete  zComptitionDB  successful");
        }
        
    }
    
}



@end

