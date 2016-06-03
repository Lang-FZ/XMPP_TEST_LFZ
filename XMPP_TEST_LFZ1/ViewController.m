//
//  ViewController.m
//  XMPP_TEST_LFZ1
//
//  Created by 郎凤招 on 16/5/30.
//  Copyright © 2016年 Lang.FZ. All rights reserved.
// 图片 URL 

#import "ViewController.h"
#import "DetailViewController.h"
#import "ItemModel.h"
#import "VideoCell.h"

#define kItemW ((kScreenW - 20)/2)
#define kItemH ((kScreenW - 20)/2) * [UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height
#define HomeUrlH @"http://www.zhanqi.tv/api/static/live.hots/20-"
#define HomeUrlF @".json?os=1&ver=3.1.1"

@interface ViewController ()

@end

static NSString *registerID = @"cell";

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.data = [[NSMutableArray alloc] init];
    
    [self collectionViewInit];
    
    [self dataInit];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)dataInit {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:[NSString stringWithFormat:@"%@%@%@",HomeUrlH,@1,HomeUrlF] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _data = [[responseObject objectForKey:@"data"] objectForKey:@"rooms"];
        
        [_myCollectionVC.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\n%@",error);
    }];
}

- (void)collectionViewInit {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc] init];
    
    flowL.headerReferenceSize = CGSizeMake(kScreenW, 10);
    
    flowL.itemSize = CGSizeMake(kItemW, kItemH + 20);
    
    flowL.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    flowL.minimumInteritemSpacing = 10;
    
    flowL.minimumLineSpacing = 20;
    
    flowL.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    _myCollectionVC = [[UICollectionViewController alloc] initWithCollectionViewLayout:flowL];
    
    [self initWithRootViewController:_myCollectionVC];
    
    _myCollectionVC.collectionView.backgroundColor = [UIColor whiteColor];
    
    _myCollectionVC.collectionView.pagingEnabled = YES;
    
    _myCollectionVC.collectionView.showsHorizontalScrollIndicator = NO;
    
    self.myCollectionVC.collectionView.delegate = self;
    
    self.myCollectionVC.collectionView.dataSource = self;
    
    [self.myCollectionVC.collectionView registerClass:[VideoCell class] forCellWithReuseIdentifier:registerID];
    
    __weak typeof(self.myCollectionVC.collectionView) weakCollectionView = self.myCollectionVC.collectionView;
    
    _myCollectionVC.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager GET:[NSString stringWithFormat:@"%@%@%@",HomeUrlH,@1,HomeUrlF] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            _data = [[responseObject objectForKey:@"data"] objectForKey:@"rooms"];
            
            [weakCollectionView reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"\n%@",error);
        }];
        
        [weakCollectionView.mj_header endRefreshing];
    }];
    
    [_myCollectionVC.collectionView.mj_header beginRefreshing];
    
    _myCollectionVC.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager GET:[NSString stringWithFormat:@"%@%d%@",HomeUrlH,(int)(weakCollectionView.contentOffset.y / (210 + kItemH * 10 - kScreenH + 64) + 1),HomeUrlF] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            NSMutableArray *newData = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"rooms"]];
            
            NSMutableArray *mydata = [NSMutableArray arrayWithArray:_data];
            
            [mydata addObjectsFromArray:newData];
            
            _data = mydata;
            
            [weakCollectionView reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"\n%@",error);
        }];
        
        [weakCollectionView.mj_footer endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:registerID forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    ItemModel *model = [[ItemModel alloc] init];
    
    [model mj_setKeyValues:_data[indexPath.row]];
    
    cell.model = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoCell *cell = (VideoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    
    detailVC.model = cell.model;
    
    [self pushViewController:detailVC animated:YES];
    
}

//- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
//{
//    // arc下
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
//    {
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = orientation;
//        // 从2开始是因为0 1 两个参数已经被selector和target占用
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
//}

//- (BOOL)shouldAutorotate {
//
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}

@end
