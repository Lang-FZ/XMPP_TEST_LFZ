//
//  DetailViewController.h
//  XMPP_TEST_LFZ1
//
//  Created by 郎凤招 on 16/5/31.
//  Copyright © 2016年 Lang.FZ. All rights reserved.
//  roomViewController

#import <UIKit/UIKit.h>
#import "EMSDK.h"
#import "ItemModel.h"
#import "botTextFieldView.h"
#import "XLVideoPlayer.h"
#import "BarrageRenderer.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface DetailViewController : UIViewController<EMChatManagerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) ItemModel *model;         //视频信息

@property (nonatomic, strong) UITableView *myTableView; //XMPP显示

@property (nonatomic, strong) NSMutableArray *data;     //聊天群数据

@property (nonatomic, strong) BotTextFieldView *botTextfieldView;           //非全屏弹幕输入框

@property (nonatomic, strong) XLVideoPlayer *myPlayer;  //播放器

@property (nonatomic, strong) BarrageRenderer *barrage;

@property (nonatomic, strong) UIButton *backBtn;        //pop按钮

@end

//@property (nonatomic, strong) AVPlayerViewController *playViewCV;           //播放器

//@property (nonatomic, strong) UIButton *bigBtn;         //全屏按钮

//@property (nonatomic, assign) BOOL videoSize;           //0小屏 1全屏

//@property (nonatomic, strong) UIView *botView;          //全屏播放器后上边栏

//@property (nonatomic, strong) UIView *topView;          //全屏后下边栏

//@property (nonatomic, assign) BOOL selec;               //全屏后点击
