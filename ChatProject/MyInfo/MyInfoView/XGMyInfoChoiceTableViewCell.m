//
//  XGMyInfoChoiceTableViewCell.m
//  ChatProject
//
//  Created by Duke Li on 2018/9/12.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGMyInfoChoiceTableViewCell.h"

@implementation XGMyInfoChoiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configureView];
    }
    return self;
}

- (void)configureView{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.typeImageView];
    [self.contentView addSubview:self.typeNameLabel];
    [self.contentView addSubview:self.typeArrowImageView];
    [self.contentView addSubview:self.typeLineView];
    
    self.typeImageView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .centerYEqualToView(self.contentView)
    .widthIs(22)
    .heightIs(20);
    
    self.typeArrowImageView.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .widthIs(7)
    .heightIs(12)
    .centerYEqualToView(self.contentView);
    
    self.typeNameLabel.sd_layout
    .leftSpaceToView(self.typeImageView, 10)
    .centerYEqualToView(self.contentView)
    .widthIs(100)
    .heightIs(11);
    
    self.typeLineView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(1)
    .bottomEqualToView(self.contentView);
    
}

- (UIImageView *)typeImageView{
    
    if (_typeImageView == nil) {
        
        _typeImageView = [[UIImageView alloc] init];
    }
    return _typeImageView;
}

- (UILabel *)typeNameLabel{
    
    if (_typeNameLabel == nil) {
        
        _typeNameLabel = [[UILabel alloc] init];
        _typeNameLabel.textColor = UIColorWithRGBA(51, 51, 51, 1);
        _typeNameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _typeNameLabel;
}

- (UIImageView *)typeArrowImageView{
    
    if (_typeArrowImageView == nil) {
        
        _typeArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_moreArrow"]];
    }
    return _typeArrowImageView;
}

- (UIView *)typeLineView{
    
    if (_typeLineView == nil) {
        
        _typeLineView = [[UIView alloc] init];
        _typeLineView.backgroundColor = UIColorWithRGBA(243, 243, 243, 1);
    }
    return _typeLineView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
