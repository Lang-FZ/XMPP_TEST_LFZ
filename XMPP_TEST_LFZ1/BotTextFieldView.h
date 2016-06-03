//
//  BotTextFieldView.h
//  XMPP_TEST_LFZ1
//
//  Created by 郎凤招 on 16/6/2.
//  Copyright © 2016年 Lang.FZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMSDK.h"

@interface BotTextFieldView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textView;

- (void)animateTextField:(int)offset;

@end
