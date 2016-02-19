//
//  TestTableViewCell.m
//  PinPin
//
//  Created by MoPellet on 15/8/10.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "TestTableViewCell.h"
#import "FSVoiceBubble.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+FSExtension.h"

#define titleHeight 14
#define fontHeight 16
#define smallTitleFontHeight 16
#define radioHeight fontHeight/2
#define choiceImageHeight 150
#define titleMargin SCREEN_WIDTH/4

//#define chooseMargin (SCREEN_WIDTH -  SCREEN_WIDTH/2.5)/2
//#define horizontalChooseMargin SCREEN_WIDTH/2.5/3

#define chooseMargin(y) (SCREEN_WIDTH -  SCREEN_WIDTH/y)/2
#define horizontalChooseMargin(y) SCREEN_WIDTH/y/3

#define chooseAudioSize  25
#define titleAudioSize  30
#define radioSize  22
#define titlePicSize SCREEN_WIDTH/2.5


@implementation TestTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = 0;
//    self.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = TEST_SMALLBACKGROUND_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)settingData:(QuestionBank *)questionBank  cellRow:(NSInteger )row{
    LibraryBank *libraryBank =questionBank.libraryBankArrays[row];
    //            NSLog(@"%@---%@----%@",questionBank.choiceShowType,questionBank.libraryDescription,questionBank.librarySetting);
    _groupId =[NSString stringWithFormat:@"%@_%@",questionBank.libraryTypeId,libraryBank.libraryBankId];
    //        [ShareAppDelegate.answerDictionary setObject:@"" forKey:_groupId];
    //    NSLog(@"%@",[questionBank chosenType]);
    switch ([questionBank.librarySetting intValue]) {
        case TestSetTypePic:
            [self showTestSetTypePic:questionBank cellRow:row];
            break;
        case TestSetTypePicVoice:
            [self showTestSetTypePicVoice:questionBank cellRow:row];
            break;
        case TestSetTypePicContent:
            [self showTestSetTypePicContent:questionBank cellRow:row];
            break;
        case TestSetTypeContent:
            [self showTestSetTypeContent:questionBank cellRow:row];
            break;
        case TestSetTypeContentVoice:
            [self showTestSetTypeContentVoice:questionBank cellRow:row];
            break;
        default:
            break;
    }
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TestTableViewCell";
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TestTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)playAudio:(AudioButton *)button
{
    NSURL *audioUrl = objc_getAssociatedObject(button, "audioUrl");
   
    if (ShareAppDelegate.audioPlayer == nil) {
        ShareAppDelegate.audioPlayer  = [[AudioPlayer alloc] init];
    }
    
    if ([ShareAppDelegate.audioPlayer .button isEqual:button]) {
        [ShareAppDelegate.audioPlayer  play];
    } else {
        [ShareAppDelegate.audioPlayer  stop];
        ShareAppDelegate.audioPlayer .button = button;
        ShareAppDelegate.audioPlayer .url = audioUrl;
        [ShareAppDelegate.audioPlayer  play];
    }
}

//-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
//
//    [ShareAppDelegate.answerDictionary setObject:[NSString stringWithFormat:@"%lu",(unsigned long)index] forKey:groupId];
//    NSLog(@"%@",ShareAppDelegate.answerDictionary);
//}

-(void)radioButtonSelectedAtIndex:(NSString *)index inGroup:(NSString *)groupId{
    
    [ShareAppDelegate.answerDictionary setObject:index forKey:groupId];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(UIImageView *)setTitleImage:(NSURL *)url  picImage:(UIImageView *)headImageView{
   
    CGFloat size = SCREEN_WIDTH/2.5;
    headImageView.frame = CGRectMake(titleMargin, titleHeight+10, size, size);
    [headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"videoDefault"]];
    [self setborderImage:headImageView];
    
    return headImageView;
}



-(void)setborderImage:(UIImageView *)ImageView{
    
    CALayer *layer = [ImageView layer];
    layer.borderColor =[[UIColor colorWithRed:212.0/255.0 green:213.0/255.0 blue:214.0/255.0 alpha:1.0] CGColor];
    layer.borderWidth = 1.0f;
}


