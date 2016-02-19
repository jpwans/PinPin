


//iphone 6 6+有放大模式和，正常模式
//判断时候为IPHONE6
//#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)
#define iPhone6 [UIScreen mainScreen].bounds.size.height==667

//判断时候为IPHONE6 PLUS
//#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
#define iPhone6plus  [UIScreen mainScreen].bounds.size.height==736

//判断是否是Retina显示屏
//#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO) //iphone4
#define iPhone4 [UIScreen mainScreen].bounds.size.height==480
//判断是否是iPhone5
//#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) //iphone5
#define iPhone5 [UIScreen mainScreen].bounds.size.height==568  //iphone5

//主屏宽
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//主屏高
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//当前设备的ios版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS7  ([[UIDevice currentDevice].systemVersion doubleValue] >=7.0)
//当前设备的语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//软键盘高度
#define KEYBOARD_HEIGHT 216.0f
//状态栏高度
#define STATUS_HEIGHT 20.0f
//[[UIApplication sharedApplication] statusBarFrame].size.height
//导航栏高度
#define NAVIGATION_HEIGHT  44.0f
//(self.navigationController.navigationBar.frame.size.height)
//tabBar高度
#define BUTTOMBAR_HEIGHT 49.0f
//(self.tabBarController.tabBar.frame.size.height)

enum PersonalType{
    P_name = 1,
    P_sex = 2,
    P_age = 3,
    P_birthday = 4,
    P_phone = 5
};

enum ChooseType{
    C_Office = 1,
    C_School = 2,
    C_Group = 3
};
typedef enum {
    StudentStatusNotSignUp,//未报名
    StudentStatusAlreadySignUp,//已报名
    StudentStatusAlreadyMatch,//已比赛
    //     StudentStatusCheckScore//可查分
} StudentStatus;

typedef enum {
 SubmitStatusNot ,//未提交
SubmitStatusAlready
} SubmitStatus;

typedef enum {
    TestStatusSimulation,//模拟比赛
    TestStatusFormal//正式比赛
} TestStatus;

typedef enum {
    TestSetTypePic=1,//图片
    TestSetTypePicVoice,//
    TestSetTypePicContent,
    TestSetTypeContent,
    TestSetTypeContentVoice
} TestSetType;

typedef enum {
    ChoiceVertical =1,//竖
    ChoiceHorizontal=2,//横
} ChoiceShowStatus;
typedef enum {
    ChoiceTypeText=1,// 文本
    ChoiceTypePicVoice,//图片加语音
    ChoiceTypePic//图片
}ChoiceType;

typedef enum {
    ChosenTypeSingle=1,// 单选
    ChosenTypeMore,//多选
    ChosenTypeMultiple//不定项
}ChosenType;


//chosenType

#define ImagePlayerHeight  SCREEN_WIDTH * 480/720 //图片轮播高度
#define BannerHeight SCREEN_WIDTH * 624 /720
#define DEFAULT_FRAME CGRectMake(0.,0.,SCREEN_WIDTH,SCREEN_HEIGHT)
//设置系统字体大小
#define SystemFont(size) [UIFont systemFontOfSize:(size)];
//去掉状态栏和导航栏的视图大小
#define BOTTOM_FRAME CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-STATUS_HEIGHT-NAVIGATION_HEIGHT)
//去掉状态栏,导航栏和TabBar的视图大小
#define MIDDLE_FRAME CGRectMake(0,NAVIGATION_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-STATUS_HEIGHT-NAVIGATION_HEIGHT-BUTTOMBAR_HEIGHT)
//默认采色
//#define THEME_COLOR [UIColor colorWithRed:230.0/255.0 green:80.0/255.0 blue:78.0/255.0 alpha:1.0] //主题色
#define THEME_COLOR [UIColor colorWithRed:245.0/255.0 green:93.0/255.0 blue:100.0/255.0 alpha:1.0] //主题色 ＃f55d64




#define BACKGROUND_COLOR  [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0] //背景色

#define TEST_BIGBACKGROUND_COLOR [UIColor colorWithRed:212.0/255.0 green:213.0/255.0 blue:214.0/255.0 alpha:1.0] //答题大背景色

#define TEST_SMALLBACKGROUND_COLOR [UIColor colorWithRed:235.0/255.0 green:236.0/255.0 blue:237.0/255.0 alpha:1.0] //答题小题目背景色

//空值
#define NULL_VALUE @""
//Json里的基本字段
#define Y_Code      @"code"
#define Y_Ver       @"ver"
#define Y_Data      @"data"
#define Y_Message   @"message"
#define Y_Records @"records"

#define Y_Code_Failure  101
#define Y_Code_Success 1
#define NetError @"网络异常..."
#define Y_Version  [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]

/**
 *偏好设置
 */
