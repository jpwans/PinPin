//
//  PersonalInfoTableViewController.m
//  PinPin
//
//  Created by MoPellet on 15/7/17.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "PersonalInfoTableViewController.h"
#import "UpdateNameViewController.h"
#import "UpdateSexTableViewController.h"
#import "UpdateAgeViewController.h"
#import "UpdateBirthdayViewController.h"
#import "UpdatePhoneViewController.h"
@interface PersonalInfoTableViewController ()<UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIPickerViewDelegate>

@end

@implementation PersonalInfoTableViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_updateType == P_name) {
        _name.text = [SYSTEM_USERDEFAULTS objectForKey:Y_name];
    }
   
    else if(_updateType ==P_age){
        _ageLable.text= [SYSTEM_USERDEFAULTS objectForKey:Y_age];
    }
    else if(_updateType==P_birthday){
        _birthdayLable.text =[ToolKit timeStampConversionDate:[[SYSTEM_USERDEFAULTS objectForKey:Y_birthday] doubleValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:[ToolKit timeStampConversionDate:[[SYSTEM_USERDEFAULTS objectForKey:Y_birthday] doubleValue]]];
        NSTimeInterval dateDiff = [date timeIntervalSinceNow];
        int age=trunc(dateDiff/(60*60*24))/365;
        age=age>0?age:-age;
        _ageLable.text = [NSString stringWithFormat:@"%d",age];
    }
    else if(_updateType == P_phone){
        _phoneLable .text= [SYSTEM_USERDEFAULTS objectForKey:Y_phone];
    }
//    else if(_updateType==P_sex){
        int sex = [[SYSTEM_USERDEFAULTS objectForKey:Y_sex] intValue];
        _sexImageView.image = [UIImage imageNamed:sex==1?@"icon_male":@"icon_female"];
//    }
}


-(void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}
-(void)viewInit{
    //    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:HeadPhotoPath];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 6.0;
    _headImageView.layer.borderWidth = 1.0;
    _headImageView.layer.borderColor = [[UIColor clearColor] CGColor];
    //    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:HeadPhotoPath];

    _name.text = [SYSTEM_USERDEFAULTS objectForKey:Y_name];
    _ageLable.text= [SYSTEM_USERDEFAULTS objectForKey:Y_age];
    _phoneLable.text = [SYSTEM_USERDEFAULTS objectForKey:Y_phone];
   
    _birthdayLable.text = [ToolKit timeStampConversionDate:[[SYSTEM_USERDEFAULTS objectForKey:Y_birthday] doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:[ToolKit timeStampConversionDate:[[SYSTEM_USERDEFAULTS objectForKey:Y_birthday] doubleValue]]];
    
    NSTimeInterval dateDiff = [date timeIntervalSinceNow];
    int age=trunc(dateDiff/(60*60*24))/365;
    age=age>0?age:-age;
    _ageLable.text = [NSString stringWithFormat:@"%d",age];
    _phoneLable.text = [SYSTEM_USERDEFAULTS objectForKey:Y_phone];
    UIImage *savedImage =  [UIImage imageWithData:[SYSTEM_USERDEFAULTS objectForKey:Y_headPhoto]];
    UIImage *defaultImage = savedImage?savedImage:[UIImage imageNamed:@"Default"];
    _headImageView.layer.contents = (id)[defaultImage CGImage];
    NSString  *photoId=  [SYSTEM_USERDEFAULTS objectForKey:Y_photo];
    if (0==photoId.length) return;
    NSString *urlStr  = [NSString stringWithFormat:@"%@%@",URL_QINIU,photoId];
    NSURL *url = [NSURL URLWithString:urlStr];;
    [self.headImageView sd_setImageWithURL:url placeholderImage:defaultImage];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int status =(int)indexPath.row;
    switch (status) {
        case 0:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
            [sheet showInView:self.view];
        }
            break;
        case 1:{
            UpdateNameViewController *nameVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UpdateNameViewController"];
            [self.navigationController pushViewController:nameVC animated:YES];
            nameVC.title = @"名字";
        }
            break;
        case 2:{
            UpdateSexTableViewController *sexVC =[self.storyboard instantiateViewControllerWithIdentifier:@"UpdateSexTableViewController"];
            [self.navigationController pushViewController:sexVC animated:YES];
            sexVC.title = @"性别";
        }
            break;
        case 3:{//年龄
            // UpdateAgeViewController *ageVC =[self.storyboard instantiateViewControllerWithIdentifier:@"UpdateAgeViewController"];
            //  [self.navigationController pushViewController:ageVC animated:YES];
            //  ageVC.title = @"年龄";
//            [self.view makeToast:@"年龄不能修改 ，请修改您的生日！" duration:1.0f position:@"center"];
        }
            break;
        case 4:{//生日
            UpdateBirthdayViewController *birthdayVC =[self.storyboard instantiateViewControllerWithIdentifier:@"UpdateBirthdayViewController"];
            [self.navigationController pushViewController:birthdayVC animated:YES];
            birthdayVC.title = @"生日";
        }
            break;
        case 5:{//手机号
//            UpdatePhoneViewController *phoneVC =[self.storyboard instantiateViewControllerWithIdentifier:@"UpdatePhoneViewController"];
//            [self.navigationController pushViewController:phoneVC animated:YES];
//            phoneVC.title = @"手机号码";
        }
            break;
        default:
            break;
    }
}

#pragma mark - ActionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 2) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    // 1. 设置照片源，提示在模拟上不支持相机！
    if (buttonIndex == 0) {
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    // 2. 允许编辑
    [picker setAllowsEditing:YES];
    // 3. 设置代理

    dispatch_async(dispatch_get_main_queue(), ^{
        picker.delegate=self;
    });
    // 4. 显示照片选择控制器
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 照片选择代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    // 1. 设置头像
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 6.0;
        _headImageView.layer.borderWidth = 1.0;
        _headImageView.layer.borderColor = [[UIColor clearColor] CGColor];
        _headImageView.layer.contents = (id)[[info objectForKey:UIImagePickerControllerEditedImage] CGImage];
    });

    //存储在偏好设置里面的头像
    
    //2. 保存到服务器
    
    NSData *imgData =   UIImagePNGRepresentation(info[UIImagePickerControllerEditedImage]);
    [SYSTEM_USERDEFAULTS setObject:imgData forKey:Y_headPhoto];
    [SYSTEM_USERDEFAULTS synchronize];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
            [[MeHandle instance] uploadheadPhoto:imgData];
    });
    // 3. 关闭照片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