#pragma mark -- show
-(void)showTestSetTypePic:(QuestionBank *)questionBank cellRow:(NSInteger )row{
    
    
    LibraryBank *libraryBank =questionBank.libraryBankArrays[row];
    
    _titleNum = [UILabel new];
    _titleNum.frame = CGRectMake(10, 0, 42, 24);
    _titleNum.text =[NSString stringWithFormat:@"%ld、",row+1];
    _titleNum.font = SystemFont(smallTitleFontHeight);
    [self addSubview: _titleNum];
    
    UIImageView *headImageView = [UIImageView new];
    NSString *urlStr  = [NSString stringWithFormat:@"%@%@",URL_QINIU,libraryBank.libraryBankPic];
    NSURL *url = [NSURL URLWithString:urlStr];
//    CGFloat size = SCREEN_WIDTH/3;
//    headImageView.frame = CGRectMake(titleMargin, titleHeight+10, size, size);
//    [headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"videoDefault"]];
    
    [self addSubview:[self setTitleImage:url picImage:headImageView]];
    
    
    NSDictionary *dictionary =[[ToolKit instance] dictionaryWithJsonString:libraryBank.libraryBankChoice];
    NSMutableArray  *array = [ ChoiceContent objectArrayWithKeyValuesArray: dictionary[@"choice"]];
    UIView *choiceView = [UIView new];
    CGFloat choiceY= 0.0;
    CGFloat lableHeight = 0.0;
    
    CGFloat trueChooseHeight= 0.0;
    
    
    int choiceForCount = (int)array.count+1;
    
    if (libraryBank.isTrue.length) {
        int status = [libraryBank.isTrue intValue] ;
        CGFloat  imageViewY = (24 -18)/2;
        CGFloat imageViewX = 10 + 24 +10;
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(imageViewX, imageViewY, 35, 18);
        NSString *imageName = status ?@"icon_Correct" :@"icon_mistake";
        imageView.image= [UIImage imageNamed:imageName];
        [self addSubview:imageView];
        if (![libraryBank.myChoose isEqualToString:@"-1"]) {
            NSMutableArray *array = [NSMutableArray new];
            for (int i = 0; i<libraryBank.myChoose.length; i++) {
                char c = [libraryBank.myChoose characterAtIndex:i];
                NSString * indexStr = [[ToolKit instance]  withIndex:[NSString stringWithFormat:@"%c",c]];
                [array addObject:indexStr];
            }
            NSString *str = [array componentsJoinedByString:@","];
            [ShareAppDelegate.answerDictionary setObject:str forKey:_groupId];
        }
        CGFloat size = SCREEN_WIDTH/(array.count + 1);
        CGFloat radioLeft = (size - 22)/2;
        if (!status) {
            if (libraryBank.libraryBankAnswers.length) {
                // 几种情况
                for (int i = 0; i<libraryBank.libraryBankAnswers.length; i++) {
                    char c = [libraryBank.libraryBankAnswers characterAtIndex:i];
                    int  index = [[[ToolKit instance]  withIndex:[NSString stringWithFormat:@"%c",c]] intValue];
                    UIImageView *chooseImageView = [[UIImageView alloc] init];
                    chooseImageView.image = [UIImage imageNamed:@"icon_Correct-option"];
                    if ([questionBank.choiceShowType intValue]==ChoiceVertical) {//
                        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
                            CGFloat imageY=0.0;
                            for (int i =0; i<array.count; i++) {
                                ChoiceContent *choiceContent = array[i];
                                NSString *string  =[NSString stringWithFormat:@"%@\n",
                                                    choiceContent.content];
                                UILabel *lable = [UILabel new];
                                // 用何種字體進行顯示
                                UIFont *font = [UIFont systemFontOfSize:fontHeight];
                                // 計算出顯示完內容需要的最小尺寸
//                                CGSize heightSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-72, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                                
                                CGSize heightSize= [string sizeForString:string font:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-72, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ];
                                
                                lable.frame = CGRectMake(62, imageY, SCREEN_WIDTH-72, heightSize.height);
                                UIView * view = [UIView new];
                                view.frame  = CGRectMake(10,imageY+radioHeight,22,22);
                                if (i==index) {
                                    chooseImageView.frame = CGRectMake(36,imageY,22,22);
                                    CGPoint center = view.center ;
                                    center.x = center.x + 11 +4 +11;
                                    chooseImageView.center =center;
                                }
                                imageY =  lable.frame.origin.y +lable.frame.size.height ;
                            }
                            
                            
                        }
                        else{
                            CGFloat size = titlePicSize; // chooseMargin
                            CGFloat chooseImageViewY =size*index +size/2 -11;
                            chooseImageView.frame = CGRectMake(10+22+10,chooseImageViewY,22,22);
                        }
                    }
                    else{
                        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
                            CGFloat singleWidth =   (SCREEN_WIDTH -10*2)/array.count;
                            CGFloat maginLeft = (singleWidth - 22)/2;
                            chooseImageView.frame = CGRectMake(10+maginLeft*(index+1)+index*22+maginLeft*index, 22+3+22,22,22);
                            trueChooseHeight = 25 ;
                        }
                        else{
                            CGFloat chooseImageViewX = horizontalChooseMargin(choiceForCount) + radioLeft +22*index +radioLeft*index +radioLeft*index +horizontalChooseMargin(choiceForCount)*index;
                            chooseImageView.frame = CGRectMake(chooseImageViewX,size + 25 ,22,22);
                            trueChooseHeight = 25 ;
                        }
                    }
                    [choiceView addSubview:chooseImageView];
                    
                }
            }
        }
        
    }

    if ([questionBank.choiceShowType intValue]==ChoiceVertical) {
        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
            for (int i =0; i<array.count; i++) {
                ChoiceContent *choiceContent = array[i];
                
                UILabel *lable = [UILabel new];
                NSString *string  =[NSString stringWithFormat:@"%@\n",
                                    choiceContent.content];
                [lable setText:string];
                
                // 用何種字體進行顯示
                UIFont *font = [UIFont systemFontOfSize:fontHeight];
                // 計算出顯示完內容需要的最小尺寸
//                CGSize heightSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-72, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                
                CGSize heightSize= [string sizeForString:string font:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-72, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ];
                
                
                lableHeight = heightSize.height;
                [lable setTextAlignment:NSTextAlignmentCenter];
                lable.font =  [UIFont systemFontOfSize: fontHeight];
                lable.numberOfLines = 0;
                NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:string];
                NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle1 setLineSpacing:2];
                [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
                [lable setAttributedText:attributedString1];
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                chooiceButton.frame = CGRectMake(10,choiceY+radioHeight,22,22);
                lable.frame = CGRectMake(62, choiceY, SCREEN_WIDTH-72, heightSize.height);
                choiceY =  lable.frame.origin.y +lable.frame.size.height;
                [choiceView addSubview:lable];
                [choiceView addSubview:chooiceButton];
//                if ( [ShareAppDelegate.answerDictionary objectForKey:_groupId] !=nil &&  [[ShareAppDelegate.answerDictionary objectForKey:_groupId] intValue]==i) {
//                    [chooiceButton setChecked:YES];
//                }
                [self setCheckedWithGroupId:_groupId withIndex:i WithCButton:chooiceButton];
                
            }
        }
        else{
            for (int i =0; i<array.count; i++) {
                ChoiceContent  *choiceContent = array[i];
                NSArray * urlArray = [choiceContent.content componentsSeparatedByString:@"-"];
                NSString *phoytoID = [urlArray firstObject];//图片
                NSString *voiceID = [urlArray lastObject];//声音
                NSString *urlStr  = [NSString stringWithFormat:@"%@%@",URL_QINIU,phoytoID];
                NSURL *url = [NSURL URLWithString:urlStr];
                
                UIImageView *choiceImageView = [UIImageView new];
                CGFloat size = SCREEN_WIDTH/(choiceForCount);
                choiceImageView .frame = CGRectMake(chooseMargin(choiceForCount), choiceY, size, size);
                [choiceImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"videoDefault"] ];
                [self setborderImage:choiceImageView];
                [choiceView addSubview:choiceImageView];
                
                if(![phoytoID isEqualToString:voiceID]){
                    AudioButton *choiceAudioButton = [[AudioButton alloc] initWithFrame: CGRectMake(chooseMargin(choiceForCount)+choiceImageView.image.size.width, choiceY, chooseAudioSize, chooseAudioSize)];
                    [choiceView addSubview:choiceAudioButton];
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_QINIU,voiceID]];
                    [choiceAudioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
                    objc_setAssociatedObject(choiceAudioButton, "audioUrl", url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    [choiceView addSubview:choiceAudioButton];
                }
                
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                CGFloat chooiceButtonY =(choiceImageView.frame.origin.y) +(choiceImageView.frame.size.height/2)-11;
                chooiceButton.frame = CGRectMake(10,chooiceButtonY,22,22);
                [choiceView addSubview:chooiceButton];
//                if ( [ShareAppDelegate.answerDictionary objectForKey:_groupId] !=nil &&  [[ShareAppDelegate.answerDictionary objectForKey:_groupId] intValue]==i&&[[ShareAppDelegate.answerDictionary objectForKey:_groupId] intValue] !=100) {
//                    [chooiceButton setChecked:YES];
//                }
                [self setCheckedWithGroupId:_groupId withIndex:i WithCButton:chooiceButton];
                
                choiceY =  choiceImageView.frame.origin.y +choiceImageView.frame.size.height+3;
            }        }
    }
    else{
        CGFloat singleWidth =   (SCREEN_WIDTH -10*2)/array.count;
        CGFloat maginLeft = (singleWidth - 22)/2;
        
        NSMutableArray *checkedArray   = [NSMutableArray new];
        if ([ShareAppDelegate.answerDictionary objectForKey:_groupId] ) {
            NSString * str = [ ShareAppDelegate.answerDictionary objectForKey:_groupId] ;
            checkedArray = [[ToolKit instance] arrayWithString:str];
        }
        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
            choiceY =20 +22;
            for (int i =0; i<array.count; i++) {
                ChoiceContent *choiceContent = array[i];
                UILabel *lable = [UILabel new];
                NSString *string  =[NSString stringWithFormat:@"%@\n",choiceContent.content];
                [lable setText:string];
                lable.textAlignment = NSTextAlignmentCenter;
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                lable.frame = CGRectMake(10+singleWidth*i, 0, singleWidth, 20);
                chooiceButton.frame = CGRectMake(10+maginLeft*(i+1)+i*22+maginLeft*i, lable.frame.origin.y+lable.frame.size.height,22,22);
                
                [choiceView addSubview:lable];
                [choiceView addSubview:chooiceButton];
                
                
                if(checkedArray.count){
                    NSString *indexStr = [NSString stringWithFormat:@"%d",i];
                    for (int n=0;n<checkedArray.count;n++) {
                        NSString *temp = [checkedArray objectAtIndex:n];
                        if ([indexStr isEqualToString:temp]) {
                            [chooiceButton setChecked:YES];
                            break;
                        }
                    }
                }
                
                
            }
        }
        else{
            for (int i =0; i<array.count; i++) {
                ChoiceContent  *choiceContent = array[i];
                NSArray * urlArray = [choiceContent.content componentsSeparatedByString:@"-"];
                NSString *phoytoID = [urlArray firstObject];//图片
                NSString *voiceID = [urlArray lastObject];//声音
                NSString *urlStr  = [NSString stringWithFormat:@"%@%@",URL_QINIU,phoytoID];
                NSURL *url = [NSURL URLWithString:urlStr];
                
                UIImageView *choiceImageView = [UIImageView new];
                
                
                CGFloat size = SCREEN_WIDTH/(choiceForCount);
                CGFloat radioLeft = (size - 22)/2;
                
                choiceImageView .frame = CGRectMake(horizontalChooseMargin(choiceForCount) +size *i +i*horizontalChooseMargin(choiceForCount) , 0, size, size);
                [choiceImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"videoDefault"] ];
                 [self setborderImage:choiceImageView];
                [choiceView addSubview:choiceImageView];
                
                if(![phoytoID isEqualToString:voiceID]){
                    AudioButton *choiceAudioButton = [[AudioButton alloc] initWithFrame: CGRectMake(choiceImageView .frame.origin.x+size-chooseAudioSize, 0, chooseAudioSize, chooseAudioSize)];
                    [choiceView addSubview:choiceAudioButton];
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_QINIU,voiceID]];
                    [choiceAudioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
                    objc_setAssociatedObject(choiceAudioButton, "audioUrl", url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    [choiceView addSubview:choiceAudioButton];
                }
                
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                CGFloat chooiceButtonX = horizontalChooseMargin(choiceForCount) + radioLeft +22*i +radioLeft*i +radioLeft*i +horizontalChooseMargin(choiceForCount)*i;
                chooiceButton.frame = CGRectMake(chooiceButtonX, size,22,22);
                [choiceView addSubview:chooiceButton];
//                if ( [ShareAppDelegate.answerDictionary objectForKey:_groupId] !=nil &&  [[ShareAppDelegate.answerDictionary objectForKey:_groupId] intValue]==i) {
//                    [chooiceButton setChecked:YES];
//                }
                [self setCheckedWithGroupId:_groupId withIndex:i WithCButton:chooiceButton];
                
                choiceY =  choiceImageView.frame.origin.y +choiceImageView.frame.size.height+3;
            }
        }
    }
    
    
    //    [RadioButton addObserverForGroupId:_groupId observer:self];
    [RadioButton addObserverForGroupId:_groupId observer:self chosenType:[questionBank chosenType]];
    choiceView.frame = CGRectMake(0, headImageView.frame.origin.y+ headImageView.bounds.size.height+15, SCREEN_WIDTH, choiceY +trueChooseHeight +10);
    [self addSubview:choiceView];
    CGRect cellFrame = [self frame];
    cellFrame.size.height = choiceView.frame.origin.y+  choiceView.bounds.size.height;
    self.frame = cellFrame;
}

