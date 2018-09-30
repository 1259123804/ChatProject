//
//  XGReplacePasswordViewController.m
//  ChatProject
//
//  Created by Duke Li on 2018/7/27.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGReplacePasswordViewController.h"

@interface XGReplacePasswordViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *loginBackgroundView;
@property (nonatomic, strong) UIView *loginPasswordView;
@property (nonatomic, strong) UITextField *loginPasswordTextField;
@property (nonatomic, strong) UIButton *loginBtn;
@end

@implementation XGReplacePasswordViewController


#pragma mark - 生命周期及系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginTitleLabel.text = @"找回密码";
    [self.view addSubview:self.loginBackgroundView];
    [self.loginBackgroundView addSubview:self.loginPasswordView];
    [self.loginBackgroundView addSubview:self.loginBtn];
    
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
        layer.cornerRadius = 6.0;
        layer.masksToBounds = YES;
        [_loginBackgroundView.layer addSublayer:layer];
        
    }
    return _loginBackgroundView;
}
- (UIView *)lineView{
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = UIColorWithRGBA(127, 127, 127, 1);
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
        _loginPasswordTextField.textColor = UIColorWithRGBA(157, 157, 157, 1);
    }
    return _loginPasswordTextField;
}

- (UIButton *)loginBtn{
    
    if (_loginBtn == nil){
        
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.layer.cornerRadius = 4.0;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn setBackgroundColor:kBtnColor];
        [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
            [self checkCanLoginState:^(BOOL canLoginState) {
                
                if (canLoginState){
                    
                    NSDictionary *params = @{@"password": self.loginPasswordTextField.text};
                    [MyAFSessionManager requestWithURLString:[kTestApi stringByAppendingString:kForgotPassword_reset] parameters:params requestType:MyRequestTypePost managerType:MyAFSessionManagerTypeJsonWithToken success:^(id  _Nullable responseObject) {
                        
                        if ([responseObject[@"status"] intValue] == 0) {
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_dismissLogin object:nil];
                            MyAlertView(responseObject[@"result"][@"msg"], nil);
                            
                        }else{
                            
                            MyAlertView(@"修改失败，请重试", nil);
                        }
                        
                    } failure:^(NSError * _Nonnull error) {
                        
                        MyAlertView(@"网络错误", nil);
                    }];
                }
            }];
        }];
    }
    return _loginBtn;
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
