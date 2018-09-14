//
//  XGMyInfoHeadTableViewCell.m
//  ChatProject
//
//  Created by Duke Li on 2018/9/12.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGMyInfoHeadTableViewCell.h"
#import "XGMainLoginViewController.h"
@implementation XGMyInfoHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configureViews];
    }
    return self;
}

- (void)configureViews{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.idLabel];
    [self.contentView addSubview:self.mainView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorWithRGBA(233, 233, 233, 1);
    [self.contentView addSubview:lineView];

    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = UIColorWithRGBA(233, 233, 233, 1);
    [self.contentView addSubview:topLineView];
    
    UIView *bottomView = [[UIView alloc] init];
    [self.contentView addSubview:bottomView];
    
    topLineView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .heightIs(5);
    
    self.headImageView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(topLineView, 10)
    .widthIs(60)
    .heightIs(60);
    
    self.mainView.sd_layout
    .centerYEqualToView(self.headImageView)
    .rightSpaceToView(self.contentView, 10)
    .widthIs(50)
    .heightIs(30);
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.headImageView, 10)
    .topSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.mainView, 5)
    .heightIs(20);
    
    self.idLabel.sd_layout
    .leftSpaceToView(self.headImageView, 10)
    .topSpaceToView(self.nameLabel, 0)
    .rightSpaceToView(self.mainView, 5)
    .heightIs(20);
    
    lineView.sd_layout
    .leftEqualToView(self.contentView)
    .topSpaceToView(self.headImageView, 10)
    .rightEqualToView(self.contentView)
    .heightIs(1);
    
    bottomView.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(lineView)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView);
    
    UIView *dynamicView = [self partViewWithName:@"动态" location:0];
    UIView *watchView = [self partViewWithName:@"关注" location:1];
    UIView *fansView = [self partViewWithName:@"粉丝" location:2];
    [bottomView addSubview:dynamicView];
    [bottomView addSubview:watchView];
    [bottomView addSubview:fansView];
    
}

- (UILabel *)nameLabel{
    
    if (_nameLabel == nil) {
        
        _nameLabel = [UILabel new];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
        _nameLabel.textColor = UIColorWithRGBA(51, 51, 51, 1);
        _nameLabel.text = @"123";
    }
    return _nameLabel;
}

- (UILabel *)idLabel{
    
    if (_idLabel == nil) {
        
        _idLabel = [UILabel new];
        _idLabel.textAlignment = NSTextAlignmentLeft;
        _idLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
        _idLabel.textColor = UIColorWithRGBA(51, 51, 51, 1);
        _idLabel.text = @"123";
    }
    return _idLabel;
}

- (UIView *)mainView{
    
    if (_mainView == nil) {
        
        _mainView = [[UIView alloc] init];
        UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [quitBtn setTitle:@"退出" forState:UIControlStateNormal];
        [quitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        quitBtn.frame = CGRectMake(0, 0, 50, 30);
        [_mainView addSubview:quitBtn];
        [quitBtn addTarget:self action:@selector(quitClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _mainView;
}

- (void)quitClick{
    
    [MyTools clearUserInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_logout object:nil];
}

- (UIImageView *)headImageView{
    
    if (_headImageView == nil) {
        
        _headImageView = [[UIImageView alloc] init];
       // _headImageView.backgroundColor = [UIColor redColor];
    }
    return _headImageView;
}

- (UIView *)partViewWithName:(NSString *)name location:(NSInteger)location{
    
    CGFloat width = (kScreenWidth - 2)/3;
    UIView *partView = [[UIView alloc] initWithFrame:CGRectMake((width + 1) *location, 0, width, 50)];
    UILabel *desLabel = [self choiceDesLabelWithText:name];
    [partView addSubview:desLabel];
    
    if (location == 0) {
        
        [partView addSubview:self.dynamicLabel];
        
    }else if (location == 1){
        
        [partView addSubview:self.watchLabel];
        
    }else if (location == 2){
        
        [partView addSubview:self.fansLabel];

    }
    return partView;
}

- (UILabel *)dynamicLabel{
    
    if (_dynamicLabel == nil) {
        
        _dynamicLabel = [self choiceLabel];
    }
    return _dynamicLabel;
}

- (UILabel *)fansLabel{
    
    if (_fansLabel == nil) {
        
        _fansLabel = [self choiceLabel];
    }
    return _fansLabel;
}

- (UILabel *)watchLabel{
    
    if (_watchLabel == nil) {
        
        _watchLabel = [self choiceLabel];
    }
    return _watchLabel;
}

- (UILabel *)choiceLabel{
    
    CGFloat width = (kScreenWidth - 2)/3;
    UILabel *choiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, width - 10, 20)];
    choiceLabel.textAlignment = NSTextAlignmentCenter;
    choiceLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    choiceLabel.textColor = UIColorWithRGBA(51, 51, 51, 1);
    choiceLabel.text = @"0";
    return choiceLabel;
}

- (UILabel *)choiceDesLabelWithText:(NSString *)text{
    CGFloat width = (kScreenWidth - 2)/3;
    UILabel *choiceDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, width - 10, 20)];
    choiceDesLabel.textAlignment = NSTextAlignmentCenter;
    choiceDesLabel.font = [UIFont systemFontOfSize:10];
    choiceDesLabel.textColor = UIColorWithRGBA(153, 153, 153, 1);
    choiceDesLabel.text = text;
    return choiceDesLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
