//
//  ItemModel.h
//  XMPP_TEST_LFZ1
//
//  Created by 郎凤招 on 16/6/1.
//  Copyright © 2016年 Lang.FZ. All rights reserved.
// http://www.zhanqi.tv/api/static/live.hots/20-1.json?os=1&ver=3.1.1

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject

@property (nonatomic, copy) NSString *nickname;         //主播名字

@property (nonatomic, copy) NSString *online;           //观看人数

@property (nonatomic, copy) NSString *title;            //直播标题

@property (nonatomic, copy) NSString *bpic;             //缩略图大图    小图是sqic

@property (nonatomic, copy) NSString *videoId;          //HLS拼接关键词

@end
