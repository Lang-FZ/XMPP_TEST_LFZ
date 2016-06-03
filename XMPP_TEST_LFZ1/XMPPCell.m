//
//  XMPPCell.m
//  XMPP_TEST_LFZ1
//
//  Created by 郎凤招 on 16/6/2.
//  Copyright © 2016年 Lang.FZ. All rights reserved.
//

#import "XMPPCell.h"

@implementation XMPPCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {

    self.textLabel.frame = CGRectMake(0, 0, kScreenW, 21);
    
    self.textLabel.numberOfLines = 0;
}

@end