#define Y_IsFirstStart @"firstStart"
#define Y_IsLogin @"isLogin"
#define Y_phone @"phone"
#define Y_name @"name"
#define Y_photo @"photo"
#define Y_headPhoto @"headPhoto"
#define Y_password @"password"
#define Y_type @"type"
#define Y_sex @"sex"
#define Y_sex_male @"1"
#define Y_sex_female @"2"
#define Y_userId @"userId"
#define Y_age @"age"
#define Y_studentCode @"studentCode"
#define Y_birthday @"birthday"

#define HeadPhotoPath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"head.png"]]
/**
 *账号相关
 */
//测试id
//#define SMSAPPKEY @"5b2655c71290"
//#define SMSAPPSECRET @"55988074b9a3faadffa6f74cd3ae7845"
#define SMSAPPKEY @"91d77a67bfee"
#define SMSAPPSECRET @"f4c62ef1c500f3e7002558dceb72da4f"
#define ZONE @"86"
#define URL_SMS_AUTH @"https://api.sms.mob.com/sms/verify"//短信验证
#define UMENG_APPKEY @"55b5d12167e58e9d7d001c7b"

#define ShareAppKey @"8cda551efbe9"
#define ShareAppSecret @"88c6c042326f8648e8a16379efeea2d3"

#define WeiXinAppId @"wxf8822f6a9cce5813"
#define WeiXinAppSecret @"4d2a5dc5a47baef73ae1ab3bb8a9b43c"


/**
 *  通知相关
 */

#define Notif_Share_Video @"shareVideo"
#define Notif_Back @"back"
#define Notif_Refresh @"refresh"
#define Notif_SendValue @"sendValue"
#define Notif_RefreshCompetition @"refreshDeleteCompetition"
//API路径
#define URL_QINIU @"http://7xk9i8.com1.z0.glb.clouddn.com/"//七牛云
#define URL_TOKEN @"/f/rest/in/file/getUpToken0" //获取Token
//NSString * const URL_QINIU = @"http://7xk9i8.com1.z0.glb.clouddn.com/";
#define VideoName @"videoName"

//#define API_BASE_URL_STRING(_URL_) [NSString stringWithFormat:@"%@%@",@"http://112.74.194.198:8080/pinpin/",_URL_] //测试环境

#define API_BASE_URL_STRING(_URL_) [NSString stringWithFormat:@"%@%@",@"http://pinpinenglish.cn/",_URL_] //正式环境

#define URL_Register @"f/rest/login/register" //注册成功
#define URL_Login @"f/rest/login/login"//登陆
#define URL_ForgetPassword @"f/rest/login/forgetPassword"//忘记密码
#define URL_UpdatePassword @"f/rest/in/student/updatePassword"//修改密码
#define URL_UpdateStudentInfo @"f/rest/in/student/updateStudentInfo"//修改个人信息
#define URL_UpdatePhoto @"f/rest/in/student/updatePhoto"//修改头像
#define URL_Feedback @"/f/rest/in/mobcomment/insertMobComment"//意见反馈
#define URL_DeleteComptition @"f/rest/in/comptition/deleteComptition"//删除报名信息
//---------赛事
#define URL_SignUp @"f/rest/in/comptition/signUp"//学生报名

//#define URL_Comptition @"f/rest/in/comptition/comptition"//赛事
#define URL_Comptition @"f/rest/comptition/comptition"//赛事
#define URL_FindStudentStatus @"f/rest/in/comptition/findStudentStatus"//获取学生竞赛状态
#define URL_GetComptitions @"f/rest/comptition/getComptitions"//获取竞赛信息

#define URL_FindStudentStatusForOneComp @"f/rest/in/comptition/findStudentStatusForOneComp"//获取单个学生竞赛状态
#define URL_OfficeInfo @"f/rest/in/comptition/officeInfo"//获取站点信息
#define URL_SchoolInfo @"f/rest/in/comptition/schoolInfo"//获取学校信息
#define URL_GroupInfo @"f/rest/in/comptition/groupInfo"//获取人群组信息
#define URL_GetLibrarhyBanks @"f/rest/in/librarhyBank/librarhyBanks"//随机题库
#define URL_SubmitTest @"f/rest/in/librarhyBank/library"//题库提交，答题完成
#define URL_StudentCompetitionInfo @"f/rest/in/librarhyBank/findParticipartionInfo" //学生竞赛信息
#define URL_BanksDetails @"f/rest/in/librarhyBank/banksDetails"//答题详情
#define URL_FindStudentInfoByCode @"f/rest/in/librarhyBank/findStudentInfoByCode"//根据竞赛编号查询学生信息
//获取UserDefault
#define SYSTEM_USERDEFAULTS [NSUserDefaults standardUserDefaults]




//提示信息，页面停留时间
#define MakeToast_Time 4.0f

//RGB颜色转换（16进制->10进制）
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define ShareAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


//获取当前应用版本号
#define Y_APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