-(void)showTestSetTypePicVoice:(QuestionBank *)questionBank cellRow:(NSInteger )row{
    LibraryBank *libraryBank =questionBank.libraryBankArrays[row];
    
    _titleNum = [UILabel new];
    _titleNum.frame = CGRectMake(10, 0, 42, 24);
    _titleNum.text =[NSString stringWithFormat:@"%ld、",row+1];
    _titleNum.font = SystemFont(smallTitleFontHeight);
    [self addSubview: _titleNum];
    
    UIImageView *headImageView = [UIImageView new];
    NSString *urlStr  = [NSString stringWithFormat:@"%@%@",URL_QINIU,libraryBank.libraryBankPic];
    NSURL *url = [NSURL URLWithString:urlStr];
//    CGFloat size = SCREEN_WIDTH/2;
//    headImageView.frame = CGRectMake(titleMargin, titleHeight+10, size, size);
//    [headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"videoDefault"]];
//    [self addSubview:headImageView];
    [self addSubview:[self setTitleImage:url picImage:headImageView]];
    
    self.audioButton = [[AudioButton alloc] initWithFrame: CGRectMake(SCREEN_WIDTH-70, titleHeight+10, titleAudioSize, titleAudioSize)];
    [self addSubview:self.audioButton];
    self.audioButton.tag =(long)libraryBank.libraryBankVoice;
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_QINIU,libraryBank.libraryBankVoice]];
    [self.audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(self.audioButton, "audioUrl", url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSDictionary *dictionary =[[ToolKit instance] dictionaryWithJsonString:libraryBank.libraryBankChoice];
    NSMutableArray  *array = [ ChoiceContent objectArrayWithKeyValuesArray: dictionary[@"choice"]];
    UIView *choiceView = [UIView new];
    CGFloat choiceY= 0.0;
    CGFloat lableHeight = 0.0;
    
    CGFloat trueChooseHeight= 0.0;

    int choiceForCount = (int)array.count+1;
    if (libraryBank.isTrue.length) {
        int status = [libraryBank.isTrue intValue] ;
        CGFloat  imageViewY = (24 -18)/2;
        CGFloat imageViewX = 10 + 24 +10;
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(imageViewX, imageViewY, 35, 18);
        NSString *imageName = status ?@"icon_Correct" :@"icon_mistake";
        imageView.image= [UIImage imageNamed:imageName];
        [self addSubview:imageView];
        if (![libraryBank.myChoose isEqualToString:@"-1"]) {
            NSMutableArray *array = [NSMutableArray new];
            for (int i = 0; i<libraryBank.myChoose.length; i++) {
                char c = [libraryBank.myChoose characterAtIndex:i];
                NSString * indexStr = [[ToolKit instance]  withIndex:[NSString stringWithFormat:@"%c",c]];
                [array addObject:indexStr];
            }
            NSString *str = [array componentsJoinedByString:@","];
            [ShareAppDelegate.answerDictionary setObject:str forKey:_groupId];
        }
        CGFloat size = SCREEN_WIDTH/(array.count + 1);
        CGFloat radioLeft = (size - 22)/2;
        if (!status) {
            if (libraryBank.libraryBankAnswers.length) {
                // 几种情况
                for (int i = 0; i<libraryBank.libraryBankAnswers.length; i++) {
                    char c = [libraryBank.libraryBankAnswers characterAtIndex:i];
                    int  index = [[[ToolKit instance]  withIndex:[NSString stringWithFormat:@"%c",c]] intValue];
                    UIImageView *chooseImageView = [[UIImageView alloc] init];
                                   chooseImageView.image = [UIImage imageNamed:@"icon_Correct-option"];
                    if ([questionBank.choiceShowType intValue]==ChoiceVertical) {//
                        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
                            CGFloat imageY=0.0;
                            for (int i =0; i<array.count; i++) {
                                ChoiceContent *choiceContent = array[i];
                            NSString *string  =[NSString stringWithFormat:@"%@\n",
                                                choiceContent.content];
                                  UILabel *lable = [UILabel new];
                            // 用何種字體進行顯示
                            UIFont *font = [UIFont systemFontOfSize:fontHeight];
                            // 計算出顯示完內容需要的最小尺寸
//                            CGSize heightSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-76, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                                
                                CGSize heightSize= [string sizeForString:string font:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-76, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ];
                                
                                
                                lable.frame = CGRectMake(62, imageY, SCREEN_WIDTH-72, heightSize.height);
                                UIView * view = [UIView new];
                                view.frame  = CGRectMake(10,imageY+radioHeight,22,22);
                                if (i==index) {
                                      chooseImageView.frame = CGRectMake(36,imageY,22,22);
                                    CGPoint center = view.center ;
                                    center.x = center.x + 11 +4 +11;
                                    chooseImageView.center =center;
                                }
                                imageY =  lable.frame.origin.y +lable.frame.size.height ;
                            }
                            
                        }else{
                            CGFloat size = SCREEN_WIDTH/(choiceForCount); // chooseMargin
                            CGFloat chooseImageViewY =size*index +size/2 -9;
                            chooseImageView.frame = CGRectMake(10+22+6,chooseImageViewY,22,22);
                        }
                    }
                    else{
                        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
                            CGFloat singleWidth =   (SCREEN_WIDTH -10*2)/array.count;
                            CGFloat maginLeft = (singleWidth - 22)/2;
                            chooseImageView.frame = CGRectMake(10+maginLeft*(index+1)+index*22+maginLeft*index, 22+3+22,22,22);
                               trueChooseHeight = 25 ;
                        }
                        else{
//                            CGFloat chooseImageViewX = horizontalChooseMargin + radioLeft +22*index +radioLeft*index +radioLeft*index +horizontalChooseMargin*index;
                            CGFloat chooseImageViewX = SCREEN_WIDTH/(choiceForCount)/3 + radioLeft +22*index +radioLeft*index +radioLeft*index +(SCREEN_WIDTH/(choiceForCount)/3)*index;
                            
                            
                            chooseImageView.frame = CGRectMake(chooseImageViewX,SCREEN_WIDTH/(choiceForCount) + 25 ,22,22);
                            trueChooseHeight = 25 ;
                        }
                    }
                    [choiceView addSubview:chooseImageView];
                    
                }
            }
        }
        
    }
    
    
    if ([questionBank.choiceShowType intValue]==ChoiceVertical) {
        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
            for (int i =0; i<array.count; i++) {
                ChoiceContent *choiceContent = array[i];
                
                UILabel *lable = [UILabel new];
                NSString *string  =[NSString stringWithFormat:@"%@\n",
                                    choiceContent.content];
                [lable setText:string];
                
                // 用何種字體進行顯示
                UIFont *font = [UIFont systemFontOfSize:fontHeight];
                // 計算出顯示完內容需要的最小尺寸
//                CGSize heightSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-72, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                CGSize heightSize= [string sizeForString:string font:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-72, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ];
                
                
                lableHeight = heightSize.height;
                [lable setTextAlignment:NSTextAlignmentCenter];
                lable.font =  [UIFont systemFontOfSize: fontHeight];
                lable.numberOfLines = 0;
                NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:string];
                NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle1 setLineSpacing:2];
                [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
                [lable setAttributedText:attributedString1];
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                chooiceButton.frame = CGRectMake(10,choiceY+radioHeight,22,22);
                lable.frame = CGRectMake(62, choiceY, SCREEN_WIDTH-72, heightSize.height);
                choiceY =  lable.frame.origin.y +lable.frame.size.height;
                [choiceView addSubview:lable];
                [choiceView addSubview:chooiceButton];
//                if ( [ShareAppDelegate.answerDictionary objectForKey:_groupId] !=nil &&  [[ShareAppDelegate.answerDictionary objectForKey:_groupId] intValue]==i) {
//                    [chooiceButton setChecked:YES];
//                }
                
                [self setCheckedWithGroupId:_groupId withIndex:i WithCButton:chooiceButton];
                
                
            }
        }
        else{
            for (int i =0; i<array.count; i++) {
                ChoiceContent  *choiceContent = array[i];
                NSArray * urlArray = [choiceContent.content componentsSeparatedByString:@"-"];
                NSString *phoytoID = [urlArray firstObject];//图片
                NSString *voiceID = [urlArray lastObject];//声音
                NSString *urlStr  = [NSString stringWithFormat:@"%@%@",URL_QINIU,phoytoID];
                NSURL *url = [NSURL URLWithString:urlStr];
                
                UIImageView *choiceImageView = [UIImageView new];
                CGFloat size = SCREEN_WIDTH/(choiceForCount);
                choiceImageView .frame = CGRectMake((SCREEN_WIDTH -  SCREEN_WIDTH/(choiceForCount))/2, choiceY, size, size);
                [choiceImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"videoDefault"] ];
                 [self setborderImage:choiceImageView];
                [choiceView addSubview:choiceImageView];
                
                
                if(![phoytoID isEqualToString:voiceID]){
                    AudioButton *choiceAudioButton = [[AudioButton alloc] initWithFrame: CGRectMake(chooseMargin(choiceForCount)+choiceImageView.image.size.width, choiceY, chooseAudioSize, chooseAudioSize)];
                    [choiceView addSubview:choiceAudioButton];
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_QINIU,voiceID]];
                    [choiceAudioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
                    objc_setAssociatedObject(choiceAudioButton, "audioUrl", url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    [choiceView addSubview:choiceAudioButton];
                }
                
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                CGFloat chooiceButtonY =(choiceImageView.frame.origin.y) +(choiceImageView.frame.size.height/2)-11;
                chooiceButton.frame = CGRectMake(10,chooiceButtonY,22,22);
                [choiceView addSubview:chooiceButton];
//                if ( [ShareAppDelegate.answerDictionary objectForKey:_groupId] !=nil &&  [[ShareAppDelegate.answerDictionary objectForKey:_groupId] intValue]==i) {
//                    [chooiceButton setChecked:YES];
//                }
                [self setCheckedWithGroupId:_groupId withIndex:i WithCButton:chooiceButton];
                
                choiceY =  choiceImageView.frame.origin.y +choiceImageView.frame.size.height+3;
            }        }
    }
    else{
        CGFloat singleWidth =   (SCREEN_WIDTH -10*2)/array.count;
        CGFloat maginLeft = (singleWidth - 22)/2;
        
        NSMutableArray *checkedArray   = [NSMutableArray new];
        if ([ShareAppDelegate.answerDictionary objectForKey:_groupId] ) {
            NSString * str = [ ShareAppDelegate.answerDictionary objectForKey:_groupId] ;
            checkedArray = [[ToolKit instance] arrayWithString:str];
        }
        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
            choiceY =20 +22;
            for (int i =0; i<array.count; i++) {
                ChoiceContent *choiceContent = array[i];
                UILabel *lable = [UILabel new];
                NSString *string  =[NSString stringWithFormat:@"%@\n",choiceContent.content];
                [lable setText:string];
                lable.textAlignment = NSTextAlignmentCenter;
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                lable.frame = CGRectMake(10+singleWidth*i, 0, singleWidth, 20);
                chooiceButton.frame = CGRectMake(10+maginLeft*(i+1)+i*22+maginLeft*i, lable.frame.origin.y+lable.frame.size.height,22,22);
                
                [choiceView addSubview:lable];
                [choiceView addSubview:chooiceButton];
                
                
                if(checkedArray.count){
                    NSString *indexStr = [NSString stringWithFormat:@"%d",i];
                    for (int n=0;n<checkedArray.count;n++) {
                        NSString *temp = [checkedArray objectAtIndex:n];
                        if ([indexStr isEqualToString:temp]) {
                            [chooiceButton setChecked:YES];
                            break;
                        }
                    }
                }
                
                
            }
        }
        else{
            for (int i =0; i<array.count; i++) {
                ChoiceContent  *choiceContent = array[i];
                NSArray * urlArray = [choiceContent.content componentsSeparatedByString:@"-"];
                NSString *phoytoID = [urlArray firstObject];//图片
                NSString *voiceID = [urlArray lastObject];//声音
                NSString *urlStr  = [NSString stringWithFormat:@"%@%@",URL_QINIU,phoytoID];
                NSURL *url = [NSURL URLWithString:urlStr];
                
                UIImageView *choiceImageView = [UIImageView new];
                CGFloat size = SCREEN_WIDTH/(choiceForCount);
                CGFloat radioLeft = (size - 22)/2;
               
                choiceImageView .frame = CGRectMake(horizontalChooseMargin(choiceForCount) +size *i +i*horizontalChooseMargin(choiceForCount) , 0, size, size);
                [choiceImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"videoDefault"] ];
                 [self setborderImage:choiceImageView];
                [choiceView addSubview:choiceImageView];
                
                if(![phoytoID isEqualToString:voiceID]){
                    AudioButton *choiceAudioButton = [[AudioButton alloc] initWithFrame: CGRectMake(choiceImageView .frame.origin.x+size-chooseAudioSize, 0, chooseAudioSize, chooseAudioSize)];
                    [choiceView addSubview:choiceAudioButton];
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_QINIU,voiceID]];
                    [choiceAudioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
                    objc_setAssociatedObject(choiceAudioButton, "audioUrl", url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    [choiceView addSubview:choiceAudioButton];
                }
                
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
//                CGFloat chooiceButtonX = horizontalChooseMargin(array.count+1) + radioLeft +22*i +radioLeft*i +radioLeft*i +horizontalChooseMargin(array.count+1)*i;
                
                 CGFloat chooiceButtonX =SCREEN_WIDTH/(choiceForCount)/3 + radioLeft +22*i +radioLeft*i +radioLeft*i +SCREEN_WIDTH/(choiceForCount)/3*i;
                
                
                chooiceButton.frame = CGRectMake(chooiceButtonX, size,22,22);
                [choiceView addSubview:chooiceButton];
                
                
                
                
//                if ( [ShareAppDelegate.answerDictionary objectForKey:_groupId] !=nil &&  [[ShareAppDelegate.answerDictionary objectForKey:_groupId] intValue]==i) {
//                    [chooiceButton setChecked:YES];
//                }
                [self setCheckedWithGroupId:_groupId withIndex:i WithCButton:chooiceButton];
                
                choiceY =  choiceImageView.frame.origin.y +choiceImageView.frame.size.height+3+22;
            }
        }
    }
    
    
    //    NSLog(@"%@",questionBank.chosenType);
    [RadioButton addObserverForGroupId:_groupId observer:self chosenType:[questionBank chosenType]];
    choiceView.frame = CGRectMake(0, headImageView.frame.origin.y+ headImageView.bounds.size.height+15, SCREEN_WIDTH, choiceY +trueChooseHeight +10);
    [self addSubview:choiceView];
    CGRect cellFrame = [self frame];
    cellFrame.size.height = choiceView.frame.origin.y+  choiceView.bounds.size.height;
    self.frame = cellFrame;
    
}

