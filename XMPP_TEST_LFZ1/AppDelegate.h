//
//  AppDelegate.h
//  XMPP_TEST_LFZ1
//
//  Created by 郎凤招 on 16/5/30.
//  Copyright © 2016年 Lang.FZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,EMClientDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

//# XMPP_TEST_LFZ
//
//# 仿写了战旗TV的部分功能
//
//-有点感兴趣就找资料学了下视频直播，抓包不太熟练找不到战旗的聊天群就自己集成了环信的XMPP
//
//-弹幕用的https://github.com/unash/BarrageRenderer
//
//-播放器用的https://github.com/ShelinShelin/XLVideoPlayer
//
//#前排找工作，实习岗也请骚扰我:smiley: