//
//  XGSearchFriendResultTableViewCell.m
//  ChatProject
//
//  Created by Duke Li on 2018/8/30.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGSearchFriendResultTableViewCell.h"

@implementation XGSearchFriendResultTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _ivAva = [UIImageView new];
        _ivAva.clipsToBounds = YES;
        _ivAva.layer.cornerRadius = 5.f;
        _lblName = [UILabel new];
        
        [self addSubview:_ivAva];
        [self addSubview:_lblName];
        [self addSubview:self.addBtn];
        
        [_ivAva setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_lblName setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_ivAva(56)]"
                                                                     options:kNilOptions
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_ivAva)]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_ivAva
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:0]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_lblName(20)]"
                                                                     options:kNilOptions
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_lblName)]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_lblName
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:0]];
        
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"H:|-15-[_ivAva(56)]-8-[_lblName]-16-|"
                              options:kNilOptions
                              metrics:nil
                              views:NSDictionaryOfVariableBindings(_ivAva, _lblName)]];
        
        self.addBtn.sd_layout
        .rightSpaceToView(self, 15)
        .centerYEqualToView(self)
        .widthIs(80)
        .heightIs(30);
    }
    
    return self;
}

- (UIButton *)addBtn{
    
    if (_addBtn == nil) {
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setTitle:@"添加好友" forState:UIControlStateNormal];
        _addBtn.layer.cornerRadius = 3.0;
        _addBtn.layer.masksToBounds = YES;
        _addBtn.backgroundColor = UIColorWithRGBA(63, 147, 238, 1);
        [_addBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _addBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
