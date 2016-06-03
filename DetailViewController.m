//
//  DetailViewController.m
//  XMPP_TEST_LFZ1
//
//  Created by 郎凤招 on 16/5/31.
//  Copyright © 2016年 Lang.FZ. All rights reserved.
//

#import "DetailViewController.h"
#import "XMPPCell.h"

#define kTopBotH 80
#define VideoUrl @"http://dlhls.cdn.zhanqi.tv/zqlive/"
#define VideoUrlNormal @".m3u8"
#define VideoUrlLow @"_400/index.m3u8"
#define VideoUrlMid @"_700/index.m3u8"
#define VideoUrlHigh @"_1024/index.m3u8"
static NSString *roomCell = @"cell";

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _data = [[NSMutableArray alloc] init];
    
//    [self creatPlayer];
    
    [self creatXLVideoPlayer];
    
    [self creatTableView];
    
    [self creatTextfield];
    
    [self creatXMPPGroupChat];
    
    [self creatBackButton];
    
    [self creatBarrage];
    
//    [self creatTopView];
    
//    [self creatBotView];
    
//    if (_videoSize) {
//        _topView.alpha = 0;
////        _botView.alpha = 0;
//    }
}

- (void)setModel:(ItemModel *)model {
    
    _model = model;
    
    _myPlayer.videoId = _model.videoId;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerReconnect) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

//- (void)playerReconnect {
//
//        [_myPlayer playPause];
//        [_myPlayer playPause];
////        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",VideoUrl,_model.videoId,VideoUrlNormal]]];
////        [_playViewCV.player replaceCurrentItemWithPlayerItem:item];
////        [_playViewCV.player play];
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma - mark 播放器
- (void)creatXLVideoPlayer {

    _myPlayer = [[XLVideoPlayer alloc] init];
    _myPlayer.videoUrl = [NSString stringWithFormat:@"%@%@%@",VideoUrl,_model.videoId,VideoUrlNormal];
    _myPlayer.frame = CGRectMake(0, 0, kScreenW, kScreenW * kScreenW / kScreenH);
    
    _myPlayer.videoId = _model.videoId;
    
    [self.view addSubview:_myPlayer];
}

#pragma - mark 发弹幕输入框

- (void)creatTextfield {

    _botTextfieldView = [[BotTextFieldView alloc] initWithFrame:CGRectMake(0, kScreenH - 49, kScreenW, 49)];
    
    _botTextfieldView.backgroundColor = [UIColor clearColor];
    
    UITextField *textView = [[UITextField alloc] initWithFrame:CGRectMake(2, 2, kScreenW - 4, 45)];
    
    _botTextfieldView.textView = textView;
    
    _botTextfieldView.textView.backgroundColor = [UIColor lightGrayColor];
    
    _botTextfieldView.textView.text = @"发个弹幕呗";
    
    _botTextfieldView.textView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHight:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    [_botTextfieldView addSubview:_botTextfieldView.textView];
    
    [self.view addSubview:_botTextfieldView];
}



- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.text = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.text = @"发个弹幕呗";
}

//发送群消息
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text != nil) {
        EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:_botTextfieldView.textView.text];
        
        EMMessage *mess = [[EMMessage alloc] initWithConversationID:GroupId from:UserName to:GroupId body:body ext:nil];
        
        mess.chatType = EMChatTypeGroupChat;
        
        [[EMClient sharedClient].chatManager asyncSendMessage:mess progress:nil completion:^(EMMessage *message, EMError *error) {
            
            if ([message.body valueForKey:@"text"] != nil ) {
                [_data addObject:message];
                [_myTableView reloadData];
                [_myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_data.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
                [_barrage receive:[self walkTextSpriteDescriptorWithForm:message.from withText:[message.body valueForKey:@"text"]]];
            }
        }];
    }
    
    [_botTextfieldView.textView endEditing:YES];
    
    return YES;
}

- (void)keyboardHidden:(NSNotification *)notification {

    NSDictionary *info = [notification userInfo];
    
//    int offset = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    _botTextfieldView.frame = CGRectMake(0, kScreenH - 49, kScreenW, 49);
    
    _botTextfieldView.textView.frame = CGRectMake(2, 2, kScreenW - 4, 45);

}

- (void)keyboardHight:(NSNotification *)notification {

    NSDictionary *info = [notification userInfo];
    
    int offset = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    [_botTextfieldView animateTextField:offset];
    
    _botTextfieldView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    
}

#pragma - mark 聊天界面

//读取XMPP群消息
- (void)creatXMPPGroupChat {
    
    
    
    //    EMError *error = [[EMError alloc] init];
    //    EMGroup *roomList = [[EMClient sharedClient].groupManager fetchGroupInfo:GroupId includeMembersList:YES error:&error];
    //    NSLog(@"%@",roomList.occupants); //群组成员名
    
    //读取群组消息
    NSArray *consts = [[EMClient sharedClient].chatManager getAllConversations];
    
    EMConversation *con = consts[0];
    
    NSArray *allConMes = [con loadMoreMessagesFromId:nil limit:20 direction:EMMessageSearchDirectionUp];
    
    for (EMMessage *obj in allConMes) {
        
        [_data addObject:obj];
        
        //        NSString *barrageStr = [NSString stringWithFormat:@"%@ : %@",obj.from,[obj.body valueForKey:@"text"]];
        [_barrage receive:[self walkTextSpriteDescriptorWithForm:obj.from withText:[obj.body valueForKey:@"text"]]];
        
        //        NSLog(@"\n%@\n%@ : %@\n%@",[NSDate dateWithTimeIntervalSince1970:(long)(obj.timestamp/1000 + 60*60*8)],obj.from,[obj.body valueForKey:@"text"],_data);
    }
    
    [_myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_data.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    //发送群组消息
    /*
     EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:@"说点啥腻"];
     
     EMMessage *mess = [[EMMessage alloc] initWithConversationID:GroupId from:UserName to:GroupId body:body ext:nil];
     
     mess.chatType = EMChatTypeGroupChat;
     
     //    [[EMClient sharedClient].chatManager updateMessage:message];
     //
     //    [[EMClient sharedClient].chatManager getConversation:GroupId type:EMConversationTypeGroupChat createIfNotExist:NO];
     
     [[EMClient sharedClient].chatManager asyncSendMessage:mess progress:nil completion:^(EMMessage *message, EMError *error) {
     NSLog(@"\n%@\t%@",[message.body valueForKey:@"text"],error);
     }];
     */
    
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

//实时接收群消息
- (void)didReceiveMessages:(NSArray *)aMessages
{
    for (EMMessage *message in aMessages) {
        
        [_data addObject:message];    //新消息加到tableView上
        [_myTableView reloadData];
        [_myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_data.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        //            NSString *barrageStr = [NSString stringWithFormat:@"%@ : %@",message.from,[message.body valueForKey:@"text"]];
        [_barrage receive:[self walkTextSpriteDescriptorWithForm:message.from withText:[message.body valueForKey:@"text"]]];
        
        EMMessageBody *msgBody = message.body;
        switch (msgBody.type) {
            case EMMessageBodyTypeText:
            {
                // 收到的文字消息
                EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                NSString *txt = textBody.text;
                NSLog(@"\n%@\n%@ : %@",[NSDate dateWithTimeIntervalSince1970:(long)(message.timestamp/1000 + 28800)],message.from,txt);
            }
                break;
            case EMMessageBodyTypeImage:
            {
                // 得到一个图片消息body
                EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
                NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
                NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用sdk提供的下载方法后才会存在
                NSLog(@"大图的secret -- %@"    ,body.secretKey);
                NSLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
                NSLog(@"大图的下载状态 -- %u",body.downloadStatus);
                
                
                // 缩略图sdk会自动下载
                NSLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
                NSLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
                NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
                NSLog(@"小图的W -- %f ,大图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
                NSLog(@"小图的下载状态 -- %u",body.thumbnailDownloadStatus);
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
                NSLog(@"纬度-- %f",body.latitude);
                NSLog(@"经度-- %f",body.longitude);
                NSLog(@"地址-- %@",body.address);
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                // 音频sdk会自动下载
                EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
                NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
                NSLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在（音频会自动调用）
                NSLog(@"音频的secret -- %@"        ,body.secretKey);
                NSLog(@"音频文件大小 -- %lld"       ,body.fileLength);
                NSLog(@"音频文件的下载状态 -- %u"   ,body.downloadStatus);
                NSLog(@"音频的时间长度 -- %u"      ,body.duration);
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
                
                NSLog(@"视频remote路径 -- %@"      ,body.remotePath);
                NSLog(@"视频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
                NSLog(@"视频的secret -- %@"        ,body.secretKey);
                NSLog(@"视频文件大小 -- %lld"       ,body.fileLength);
                NSLog(@"视频文件的下载状态 -- %u"   ,body.downloadStatus);
                NSLog(@"视频的时间长度 -- %u"      ,body.duration);
                NSLog(@"视频的W -- %f ,视频的H -- %f", body.thumbnailSize.width, body.thumbnailSize.height);
                
                // 缩略图sdk会自动下载
                NSLog(@"缩略图的remote路径 -- %@"     ,body.thumbnailRemotePath);
                NSLog(@"缩略图的local路径 -- %@"      ,body.thumbnailLocalPath);
                NSLog(@"缩略图的secret -- %@"        ,body.thumbnailSecretKey);
                NSLog(@"缩略图的下载状态 -- %u"      ,body.thumbnailDownloadStatus);
            }
                break;
            case EMMessageBodyTypeFile:
            {
                EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
                NSLog(@"文件remote路径 -- %@"      ,body.remotePath);
                NSLog(@"文件local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
                NSLog(@"文件的secret -- %@"        ,body.secretKey);
                NSLog(@"文件文件大小 -- %lld"       ,body.fileLength);
                NSLog(@"文件文件的下载状态 -- %u"   ,body.downloadStatus);
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)creatTableView {
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenW * kScreenW / kScreenH, kScreenW, kScreenH - kScreenW * kScreenW / kScreenH - 49) style:UITableViewStylePlain];
    
    _myTableView.delegate = self;
    
    _myTableView.dataSource = self;
    
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_myTableView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 25;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XMPPCell *cell = [tableView dequeueReusableCellWithIdentifier:roomCell];
    
    if (!cell) {
        cell = [[XMPPCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:roomCell];
    }
    
    EMMessage *message = _data[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@",message.from,[message.body valueForKey:@"text"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma - mark 退出按钮

- (void)creatBackButton {
    
    _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    _backBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"movie_back.png"]];
    
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchDown];
    
    [_myPlayer addSubview:_backBtn];
    
    //    _bigBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - 44, kScreenW * kScreenW / kScreenH - 44, 44, 44)];
    //
    //    _bigBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"movie_fullscreen.png"]];
    //
    //    [_bigBtn addTarget:self action:@selector(bigAction) forControlEvents:UIControlEventTouchDown];
    //
    //    [_playViewCV.view addSubview:_bigBtn];
    
}

- (void)backAction {
    
    [_myPlayer destroyPlayer];
    
    [self.navigationController popViewControllerAnimated:YES];

//    [self interfaceOrientation:1];
}

#pragma mark - 弹幕

// 创建弹幕
- (void)creatBarrage {
    
    _barrage = [[BarrageRenderer alloc] init];
    
    [_barrage start];
    
    _barrage.speed = 5;
    
    _barrage.canvasMargin = UIEdgeInsetsMake(5, 5, 5, 5);
    
    [_myPlayer addSubview:_barrage.view];
}

/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithForm:(NSString *)from withText:(NSString *)text
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"%@ : %@",from,text];
    descriptor.params[@"textColor"] = [UIColor blackColor];
    descriptor.params[@"speed"] = @50;
    //    descriptor.params[@"direction"] = @1;
    //    descriptor.params[@"clickAction"] = ^{
    //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"弹幕被点击" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    //        [alertView show];
    //    };
    return descriptor;
}

@end


#pragma - mark 最开始用AVPlayerViewController写的，横屏后变竖屏AVPlayerView的frameBUG改不掉  就在网上找了封装在view上的播放器 XLVideoPlayer

//旋转屏幕
//- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
//{
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
//    {
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = orientation;
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
//}

//- (void)creatTopView {
//
//    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, -kTopBotH, kScreenW, kTopBotH)];
//
//    _topView.backgroundColor = [UIColor grayColor];
//
//    _topView.alpha = 0.75;
//
//    UIButton *backBtn = [self creatButtonWithFrame:CGRectMake(10, 10, 60, 60) withColor:[UIColor redColor]];
//    [backBtn addTarget:self action:@selector(smallAction) forControlEvents:UIControlEventTouchDown];
//
////    UIButton *indexBtnLow = [self creatButtonWithFrame:CGRectMake(200, 10, 60, 60) withColor:[UIColor orangeColor]];
////    [indexBtnLow addTarget:self action:@selector(indexBtnLow:) forControlEvents:UIControlEventTouchDown];
////
////    UIButton *indexBtnMid = [self creatButtonWithFrame:CGRectMake(280, 10, 60, 60) withColor:[UIColor orangeColor]];
////    [indexBtnMid addTarget:self action:@selector(indexBtnMid:) forControlEvents:UIControlEventTouchDown];
////
////    UIButton *indexBtnHigh = [self creatButtonWithFrame:CGRectMake(360, 10, 60, 60) withColor:[UIColor orangeColor]];
////    [indexBtnHigh addTarget:self action:@selector(indexBtnHigh:) forControlEvents:UIControlEventTouchDown];
//
//    [_topView addSubview:backBtn];
//
////    [_topView addSubview:indexBtnLow];
////
////    [_topView addSubview:indexBtnMid];
////
////    [_topView addSubview:indexBtnHigh];
//
//    [_playViewCV.view addSubview:_topView];
//}

//- (void)smallAction {
//
//    _playViewCV.view.frame = CGRectMake(0, 0, kScreenW, kScreenW * kScreenW / kScreenH);
//
//    _playViewCV.player.accessibilityFrame = _playViewCV.videoBounds;
//
//    [self interfaceOrientation:UIInterfaceOrientationPortrait];
//
//    _bigBtn.alpha = 1;
//
//    _myTableView.alpha = 1;
//
//    _botTextfieldView.alpha = 1;
//
//    _backBtn.alpha = 1;
//
//    _videoSize = NO;
//
//    _topView.alpha = 0;
//
////    _botView.alpha = 0;
//}

//- (void)creatBotView {
//
//    _botView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH , kScreenW, kTopBotH)];
//
//    _botView.backgroundColor = [UIColor grayColor];
//
//    _botView.alpha = 0.75;
//
//    UIButton *playBtn = [self creatButtonWithFrame:CGRectMake(10, 10, 60, 60) withColor:[UIColor orangeColor]];
//
//    [playBtn addTarget:self action:@selector(playBtn:) forControlEvents:UIControlEventTouchDown];
//
//    [_botView addSubview:playBtn];
//
//    [_playViewCV.view addSubview:_botView];
//}

//- (void)playBtn:(UIButton *)btn {
//
//    btn.selected = !btn.selected;
//
//    if(btn.selected) {
//        [_playViewCV.player pause];
//    } else {
//        [_playViewCV.player play];
//    }
//}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    if (_videoSize) {
//
//        _selec = !_selec;
//
//        if (_selec) {
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:.35];
//            _botView.frame = CGRectMake(0, kScreenH - kTopBotH, kScreenW, kTopBotH);
//            _topView.frame = CGRectMake(0, 0, kScreenW, kTopBotH);
//            [UIView commitAnimations];
//        } else {
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:.35];
//            _botView.frame = CGRectMake(0, kScreenH, kScreenW, kTopBotH);
//            _topView.frame = CGRectMake(0, -kTopBotH, kScreenW, kTopBotH);
//            [UIView commitAnimations];
//        }
//    }
//}
//
//- (UIButton *)creatButtonWithFrame:(CGRect)rect withColor:(UIColor *)color {
//
//    UIButton *BTN = [[UIButton alloc] initWithFrame:rect];
//
//    BTN.backgroundColor = color;
//
//    return BTN;
//}
//
//- (void)indexBtnLow:(UIButton *)btn {
//
//    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",VideoUrl,_model.videoId,VideoUrlLow]]];
//
//    [_playViewCV.player replaceCurrentItemWithPlayerItem:item];
//
//}
//
//- (void)indexBtnMid:(UIButton *)btn {
//
//    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",VideoUrl,_model.videoId,VideoUrlMid]]];
//
//    [_playViewCV.player replaceCurrentItemWithPlayerItem:item];
//
//}
//
//- (void)indexBtnHigh:(UIButton *)btn {
//
//    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",VideoUrl,_model.videoId,VideoUrlHigh]]];
//
//    [_playViewCV.player replaceCurrentItemWithPlayerItem:item];
//
//}


//播放器
//- (void)creatPlayer {
//
//    AVPlayer *player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",VideoUrl,_model.videoId,VideoUrlNormal]]];
//
//    _playViewCV = [[AVPlayerViewController alloc] init];
//
//    _playViewCV.player = player;
//
//    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
//
//    _playViewCV.videoGravity = AVLayerVideoGravityResizeAspectFill;
//
//    _playViewCV.showsPlaybackControls = false;
//
//    _playViewCV.view.frame = CGRectMake(0, 0, kScreenW, kScreenW * kScreenW / kScreenH);
//
//    [_playViewCV.player play];
//
//    _videoSize = NO;
//
////    [self.view addSubview:_playViewCV.view];
//}

//- (void)bigAction {
//
//    _playViewCV.view.frame = CGRectMake(0, 0, kScreenW, kScreenH);
//
//    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
//
//    _bigBtn.alpha = 0;
//
//    _myTableView.alpha = 0;
//
//    _botTextfieldView.alpha = 0;
//
//    _backBtn.alpha = 0;
//
//    _videoSize = YES;
//}
