//
//  TZTestCell.m
//  BonDay
//
//  Created by 李小光 on 16/4/26.
//  Copyright © 2016年 Bonday. All rights reserved.
//

#import "TZTestCell.h"

@implementation TZTestCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)-30, CGRectGetMinY(_imageView.frame), 30, 30)];
        [_deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        _deleteBtn.layer.cornerRadius = 15;
        _deleteBtn.layer.masksToBounds = YES;
        _deleteBtn.backgroundColor = UIColorWithRGBA(255, 81, 12, 1);
        [self addSubview:_deleteBtn];
        [self bringSubviewToFront:_deleteBtn];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    [_deleteBtn setFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)-30, CGRectGetMinY(_imageView.frame), 30, 30)];
}

@end
