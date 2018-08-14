//
//  XGReplacePasswordViewController.m
//  ChatProject
//
//  Created by Duke Li on 2018/7/27.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGReplacePasswordViewController.h"

@interface XGReplacePasswordViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *loginBackView;
@property (nonatomic, strong) UILabel *loginTitleLabel;
@property (nonatomic, strong) UIImageView *loginBackgroundView;
@property (nonatomic, strong) UIView *loginPasswordView;
@property (nonatomic, strong) UITextField *loginPasswordTextField;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UILabel *loginDesLabel;
@end

@implementation XGReplacePasswordViewController


#pragma mark - 生命周期及系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.loginBackView];
    [self.view addSubview:self.loginTitleLabel];
    [self.view addSubview:self.loginBackgroundView];
    [self.loginBackgroundView addSubview:self.loginPasswordView];
    [self.loginBackgroundView addSubview:self.loginBtn];
    [self.view addSubview:self.loginDesLabel];
    
    self.loginBackView.sd_layout
    .leftSpaceToView(self.view, 20)
    .topSpaceToView(self.view, 60)
    .widthIs(30)
    .heightIs(30);
    
    self.loginTitleLabel.sd_layout
    .centerYEqualToView(self.loginBackView)
    .centerXEqualToView(self.view)
    .widthIs(200)
    .heightIs(50);
    
    self.loginBackgroundView.sd_layout
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .topSpaceToView(self.view, 150)
    .heightIs(270);
    
    self.loginPasswordView.sd_layout
    .leftSpaceToView(self.loginBackgroundView, 15)
    .rightSpaceToView(self.loginBackgroundView, 15)
    .topSpaceToView(self.loginBackgroundView, 30)
    .heightIs(40);
    
    self.loginBtn.sd_layout
    .leftEqualToView(self.loginPasswordView)
    .rightEqualToView(self.loginPasswordView)
    .topSpaceToView(self.loginPasswordView, 30)
    .heightIs(40);
    
    self.loginDesLabel.sd_layout
    .centerXEqualToView(self.view)
    .bottomSpaceToView(self.view, 50)
    .widthIs(kScreenWidth)
    .heightIs(40);
    
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 私有方法

- (void)checkCanLoginState:(void(^)(BOOL))result{
    
    NSString *password = [self.loginPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    BOOL state = YES;
    if (password == nil || password.length < 6 || [password isEqualToString:@""]){
        
        MyAlertView(@"请输入不少于6位密码", nil);
        state = NO;
        
    }
    if (result){
        
        result(state);
    }
}

#pragma mark - 通知、代理及数据源方法

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}

#pragma mark - 视图及控制器创建方法
- (UIView *)loginBackView{
    
    if (_loginBackView == nil){
        
        _loginBackView = [[UIView alloc] init];
        _loginBackView.backgroundColor = [UIColor redColor];
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] init];
        [_loginBackView addGestureRecognizer:backTap];
        [backTap.rac_gestureSignal subscribeNext:^(id x) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
    }
    return _loginBackView;
}

- (UIImageView *)loginBackgroundView{
    
    if (_loginBackgroundView == nil){
        
        CGFloat width = kScreenWidth - 60;
        CGFloat height = 200;
        _loginBackgroundView = [UIImageView new];
        _loginBackgroundView.bounds = CGRectMake(0, 0, width, height);
        _loginBackgroundView.userInteractionEnabled = YES;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(width, 0)];
        [path addLineToPoint:CGPointMake(width, height)];
        [path addLineToPoint:CGPointMake(0, height)];
        [path addLineToPoint:CGPointMake(0, 0)];
        [path closePath];
        path.lineJoinStyle = kCGLineJoinRound;
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        layer.fillColor = [UIColor whiteColor].CGColor;
        layer.frame = _loginBackgroundView.bounds;
        [_loginBackgroundView.layer addSublayer:layer];
        
    }
    return _loginBackgroundView;
}
- (UIView *)lineView{
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = UIColorWithRGBA(150, 150, 150, 1);
    return lineView;
}

- (UIView *)loginPasswordView{
    
    if (_loginPasswordView == nil){
        
        _loginPasswordView = [UIView new];
        [_loginPasswordView addSubview:self.loginPasswordTextField];
        UIView *phoneLine = [self lineView];
        [_loginPasswordView addSubview:phoneLine];
        
        self.loginPasswordTextField.sd_layout
        .leftSpaceToView(_loginPasswordView , 20)
        .rightSpaceToView(_loginPasswordView, 20)
        .bottomSpaceToView(_loginPasswordView, 3)
        .topEqualToView(_loginPasswordView);
        
        phoneLine.sd_layout
        .leftEqualToView(_loginPasswordView)
        .rightEqualToView(_loginPasswordView)
        .heightIs(1)
        .bottomEqualToView(_loginPasswordView);
    }
    return _loginPasswordView;
}

- (UITextField *)loginPasswordTextField{
    
    if (_loginPasswordTextField == nil){
        
        _loginPasswordTextField = [[UITextField alloc] init];
        _loginPasswordTextField.borderStyle = UITextBorderStyleNone;
        _loginPasswordTextField.placeholder = @"设置不少于6位的密码";
        _loginPasswordTextField.delegate = self;
    }
    return _loginPasswordTextField;
}



- (UIButton *)loginBtn{
    
    if (_loginBtn == nil){
        
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:[UIColor redColor]];
        [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
            [self checkCanLoginState:^(BOOL canLoginState) {
                
                if (canLoginState){
                    
                    MyAlertView(@"登录成功", nil);
                }
            }];
        }];
    }
    return _loginBtn;
}

- (UILabel *)loginTitleLabel{
    
    if (_loginTitleLabel == nil){
        
        _loginTitleLabel = [UILabel labelWithFrame:CGRectZero alignment:NSTextAlignmentCenter fontSize:18 textColor:[UIColor whiteColor] string:@"找回密码" systemFont:NO];
    }
    return _loginTitleLabel;
}

- (UILabel *)loginDesLabel{
    
    if (_loginDesLabel == nil){
        
        _loginDesLabel = [UILabel labelWithFrame:CGRectZero alignment:NSTextAlignmentCenter fontSize:14 textColor:[UIColor grayColor] string:@"登录表示同意《*****服务》" systemFont:YES];
    }
    return _loginDesLabel;
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