-(void)showTestSetTypePicContent:(QuestionBank *)questionBank  cellRow:(NSInteger )row{
    LibraryBank *libraryBank =questionBank.libraryBankArrays[row];
    _titleNum = [UILabel new];
    
    
    NSString *string = [NSString stringWithFormat:@"%ld、%@\n",row+1,libraryBank.libraryBankContent];
    [_titleNum setText:string];
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:smallTitleFontHeight];
    // 計算出顯示完內容需要的最小尺寸
//    CGSize heightSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize heightSize= [string sizeForString:string font:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ];
    
    
    _titleNum.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, heightSize.height+4);
    [_titleNum setTextAlignment:NSTextAlignmentCenter];
    _titleNum.font =  [UIFont boldSystemFontOfSize: smallTitleFontHeight];
    _titleNum.numberOfLines = 0;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:2];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
    [_titleNum setAttributedText:attributedString1];
    
    [self addSubview: _titleNum];
    
    UIImageView *headImageView = [UIImageView new];
    NSString *urlStr  = [NSString stringWithFormat:@"%@%@",URL_QINIU,libraryBank.libraryBankPic];
    NSURL *url = [NSURL URLWithString:urlStr];;
//    CGFloat size = SCREEN_WIDTH/2;
//    headImageView.frame = CGRectMake(titleMargin, titleHeight+10, size, size);
//    [headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"videoDefault"]];
//    [self addSubview:headImageView];
    [self addSubview:[self setTitleImage:url picImage:headImageView]];
    
    NSDictionary *dictionary =[[ToolKit instance] dictionaryWithJsonString:libraryBank.libraryBankChoice];
    NSMutableArray  *array = [ ChoiceContent objectArrayWithKeyValuesArray: dictionary[@"choice"]];
    UIView *choiceView = [UIView new];
    CGFloat choiceY = 0.0 ;
    CGFloat lableHeight = 0.0;
    
    CGFloat trueChooseHeight= 0.0;
    
    int choiceForCount = (int)array.count+1;
    if (libraryBank.isTrue.length) {
        int status = [libraryBank.isTrue intValue] ;
        CGFloat  imageViewY = (24 -18)/2;
//        CGFloat imageViewX = 10 + 24 +10;
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(SCREEN_WIDTH -10 -35, imageViewY, 35, 18);
        NSString *imageName = status ?@"icon_Correct" :@"icon_mistake";
        imageView.image= [UIImage imageNamed:imageName];
        [self addSubview:imageView];
        if (![libraryBank.myChoose isEqualToString:@"-1"]) {
            NSMutableArray *array = [NSMutableArray new];
            for (int i = 0; i<libraryBank.myChoose.length; i++) {
                char c = [libraryBank.myChoose characterAtIndex:i];
                NSString * indexStr = [[ToolKit instance]  withIndex:[NSString stringWithFormat:@"%c",c]];
                [array addObject:indexStr];
            }
            NSString *str = [array componentsJoinedByString:@","];
            [ShareAppDelegate.answerDictionary setObject:str forKey:_groupId];
        }
        CGFloat size = SCREEN_WIDTH/(array.count + 1);
        CGFloat radioLeft = (size - 22)/2;
        if (!status) {
            if (libraryBank.libraryBankAnswers.length) {
                // 几种情况
                for (int i = 0; i<libraryBank.libraryBankAnswers.length; i++) {
                    char c = [libraryBank.libraryBankAnswers characterAtIndex:i];
                    int  index = [[[ToolKit instance]  withIndex:[NSString stringWithFormat:@"%c",c]] intValue];
                    UIImageView *chooseImageView = [[UIImageView alloc] init];
                    chooseImageView.image = [UIImage imageNamed:@"icon_Correct-option"];
                    if ([questionBank.choiceShowType intValue]==ChoiceVertical) {//
                        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
                            CGFloat imageY=0.0;
                            for (int i =0; i<array.count; i++) {
                                ChoiceContent *choiceContent = array[i];
                                NSString *string  =[NSString stringWithFormat:@"%@\n",
                                                    choiceContent.content];
                                UILabel *lable = [UILabel new];
                                // 用何種字體進行顯示
                                UIFont *font = [UIFont systemFontOfSize:fontHeight];
                                // 計算出顯示完內容需要的最小尺寸
//                                CGSize heightSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-46, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                                
                                CGSize heightSize= [string sizeForString:string font:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-46, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ];
                                
                                
                                lable.frame = CGRectMake(36, imageY, SCREEN_WIDTH-46, heightSize.height);
                                UIView * view = [UIView new];
                                view.frame  = CGRectMake(10,imageY+radioHeight,22,22);
                                if (i==index) {
                                    chooseImageView.frame = CGRectMake(36,imageY,22,22);
                                    CGPoint center = view.center ;
                                    center.x = center.x + 11 +4 +11;
                                    chooseImageView.center =center;
                                }
                                imageY =  lable.frame.origin.y +lable.frame.size.height ;
                            }
                            
                            
                        }
                        else{
                            CGFloat size = titlePicSize; // chooseMargin
                            CGFloat chooseImageViewY =size*index +size/2 -11;
                            chooseImageView.frame = CGRectMake(10+22+10,chooseImageViewY,22,22);
                        }
                    }
                    else{
                        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
                            CGFloat singleWidth =   (SCREEN_WIDTH -10*2)/array.count;
                            CGFloat maginLeft = (singleWidth - 22)/2;
                            chooseImageView.frame = CGRectMake(10+maginLeft*(index+1)+index*22+maginLeft*index, 22+3+22,22,22);
                            trueChooseHeight = 25 ;
                        }
                        else{
                            CGFloat chooseImageViewX = horizontalChooseMargin(choiceForCount) + radioLeft +22*index +radioLeft*index +radioLeft*index +horizontalChooseMargin(choiceForCount)*index;
                            chooseImageView.frame = CGRectMake(chooseImageViewX,size + 25 ,22,22);
                            trueChooseHeight = 25 ;
                        }
                    }
                    [choiceView addSubview:chooseImageView];
                    
                }
            }
        }
        
    }

    
    if ([questionBank.choiceShowType intValue]==ChoiceVertical) {
        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
            for (int i =0; i<array.count; i++) {
                ChoiceContent *choiceContent = array[i];
                
                UILabel *lable = [UILabel new];
                NSString *string  =[NSString stringWithFormat:@"%@\n",
                                    choiceContent.content];
                [lable setText:string];
                
                // 用何種字體進行顯示
                UIFont *font = [UIFont systemFontOfSize:fontHeight];
                // 計算出顯示完內容需要的最小尺寸
//                CGSize heightSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-72, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                
                CGSize heightSize= [string sizeForString:string font:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-72, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ];
                
                
                lableHeight = heightSize.height;
                [lable setTextAlignment:NSTextAlignmentCenter];
                lable.font =  [UIFont systemFontOfSize: fontHeight];
                lable.numberOfLines = 0;
                NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:string];
                NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle1 setLineSpacing:2];
                [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
                [lable setAttributedText:attributedString1];
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                chooiceButton.frame = CGRectMake(10,choiceY+radioHeight,22,22);
                lable.frame = CGRectMake(62, choiceY, SCREEN_WIDTH-72, heightSize.height);
                choiceY =  lable.frame.origin.y +lable.frame.size.height;
                [choiceView addSubview:lable];
                [choiceView addSubview:chooiceButton];
//                if ( [ShareAppDelegate.answerDictionary objectForKey:_groupId] !=nil &&  [[ShareAppDelegate.answerDictionary objectForKey:_groupId] intValue]==i) {
//                    [chooiceButton setChecked:YES];
//                }
                [self setCheckedWithGroupId:_groupId withIndex:i WithCButton:chooiceButton];
                
            }
        }
        else{
            for (int i =0; i<array.count; i++) {
                ChoiceContent  *choiceContent = array[i];
                NSArray * urlArray = [choiceContent.content componentsSeparatedByString:@"-"];
                NSString *phoytoID = [urlArray firstObject];//图片
                NSString *voiceID = [urlArray lastObject];//声音
                NSString *urlStr  = [NSString stringWithFormat:@"%@%@",URL_QINIU,phoytoID];
                NSURL *url = [NSURL URLWithString:urlStr];
                
                UIImageView *choiceImageView = [UIImageView new];
                CGFloat size = SCREEN_WIDTH /(choiceForCount);
                choiceImageView .frame = CGRectMake(chooseMargin(choiceForCount), choiceY, size, size);
                [choiceImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"videoDefault"] ];
                 [self setborderImage:choiceImageView];
                [choiceView addSubview:choiceImageView];
                if(![phoytoID isEqualToString:voiceID]){
                    AudioButton *choiceAudioButton = [[AudioButton alloc] initWithFrame: CGRectMake(chooseMargin(choiceForCount)+choiceImageView.image.size.width, choiceY, chooseAudioSize, chooseAudioSize)];
                    [choiceView addSubview:choiceAudioButton];
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_QINIU,voiceID]];
                    [choiceAudioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
                    objc_setAssociatedObject(choiceAudioButton, "audioUrl", url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    [choiceView addSubview:choiceAudioButton];
                }
                
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                CGFloat chooiceButtonY =(choiceImageView.frame.origin.y) +(choiceImageView.frame.size.height/2)-11;
                chooiceButton.frame = CGRectMake(10,chooiceButtonY,22,22);
                [choiceView addSubview:chooiceButton];
//                if ( [ShareAppDelegate.answerDictionary objectForKey:_groupId] !=nil &&  [[ShareAppDelegate.answerDictionary objectForKey:_groupId] intValue]==i) {
//                    [chooiceButton setChecked:YES];
//                }
                [self setCheckedWithGroupId:_groupId withIndex:i WithCButton:chooiceButton];
                
                choiceY =  choiceImageView.frame.origin.y +choiceImageView.frame.size.height+3;
            }
        }
    }
    else{
        CGFloat singleWidth =   (SCREEN_WIDTH -10*2)/array.count;
        CGFloat maginLeft = (singleWidth - 22)/2;
        
        NSMutableArray *checkedArray   = [NSMutableArray new];
        if ([ShareAppDelegate.answerDictionary objectForKey:_groupId] ) {
            NSString * str = [ ShareAppDelegate.answerDictionary objectForKey:_groupId] ;
            checkedArray = [[ToolKit instance] arrayWithString:str];
        }
        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
            choiceY =20 +22;
            for (int i =0; i<array.count; i++) {
                ChoiceContent *choiceContent = array[i];
                UILabel *lable = [UILabel new];
                NSString *string  =[NSString stringWithFormat:@"%@\n",choiceContent.content];
                [lable setText:string];
                lable.textAlignment = NSTextAlignmentCenter;
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                lable.frame = CGRectMake(10+singleWidth*i, 0, singleWidth, 20);
                chooiceButton.frame = CGRectMake(10+maginLeft*(i+1)+i*22+maginLeft*i, lable.frame.origin.y+lable.frame.size.height,22,22);
                
                [choiceView addSubview:lable];
                [choiceView addSubview:chooiceButton];
                
                
                if(checkedArray.count){
                    NSString *indexStr = [NSString stringWithFormat:@"%d",i];
                    for (int n=0;n<checkedArray.count;n++) {
                        NSString *temp = [checkedArray objectAtIndex:n];
                        if ([indexStr isEqualToString:temp]) {
                            [chooiceButton setChecked:YES];
                            break;
                        }
                    }
                }
                
                
            }
        }
        else{
            for (int i =0; i<array.count; i++) {
                ChoiceContent  *choiceContent = array[i];
                NSArray * urlArray = [choiceContent.content componentsSeparatedByString:@"-"];
                NSString *phoytoID = [urlArray firstObject];//图片
                NSString *voiceID = [urlArray lastObject];//声音
                NSString *urlStr  = [NSString stringWithFormat:@"%@%@",URL_QINIU,phoytoID];
                NSURL *url = [NSURL URLWithString:urlStr];
                
                UIImageView *choiceImageView = [UIImageView new];
                
                CGFloat size = SCREEN_WIDTH/(choiceForCount);
                CGFloat radioLeft = (size - 22)/2;
                
                choiceImageView .frame = CGRectMake(horizontalChooseMargin(choiceForCount) +size *i +i*horizontalChooseMargin(choiceForCount) , 0, size, size);
                [choiceImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"videoDefault"] ];
                 [self setborderImage:choiceImageView];
                [choiceView addSubview:choiceImageView];
                
                if(![phoytoID isEqualToString:voiceID]){
                    AudioButton *choiceAudioButton = [[AudioButton alloc] initWithFrame: CGRectMake(choiceImageView .frame.origin.x+size-chooseAudioSize, 0, chooseAudioSize, chooseAudioSize)];
                    [choiceView addSubview:choiceAudioButton];
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_QINIU,voiceID]];
                    [choiceAudioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
                    objc_setAssociatedObject(choiceAudioButton, "audioUrl", url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    [choiceView addSubview:choiceAudioButton];
                }
                
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                CGFloat chooiceButtonX = horizontalChooseMargin(choiceForCount) + radioLeft +22*i +radioLeft*i +radioLeft*i +horizontalChooseMargin(choiceForCount)*i;
                chooiceButton.frame = CGRectMake(chooiceButtonX, size,22,22);
                [choiceView addSubview:chooiceButton];
//                if ( [ShareAppDelegate.answerDictionary objectForKey:_groupId] !=nil &&  [[ShareAppDelegate.answerDictionary objectForKey:_groupId] intValue]==i) {
//                    [chooiceButton setChecked:YES];
//                }
                [self setCheckedWithGroupId:_groupId withIndex:i WithCButton:chooiceButton];
                
                choiceY =  choiceImageView.frame.origin.y +choiceImageView.frame.size.height+3;
            }
        }
    }
    //    [RadioButton addObserverForGroupId:_groupId observer:self];
    [RadioButton addObserverForGroupId:_groupId observer:self chosenType:[questionBank chosenType]];
    choiceView.frame = CGRectMake(0, headImageView.frame.origin.y+ headImageView.bounds.size.height + 15, SCREEN_WIDTH, choiceY+trueChooseHeight +10);
    [self addSubview:choiceView];
    CGRect cellFrame = [self frame];
    cellFrame.size.height = choiceView.frame.origin.y+  choiceView.bounds.size.height;
    self.frame = cellFrame;
    
    
    
}

