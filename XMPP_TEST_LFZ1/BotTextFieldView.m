//
//  BotTextFieldView.m
//  XMPP_TEST_LFZ1
//
//  Created by 郎凤招 on 16/6/2.
//  Copyright © 2016年 Lang.FZ. All rights reserved.
//

#import "BotTextFieldView.h"

@implementation BotTextFieldView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.textView endEditing:YES];
}

- (void)animateTextField:(int)offset {
    
    [UIView beginAnimations:@"textfieldoffset" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    
    self.textView.frame = CGRectMake(0, kScreenH - offset - 49, kScreenW, 49);
    
    [UIView commitAnimations];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
