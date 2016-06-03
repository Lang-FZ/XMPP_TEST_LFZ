//
//  AppDelegate.m
//  XMPP_TEST_LFZ1
//
//  Created by 郎凤招 on 16/5/30.
//  Copyright © 2016年 Lang.FZ. All rights reserved.
//  登录环信我的应用

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    EMOptions *options = [EMOptions optionsWithAppkey:APPKEY];
    
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
    EMError *error = [[EMClient sharedClient] loginWithUsername:UserName password:PassWord];
    
    if (!error) {
        [[EMClient sharedClient].options setIsAutoLogin:YES];
//        NSLog(@"登陆成功");
    }
    
//    NSLog(@"%@",error);//登陆的错误
    
    return YES;
}

- (void)didAutoLoginWithError:(EMError *)aError {
    
//    NSLog(@"已经自动登录");
}

//- (void)applicationWillEnterForeground:(UIApplication *)application {
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillEnterForegroundNotification object:nil];
//}

@end