-(void)showTestSetTypeContent:(QuestionBank *)questionBank  cellRow:(NSInteger )row{
    LibraryBank *libraryBank =questionBank.libraryBankArrays[row];
    _titleNum = [UILabel new];
    
    
    NSString *string = [NSString stringWithFormat:@"%ld、%@\n",row+1,libraryBank.libraryBankContent];
    [_titleNum setText:string];
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:smallTitleFontHeight];
    // 計算出顯示完內容需要的最小尺寸
//    CGSize heightSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-60, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize heightSize= [string sizeForString:string font:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-60, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ];
    
    
    _titleNum.frame = CGRectMake(10, 0, SCREEN_WIDTH-60, heightSize.height);
    [_titleNum setTextAlignment:NSTextAlignmentCenter];
    _titleNum.font =  [UIFont boldSystemFontOfSize: smallTitleFontHeight];
    _titleNum.numberOfLines = 0;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:2];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
    [_titleNum setAttributedText:attributedString1];
    
    [self addSubview: _titleNum];
    NSDictionary *dictionary =[[ToolKit instance] dictionaryWithJsonString:libraryBank.libraryBankChoice];
    NSMutableArray  *array = [ ChoiceContent objectArrayWithKeyValuesArray: dictionary[@"choice"]];
    
    UIView *choiceView = [UIView new];
    
    CGFloat choiceY = _titleNum.frame.size.height ;
    CGFloat lableHeight = 0.0;
    
    CGFloat trueChooseHeight= 0.0;
    
    int choiceForCount = (int)array.count+1;
    if (libraryBank.isTrue.length) {
        int status = [libraryBank.isTrue intValue] ;
        CGFloat  imageViewY = (24 -18)/2;
//        CGFloat imageViewX = 10 + 24 +10;
        UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(SCREEN_WIDTH -10 -35, imageViewY, 35, 18);
        NSString *imageName = status ?@"icon_Correct" :@"icon_mistake";
        imageView.image= [UIImage imageNamed:imageName];
        [self addSubview:imageView];
        if (![libraryBank.myChoose isEqualToString:@"-1"]) {
            NSMutableArray *array = [NSMutableArray new];
            for (int i = 0; i<libraryBank.myChoose.length; i++) {
                char c = [libraryBank.myChoose characterAtIndex:i];
                NSString * indexStr = [[ToolKit instance]  withIndex:[NSString stringWithFormat:@"%c",c]];
                [array addObject:indexStr];
            }
            NSString *str = [array componentsJoinedByString:@","];
            [ShareAppDelegate.answerDictionary setObject:str forKey:_groupId];
        }
        CGFloat size = SCREEN_WIDTH/(array.count + 1);
        CGFloat radioLeft = (size - 22)/2;
        if (!status) {
            if (libraryBank.libraryBankAnswers.length) {
                // 几种情况
                for (int i = 0; i<libraryBank.libraryBankAnswers.length; i++) {
                    char c = [libraryBank.libraryBankAnswers characterAtIndex:i];
                    int  index = [[[ToolKit instance]  withIndex:[NSString stringWithFormat:@"%c",c]] intValue];
                    UIImageView *chooseImageView = [[UIImageView alloc] init];
                    chooseImageView.image = [UIImage imageNamed:@"icon_Correct-option"];
                    if ([questionBank.choiceShowType intValue]==ChoiceVertical) {//
                        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
                            CGFloat imageY=0.0;
                            for (int i =0; i<array.count; i++) {
                                ChoiceContent *choiceContent = array[i];
                                NSString *string  =[NSString stringWithFormat:@"%@\n",
                                                    choiceContent.content];
                                UILabel *lable = [UILabel new];
                                // 用何種字體進行顯示
                                UIFont *font = [UIFont systemFontOfSize:fontHeight];
                                // 計算出顯示完內容需要的最小尺寸
//                                CGSize heightSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-46, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                                CGSize heightSize= [string sizeForString:string font:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-46, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ];
                                
                                
                                lable.frame = CGRectMake(36, imageY, SCREEN_WIDTH-46, heightSize.height);
                                UIView * view = [UIView new];
                                view.frame  = CGRectMake(10,imageY+radioHeight,22,22);
                                if (i==index) {
                                    chooseImageView.frame = CGRectMake(36,imageY,22,22);
                                    CGPoint center = view.center ;
                                    center.x = center.x + 11 +4 +11;
                                    chooseImageView.center =center;
                                }
                                imageY =  lable.frame.origin.y +lable.frame.size.height ;
                            }
                            
                            
                        }
                        else{
                            CGFloat size = titlePicSize; // chooseMargin
                            CGFloat chooseImageViewY =size*index +size/2 -12;
                            chooseImageView.frame = CGRectMake(10+22+10,chooseImageViewY,22,22);
                            
                            
                        }
                    }
                    else{
                        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
                            CGFloat singleWidth =   (SCREEN_WIDTH -10*2)/array.count;
                            CGFloat maginLeft = (singleWidth - 22)/2;
                            chooseImageView.frame = CGRectMake(10+maginLeft*(index+1)+index*22+maginLeft*index, 22+3+22,22,22);
                            trueChooseHeight = 25 ;
                        }
                        else{
                            CGFloat chooseImageViewX = horizontalChooseMargin(choiceForCount)/2 + radioLeft +22*index +radioLeft*index +radioLeft*index +horizontalChooseMargin(choiceForCount)*index;
                            chooseImageView.frame = CGRectMake(chooseImageViewX,size + 25 ,22,22);
                            trueChooseHeight = 25 ;
                        }
                    }
                    [choiceView addSubview:chooseImageView];
                    
                }
            }
        }
        
    }

    
    if ([questionBank.choiceShowType intValue] ==ChoiceVertical) {
        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
            for (int i =0; i<array.count; i++) {
                ChoiceContent *choiceContent = array[i];
                
                UILabel *lable = [UILabel new];
                NSString *string  =[NSString stringWithFormat:@"%@\n",
                                    choiceContent.content];
                [lable setText:string];
                
                // 用何種字體進行顯示
                UIFont *font = [UIFont systemFontOfSize:fontHeight];
                // 計算出顯示完內容需要的最小尺寸
//                CGSize heightSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-72, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                
                CGSize heightSize= [string sizeForString:string font:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-72, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ];
                
                
//                lable.frame = CGRectMake(36, 0, SCREEN_WIDTH-46, heightSize.height);
                
                lableHeight = heightSize.height;
                [lable setTextAlignment:NSTextAlignmentCenter];
                lable.font =  [UIFont systemFontOfSize: fontHeight];
                lable.numberOfLines = 0;
                NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:string];
                NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle1 setLineSpacing:2];
                [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
                [lable setAttributedText:attributedString1];
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                chooiceButton.frame = CGRectMake(10,choiceY+radioHeight,22,22);
                lable.frame = CGRectMake(62, choiceY, SCREEN_WIDTH-72, heightSize.height);
                choiceY =  lable.frame.origin.y +lable.frame.size.height;
//                if ( [ShareAppDelegate.answerDictionary objectForKey:_groupId] !=nil &&  [[ShareAppDelegate.answerDictionary objectForKey:_groupId] intValue]==i) {
//                    [chooiceButton setChecked:YES];
//                }
                [self setCheckedWithGroupId:_groupId withIndex:i WithCButton:chooiceButton];
                
                [choiceView addSubview:lable];
                [choiceView addSubview:chooiceButton];
            }
        }
        else {
            for (int i =0; i<array.count; i++) {
                ChoiceContent  *choiceContent = array[i];
                NSArray * urlArray = [choiceContent.content componentsSeparatedByString:@"-"];
                NSString *phoytoID = [urlArray firstObject];//图片
                NSString *voiceID = [urlArray lastObject];//声音
                NSString *urlStr  = [NSString stringWithFormat:@"%@%@",URL_QINIU,phoytoID];
                NSURL *url = [NSURL URLWithString:urlStr];
                
                UIImageView *choiceImageView = [UIImageView new];
                CGFloat size = SCREEN_WIDTH/(choiceForCount);
                choiceImageView .frame = CGRectMake(chooseMargin(choiceForCount), choiceY, size, size);
                [choiceImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"videoDefault"] ];
                 [self setborderImage:choiceImageView];
                [choiceView addSubview:choiceImageView];
                if(![phoytoID isEqualToString:voiceID]){
                    AudioButton *choiceAudioButton = [[AudioButton alloc] initWithFrame: CGRectMake(chooseMargin(choiceForCount)+choiceImageView.image.size.width, choiceY, chooseAudioSize, chooseAudioSize)];
                    [choiceView addSubview:choiceAudioButton];
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_QINIU,voiceID]];
                    [choiceAudioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
                    objc_setAssociatedObject(choiceAudioButton, "audioUrl", url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    [choiceView addSubview:choiceAudioButton];
                }
                
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                CGFloat chooiceButtonY =(choiceImageView.frame.origin.y) +(choiceImageView.frame.size.height/2)-11;
                chooiceButton.frame = CGRectMake(10,chooiceButtonY,22,22);
                [choiceView addSubview:chooiceButton];
//                if ( [ShareAppDelegate.answerDictionary objectForKey:_groupId] !=nil &&  [[ShareAppDelegate.answerDictionary objectForKey:_groupId] intValue]==i) {
//                    [chooiceButton setChecked:YES];
//                }
                [self setCheckedWithGroupId:_groupId withIndex:i WithCButton:chooiceButton];
                
                choiceY =  choiceImageView.frame.origin.y +choiceImageView.frame.size.height+3;
            }
        }
        
    }
    else{
        CGFloat singleWidth =   (SCREEN_WIDTH -10*2)/array.count;
        CGFloat maginLeft = (singleWidth - 22)/2;
        
        NSMutableArray *checkedArray   = [NSMutableArray new];
        if ([ShareAppDelegate.answerDictionary objectForKey:_groupId] ) {
            NSString * str = [ ShareAppDelegate.answerDictionary objectForKey:_groupId] ;
            checkedArray = [[ToolKit instance] arrayWithString:str];
        }
        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
            choiceY = 20 +22;
            for (int i =0; i<array.count; i++) {
                ChoiceContent *choiceContent = array[i];
                UILabel *lable = [UILabel new];
                NSString *string  =[NSString stringWithFormat:@"%@\n",choiceContent.content];
                [lable setText:string];
                lable.textAlignment = NSTextAlignmentCenter;
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                lable.frame = CGRectMake(10+singleWidth*i, 0, singleWidth, 20);
                chooiceButton.frame = CGRectMake(10+maginLeft*(i+1)+i*22+maginLeft*i, lable.frame.origin.y+lable.frame.size.height,22,22);
                
                [choiceView addSubview:lable];
                [choiceView addSubview:chooiceButton];
                
                
                if(checkedArray.count){
                    NSString *indexStr = [NSString stringWithFormat:@"%d",i];
                    for (int n=0;n<checkedArray.count;n++) {
                        NSString *temp = [checkedArray objectAtIndex:n];
                        if ([indexStr isEqualToString:temp]) {
                            [chooiceButton setChecked:YES];
                            break;
                        }
                    }
                }
                
                
            }
        }
        else{
            for (int i =0; i<array.count; i++) {
                ChoiceContent  *choiceContent = array[i];
                NSArray * urlArray = [choiceContent.content componentsSeparatedByString:@"-"];
                NSString *phoytoID = [urlArray firstObject];//图片
                NSString *voiceID = [urlArray lastObject];//声音
                NSString *urlStr  = [NSString stringWithFormat:@"%@%@",URL_QINIU,phoytoID];
                NSURL *url = [NSURL URLWithString:urlStr];
                
                UIImageView *choiceImageView = [UIImageView new];
                
                CGFloat size = SCREEN_WIDTH/(choiceForCount);
                CGFloat radioLeft = (size - 22)/2;
                
                choiceImageView .frame = CGRectMake(horizontalChooseMargin(choiceForCount)/2 +size *i +i*horizontalChooseMargin(choiceForCount) , 0, size, size);
                [choiceImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"videoDefault"] ];
                [self setborderImage:choiceImageView];
                [choiceView addSubview:choiceImageView];
                
                if(![phoytoID isEqualToString:voiceID]){
                    AudioButton *choiceAudioButton = [[AudioButton alloc] initWithFrame: CGRectMake(choiceImageView .frame.origin.x+size-chooseAudioSize, 0, chooseAudioSize, chooseAudioSize)];
                    [choiceView addSubview:choiceAudioButton];
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_QINIU,voiceID]];
                    [choiceAudioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
                    objc_setAssociatedObject(choiceAudioButton, "audioUrl", url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    [choiceView addSubview:choiceAudioButton];
                }
                
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                CGFloat chooiceButtonX = horizontalChooseMargin(choiceForCount)/2 + radioLeft +22*i +radioLeft*i +radioLeft*i +horizontalChooseMargin(choiceForCount)*i;
                chooiceButton.frame = CGRectMake(chooiceButtonX, size,22,22);
                [choiceView addSubview:chooiceButton];
//                if ( [ShareAppDelegate.answerDictionary objectForKey:_groupId] !=nil &&  [[ShareAppDelegate.answerDictionary objectForKey:_groupId] intValue]==i) {
//                    [chooiceButton setChecked:YES];
//                }
                [self setCheckedWithGroupId:_groupId withIndex:i WithCButton:chooiceButton];
                
                choiceY =  choiceImageView.frame.origin.y +choiceImageView.frame.size.height+14;
            }
        }
    }
    //      [RadioButton addObserverForGroupId:_groupId observer:self];
    [RadioButton addObserverForGroupId:_groupId observer:self chosenType:[questionBank chosenType]];
    choiceView.frame = CGRectMake(0, _titleNum.frame.origin.y+ _titleNum.bounds.size.height, SCREEN_WIDTH, choiceY+trueChooseHeight +10);
    [self addSubview:choiceView];
    CGRect cellFrame = [self frame];
    cellFrame.size.height = choiceView.frame.origin.y+  choiceView.bounds.size.height ;
    self.frame = cellFrame;
}

-(void)showTestSetTypeContentVoice:(QuestionBank *)questionBank  cellRow:(NSInteger )row{
    LibraryBank *libraryBank =questionBank.libraryBankArrays[row];
    
    UIView *view = [UIView new];
    UILabel *lable = [UILabel new];
    
    NSString *string = [NSString stringWithFormat:@"%ld、%@\n",row+1,libraryBank.libraryBankContent];
    [lable setText:string];
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:smallTitleFontHeight];
    // 計算出顯示完內容需要的最小尺寸
//    CGSize heightSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize heightSize= [string sizeForString:string font:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ];
    
    
    lable.frame = CGRectMake(10, 0, SCREEN_WIDTH-90, heightSize.height);
    [lable setTextAlignment:NSTextAlignmentCenter];
    lable.font =  [UIFont boldSystemFontOfSize: smallTitleFontHeight];
    lable.numberOfLines = 0;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:2];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
    [lable setAttributedText:attributedString1];
    view.frame = CGRectMake(0,  0, SCREEN_WIDTH-90, heightSize.height);
    [view addSubview:lable];
    [self addSubview:view];
    self.audioButton = [[AudioButton alloc] initWithFrame: CGRectMake(SCREEN_WIDTH-80, 5, titleAudioSize, titleAudioSize)];
    [self addSubview:self.audioButton];
    self.audioButton.tag =(long)libraryBank.libraryBankVoice;
    NSURL *   url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_QINIU,libraryBank.libraryBankVoice]];
    [self.audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(self.audioButton, "audioUrl", url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSDictionary *dictionary =[[ToolKit instance] dictionaryWithJsonString:libraryBank.libraryBankChoice];
    NSMutableArray  *array = [ ChoiceContent objectArrayWithKeyValuesArray: dictionary[@"choice"]];
    UIView *choiceView = [UIView new];
    CGFloat choiceY = lable.frame.size.height ;
    CGFloat lableHeight = 0.0;
    
    CGFloat trueChooseHeight= 0.0;
    
    int choiceForCount = (int)array.count+1;
    if (libraryBank.isTrue.length) {
        int status = [libraryBank.isTrue intValue] ;
        CGFloat  imageViewY = (24 -18)/2;
//        CGFloat imageViewX = 10 + 24 +10;
        UIImageView *imageView = [[UIImageView alloc] init];
          imageView.frame = CGRectMake(SCREEN_WIDTH -10 -35, imageViewY, 35, 18);
        NSString *imageName = status ?@"icon_Correct" :@"icon_mistake";
        imageView.image= [UIImage imageNamed:imageName];
        [self addSubview:imageView];
        if (![libraryBank.myChoose isEqualToString:@"-1"]) {
            NSMutableArray *array = [NSMutableArray new];
            for (int i = 0; i<libraryBank.myChoose.length; i++) {
                char c = [libraryBank.myChoose characterAtIndex:i];
                NSString * indexStr = [[ToolKit instance]  withIndex:[NSString stringWithFormat:@"%c",c]];
                [array addObject:indexStr];
            }
            NSString *str = [array componentsJoinedByString:@","];
            [ShareAppDelegate.answerDictionary setObject:str forKey:_groupId];
        }
        CGFloat size = SCREEN_WIDTH/(array.count + 1);
        CGFloat radioLeft = (size - 22)/2;
        if (!status) {
            if (libraryBank.libraryBankAnswers.length) {
                // 几种情况
                for (int i = 0; i<libraryBank.libraryBankAnswers.length; i++) {
                    char c = [libraryBank.libraryBankAnswers characterAtIndex:i];
                    int  index = [[[ToolKit instance]  withIndex:[NSString stringWithFormat:@"%c",c]] intValue];
                    UIImageView *chooseImageView = [[UIImageView alloc] init];
                    chooseImageView.image = [UIImage imageNamed:@"icon_Correct-option"];
                    if ([questionBank.choiceShowType intValue]==ChoiceVertical) {//
                        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
                            CGFloat imageY=lable.frame.size.height;
                            for (int i =0; i<array.count; i++) {
                                ChoiceContent *choiceContent = array[i];
                                NSString *string  =[NSString stringWithFormat:@"%@\n",
                                                    choiceContent.content];
                                UILabel *lable = [UILabel new];
                                // 用何種字體進行顯示
                                UIFont *font = [UIFont systemFontOfSize:fontHeight];
                                // 計算出顯示完內容需要的最小尺寸
//                                CGSize heightSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-46, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                                CGSize heightSize= [string sizeForString:string font:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-46, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ];
                                
                                
                                lable.frame = CGRectMake(36, imageY, SCREEN_WIDTH-46, heightSize.height);
                                UIView * view = [UIView new];
                                view.frame  = CGRectMake(10,imageY+radioHeight,22,22);
                                if (i==index) {
                                    chooseImageView.frame = CGRectMake(36,imageY,22,22);
                                    CGPoint center = view.center ;
                                    center.x = center.x + 11 +4 +11;
                                    chooseImageView.center =center;
                                }
                                imageY =  lable.frame.origin.y +lable.frame.size.height ;
                            }
                        }
                        else{
//                            CGFloat size = titlePicSize; // chooseMargin
                            CGFloat chooseImageViewY =lable.frame.size.height+26;
                            chooseImageView.frame = CGRectMake(10+22+10,chooseImageViewY,22,22);
                        }
                    }
                    else{
                        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
                            CGFloat singleWidth =   (SCREEN_WIDTH -10*9)/array.count;
                            CGFloat maginLeft = (singleWidth - 22)/2;
                            chooseImageView.frame = CGRectMake(10+maginLeft*(index+1)+index*22+maginLeft*index, choiceY+20+22,22,22);
                            trueChooseHeight = 25 ;
                        }
                        else{
                            CGFloat chooseImageViewX = horizontalChooseMargin(choiceForCount) + radioLeft +22*index +radioLeft*index +radioLeft*index +horizontalChooseMargin(choiceForCount)*index;
                            chooseImageView.frame = CGRectMake(chooseImageViewX,choiceY + 25 ,22,22);
                            trueChooseHeight = 25 ;
                        }
                    }
                    [choiceView addSubview:chooseImageView];
                    
                }
            }
        }
        
    }

    
    if ([questionBank.choiceShowType intValue]==ChoiceVertical) {
        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
            for (int i =0; i<array.count; i++) {
                ChoiceContent *choiceContent = array[i];
                
                UILabel *lable = [UILabel new];
                NSString *string  =[NSString stringWithFormat:@"%@\n",
                                    choiceContent.content];
                [lable setText:string];
                
                // 用何種字體進行顯示
                UIFont *font = [UIFont systemFontOfSize:fontHeight];
                // 計算出顯示完內容需要的最小尺寸
//                CGSize heightSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-72, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                CGSize heightSize= [string sizeForString:string font:font constrainedToSize:CGSizeMake(SCREEN_WIDTH-72, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ];
                
                
                lableHeight = heightSize.height;
                [lable setTextAlignment:NSTextAlignmentCenter];
                lable.font =  [UIFont systemFontOfSize: fontHeight];
                lable.numberOfLines = 0;
                NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:string];
                NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle1 setLineSpacing:2];
                [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
                [lable setAttributedText:attributedString1];
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                chooiceButton.frame = CGRectMake(10,choiceY+radioHeight,22,22);
                lable.frame = CGRectMake(62, choiceY, SCREEN_WIDTH-100, heightSize.height);
                choiceY =  lable.frame.origin.y +lable.frame.size.height;
                [choiceView addSubview:lable];
                [choiceView addSubview:chooiceButton];
                
               
//                if ( [ShareAppDelegate.answerDictionary objectForKey:_groupId] !=nil &&  [[ShareAppDelegate.answerDictionary objectForKey:_groupId] intValue]==i) {
//                    [chooiceButton setChecked:YES];
//                }
                [self setCheckedWithGroupId:_groupId withIndex:i WithCButton:chooiceButton];
                
                
            }
        }
        else{
            for (int i =0; i<array.count; i++) {
                ChoiceContent  *choiceContent = array[i];
                NSArray * urlArray = [choiceContent.content componentsSeparatedByString:@"-"];
                NSString *phoytoID = [urlArray firstObject];//图片
                NSString *voiceID = [urlArray lastObject];//声音
                NSString *urlStr  = [NSString stringWithFormat:@"%@%@",URL_QINIU,phoytoID];
                NSURL *url = [NSURL URLWithString:urlStr];
                
                UIImageView *choiceImageView = [UIImageView new];
                CGFloat size = SCREEN_WIDTH/(choiceForCount);
                choiceImageView .frame = CGRectMake(chooseMargin(choiceForCount), choiceY, size, size);
                [choiceImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"videoDefault"] ];
                [self setborderImage:choiceImageView];
                [choiceView addSubview:choiceImageView];
                if(![phoytoID isEqualToString:voiceID]){
                    AudioButton *choiceAudioButton = [[AudioButton alloc] initWithFrame: CGRectMake(chooseMargin(choiceForCount)+choiceImageView.image.size.width, choiceY, chooseAudioSize, chooseAudioSize)];
                    [choiceView addSubview:choiceAudioButton];
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_QINIU,voiceID]];
                    [choiceAudioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
                    objc_setAssociatedObject(choiceAudioButton, "audioUrl", url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    [choiceView addSubview:choiceAudioButton];
                }
                
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                CGFloat chooiceButtonY =(choiceImageView.frame.origin.y) +(choiceImageView.frame.size.height/2)-11;
                chooiceButton.frame = CGRectMake(10,chooiceButtonY,22,22);
                [choiceView addSubview:chooiceButton];
//                if ( [ShareAppDelegate.answerDictionary objectForKey:_groupId] !=nil &&  [[ShareAppDelegate.answerDictionary objectForKey:_groupId] intValue]==i) {
//                    [chooiceButton setChecked:YES];
//                }
                
                [self setCheckedWithGroupId:_groupId withIndex:i WithCButton:chooiceButton];
                
                choiceY =  choiceImageView.frame.origin.y +choiceImageView.frame.size.height+3;
            }        }
    }
    else{
        CGFloat singleWidth =   (SCREEN_WIDTH -10*9)/array.count;
        CGFloat maginLeft = (singleWidth - 22)/2;
        
        NSMutableArray *checkedArray   = [NSMutableArray new];
        if ([ShareAppDelegate.answerDictionary objectForKey:_groupId] ) {
            NSString * str = [ ShareAppDelegate.answerDictionary objectForKey:_groupId] ;
            checkedArray = [[ToolKit instance] arrayWithString:str];
        }
        if ([libraryBank.libraryBankChoiceType intValue]==ChoiceTypeText) {
//            choiceY =20 ;
           
            for (int i =0; i<array.count; i++) {
                ChoiceContent *choiceContent = array[i];
                UILabel *lable = [UILabel new];
                NSString *string  =[NSString stringWithFormat:@"%@\n",choiceContent.content];
                [lable setText:string];
                lable.textAlignment = NSTextAlignmentCenter;
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                lable.frame = CGRectMake(10+singleWidth*i, choiceY, singleWidth, 20);
                chooiceButton.frame = CGRectMake(10+maginLeft*(i+1)+i*22+maginLeft*i, lable.frame.origin.y+lable.frame.size.height,22,22);
                
                [choiceView addSubview:lable];
                [choiceView addSubview:chooiceButton];
                
                
                if(checkedArray.count){
                    NSString *indexStr = [NSString stringWithFormat:@"%d",i];
                    for (int n=0;n<checkedArray.count;n++) {
                        NSString *temp = [checkedArray objectAtIndex:n];
                        if ([indexStr isEqualToString:temp]) {
                            [chooiceButton setChecked:YES];
                            break;
                        }
                    }
                }
            }
             choiceY = choiceY + 34;
        }
        else{
            for (int i =0; i<array.count; i++) {
                ChoiceContent  *choiceContent = array[i];
                NSArray * urlArray = [choiceContent.content componentsSeparatedByString:@"-"];
                NSString *phoytoID = [urlArray firstObject];//图片
                NSString *voiceID = [urlArray lastObject];//声音
                NSString *urlStr  = [NSString stringWithFormat:@"%@%@",URL_QINIU,phoytoID];
                NSURL *url = [NSURL URLWithString:urlStr];
                
                UIImageView *choiceImageView = [UIImageView new];
                
                CGFloat size = SCREEN_WIDTH/(choiceForCount);
                CGFloat radioLeft = (size - 22)/2;
                
                choiceImageView .frame = CGRectMake(horizontalChooseMargin(choiceForCount) +size *i +i*horizontalChooseMargin(choiceForCount) , 0, size, size);
                [choiceImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"videoDefault"] ];
                [self setborderImage:choiceImageView];
                [choiceView addSubview:choiceImageView];
                
                if(![phoytoID isEqualToString:voiceID]){
                    AudioButton *choiceAudioButton = [[AudioButton alloc] initWithFrame: CGRectMake(choiceImageView .frame.origin.x+size-chooseAudioSize, 0, chooseAudioSize, chooseAudioSize)];
                    [choiceView addSubview:choiceAudioButton];
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_QINIU,voiceID]];
                    [choiceAudioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
                    objc_setAssociatedObject(choiceAudioButton, "audioUrl", url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    [choiceView addSubview:choiceAudioButton];
                }
                
                RadioButton *chooiceButton = [[RadioButton alloc] initWithGroupId:_groupId index:i];
                CGFloat chooiceButtonX = horizontalChooseMargin(choiceForCount) + radioLeft +22*i +radioLeft*i +radioLeft*i +horizontalChooseMargin(choiceForCount)*i;
                chooiceButton.frame = CGRectMake(chooiceButtonX, size,22,22);
                
                [choiceView addSubview:chooiceButton];
//                if ( [ShareAppDelegate.answerDictionary objectForKey:_groupId] !=nil &&  [[ShareAppDelegate.answerDictionary objectForKey:_groupId] intValue]==i) {
//                    [chooiceButton setChecked:YES];
//                }
                [self setCheckedWithGroupId:_groupId withIndex:i WithCButton:chooiceButton];
                
                choiceY =  choiceImageView.frame.origin.y +choiceImageView.frame.size.height+3;
            }
        }
    }
    //    [RadioButton addObserverForGroupId:_groupId observer:self];
    [RadioButton addObserverForGroupId:_groupId observer:self chosenType:[questionBank chosenType]];
    choiceView.frame = CGRectMake(0, _titleNum.frame.size.height+_titleNum.frame.origin.y+15, SCREEN_WIDTH-90, choiceY+trueChooseHeight+10);
    [self addSubview:choiceView];
    CGRect cellFrame = [self frame];
    cellFrame.size.height = choiceView.frame.origin.y+  choiceView.bounds.size.height;
    self.frame = cellFrame;
    
    
}

                 
-(void)setCheckedWithGroupId:(NSString *)groupId withIndex:(int)i WithCButton:(RadioButton*)chooiceButton{
                     
    NSString *answerdDictionary = [ShareAppDelegate.answerDictionary objectForKey:groupId] ;
    if ( [ShareAppDelegate.answerDictionary objectForKey:groupId] !=nil ){
        NSArray *arraydd = [answerdDictionary componentsSeparatedByString:@","];
        for (int j = 0; j < arraydd.count; j ++) {
            if ([[arraydd objectAtIndex:j] intValue]==i) {
                [chooiceButton setChecked:YES];
            }
        }
    }
}
                 
              

-(void)dealloc{
    _titleNum =nil;
    _audioButton=nil;
    _groupId = nil;
    _textDesc = nil;
}




@end
