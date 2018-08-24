//
//  XGLoginRegisterBaseViewController.m
//  ChatProject
//
//  Created by xiaoguang on 2018/8/4.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGLoginRegisterBaseViewController.h"

@interface XGLoginRegisterBaseViewController ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@end

@implementation XGLoginRegisterBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.loginBackView];
    [self.view addSubview:self.loginTitleLabel];
    [self.view addSubview:self.loginDesLabel];
    
    self.loginBackView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 20)
    .widthIs(40)
    .heightIs(40);
    
    self.loginTitleLabel.sd_layout
    .centerYEqualToView(self.loginBackView)
    .centerXEqualToView(self.view)
    .widthIs(200)
    .heightIs(50);
    
    self.loginDesLabel.sd_layout
    .centerXEqualToView(self.view)
    .bottomSpaceToView(self.view, 20)
    .widthIs(kScreenWidth)
    .heightIs(40);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissMyController) name:kNotificationName_dismissLogin object:nil];
    // Do any additional setup after loading the view.
}
- (void)dismissMyController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImageView *)backgroundImageView{
    
    if (_backgroundImageView == nil) {
        
        _backgroundImageView = [UIImageView imageViewWithImageName:@"Login_background" frame:self.view.bounds];
    }
    return _backgroundImageView;
}

- (UIView *)loginBackView{
    
    if (_loginBackView == nil){
        
        _loginBackView = [[UIView alloc] init];
        UIImageView *backImageView = [UIImageView imageViewWithImageName:@"Login_backIcon" frame:CGRectMake(12, 12, 16, 16)];
        [_loginBackView addSubview:backImageView];
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] init];
        [_loginBackView addGestureRecognizer:backTap];
        [backTap.rac_gestureSignal subscribeNext:^(id x) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
    }
    return _loginBackView;
}
- (UILabel *)loginTitleLabel{
    
    if (_loginTitleLabel == nil){
        
        _loginTitleLabel = [UILabel labelWithFrame:CGRectZero alignment:NSTextAlignmentCenter fontSize:18 textColor:[UIColor whiteColor] string:@"手机登录" systemFont:NO];
    }
    return _loginTitleLabel;
}

- (UILabel *)loginDesLabel{
    
    if (_loginDesLabel == nil){
        
        _loginDesLabel = [UILabel labelWithFrame:CGRectZero alignment:NSTextAlignmentCenter fontSize:14 textColor:[UIColor whiteColor] string:@"登录表示同意《*****服务》" systemFont:YES];
    }
    return _loginDesLabel;
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
