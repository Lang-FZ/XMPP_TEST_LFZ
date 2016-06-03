//
//  VideoCell.m
//  XMPP_TEST_LFZ1
//
//  Created by 郎凤招 on 16/6/1.
//  Copyright © 2016年 Lang.FZ. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        
        _bImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 20)];
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 40, self.bounds.size.width, 20)];
        _name = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 20, self.bounds.size.width - 60, 20)];
        _peopleNum = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 50, self.bounds.size.height - 20, 50, 20)];
        
        _title.font = [UIFont systemFontOfSize:13];
        _name.font = [UIFont systemFontOfSize:11];
        _peopleNum.font = [UIFont systemFontOfSize:11];
        
        _title.textColor = [UIColor whiteColor];
        _title.backgroundColor = [UIColor blackColor];
        _title.alpha = 0.5;
        _peopleNum.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:_bImageView];
        [self addSubview:_title];
        [self addSubview:_name];
        [self addSubview:_peopleNum];
    }
    
    return self;
}

- (void)setModel:(ItemModel *)model {

    _model = model;
    
    [_bImageView sd_setImageWithURL:[NSURL URLWithString:_model.bpic]];
    _title.text = _model.title;
    _name.text = _model.nickname;
    _peopleNum.text = (_model.online.intValue > 10000) ? [NSString stringWithFormat:@"%.1f万",(float)_model.online.intValue/10000] : [NSString stringWithFormat:@"%@",_model.online];
}

@end
