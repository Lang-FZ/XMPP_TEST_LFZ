//
//  ViewController.h
//  XMPP_TEST_LFZ1
//
//  Created by 郎凤招 on 16/5/30.
//  Copyright © 2016年 Lang.FZ. All rights reserved.
//  

#import <UIKit/UIKit.h>

@interface ViewController : UINavigationController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionViewController *myCollectionVC;

@property(nonatomic, strong) NSMutableArray *data;

@end

