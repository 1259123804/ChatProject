//
//  XGMainChatViewController.m
//  ChatProject
//
//  Created by Duke Li on 2018/7/26.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGMainChatViewController.h"

@interface XGMainChatViewController ()
@property (nonatomic, strong) UIView *addSuspendView;
@property (nonatomic, strong) UIView *addSuspendBackView;
@end

@implementation XGMainChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navBarView addSubview:self.addImageView];
    [self.navBarView addSubview:self.headerImageView];
    // Do any additional setup after loading the view.
}

- (UIView *)addImageView{
    
    if (_addImageView == nil) {
        
        _addImageView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 51, kNavBarHeight - 43, 40, 40)];
        UIImageView *addView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatList_addIcon"]];
        addView.frame = CGRectMake(12, 12, 16, 16);
        [_addImageView addSubview:addView];
        
        UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] init];
        [_addImageView addGestureRecognizer:addTap];
        [[addTap rac_gestureSignal] subscribeNext:^(id x) {
            
            [self.view addSubview:self.addSuspendBackView];
        }];
    }
    return _addImageView;
}

- (UIImageView *)headerImageView{
    
    if (_headerImageView == nil) {
        
        _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
        _headerImageView.frame = CGRectMake(10, CGRectGetMidY(self.navTitleLabel.frame) - 20 , 40, 40);
    }
    return _headerImageView;
}

- (UIView *)addSuspendBackView{
    
    if (_addSuspendBackView == nil) {
        
        _addSuspendBackView = [[UIView alloc] initWithFrame:self.view.bounds];
        _addSuspendBackView.backgroundColor = [UIColor clearColor];
        [_addSuspendBackView addSubview:self.addSuspendView];
        
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] init];
        [_addSuspendBackView addGestureRecognizer:backTap];
        [[backTap rac_gestureSignal] subscribeNext:^(id x) {
           
            [self.addSuspendBackView removeFromSuperview];
        }];
    }
    return _addSuspendBackView;
}

- (UIView *)addSuspendView{
    
    if (_addSuspendView == nil) {
        
        _addSuspendView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 103, CGRectGetMaxY(self.addImageView.frame) + 5, 92, 68)];
        _addSuspendView.backgroundColor = [UIColor whiteColor];
        _addSuspendView.layer.shadowOpacity = 1.0;
        _addSuspendView.layer.shadowColor = UIColorWithRGBA(0, 0, 0, 0.3).CGColor;
        _addSuspendView.layer.shadowOffset = CGSizeMake(0, 0);
        _addSuspendView.layer.shadowRadius = 8.0;
        
        UILabel *firstLabel = [self addChoiceLabelWithTitle:@"添加好友"];
        UILabel *secondLabel = [self addChoiceLabelWithTitle:@"扫一扫"];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, 92, 1)];
        lineView.backgroundColor = [UIColor blackColor];
        [_addSuspendView addSubview:lineView];
        
        [_addSuspendView addSubview:firstLabel];
        [_addSuspendView addSubview:secondLabel];
    }
    return _addSuspendView;
}
- (UILabel *)addChoiceLabelWithTitle:(NSString *)title{
  
    CGRect rect = CGRectMake(0, [title isEqualToString:@"添加好友"] ? 0 : 35, 92, 33);
    UILabel *choiceLabel = [UILabel labelWithFrame:rect alignment:NSTextAlignmentCenter fontSize:13 textColor:UIColorWithRGBA(51, 51, 51, 1) string:title systemFont:NO];
    choiceLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *choiceTap = [[UITapGestureRecognizer alloc] init];
    [choiceLabel addGestureRecognizer:choiceTap];
    [[choiceTap rac_gestureSignal] subscribeNext:^(id x) {
        
        MyAlertView(title, nil);
    }];
    return choiceLabel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
