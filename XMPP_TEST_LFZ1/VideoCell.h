//
//  VideoCell.h
//  XMPP_TEST_LFZ1
//
//  Created by 郎凤招 on 16/6/1.
//  Copyright © 2016年 Lang.FZ. All rights reserved.
//  首页collectionViewCell

#import <UIKit/UIKit.h>
#import "ItemModel.h"

@interface VideoCell : UICollectionViewCell

@property (nonatomic, strong) ItemModel *model;         //直播信息

@property (nonatomic, strong) UIImageView *bImageView;  //显示直播缩略图

@property (nonatomic, strong) UILabel *title;           //显示房间标题

@property (nonatomic, strong) UILabel *name;            //显示主播名字

@property (nonatomic, strong) UILabel *peopleNum;       //显示在线人数

@end
