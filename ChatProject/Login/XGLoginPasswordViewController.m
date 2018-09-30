//
//  XGLoginPasswordViewController.m
//  ChatProject
//
//  Created by Duke Li on 2018/7/27.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGLoginPasswordViewController.h"
@interface XGLoginPasswordViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *loginHeadView;
@property (nonatomic, strong) UIImageView *loginHeadImageView;
@property (nonatomic, strong) UIImageView *loginBackgroundView;
@property (nonatomic, strong) UIView *loginPhoneView;
@property (nonatomic, strong) UITextField *loginPhoneTextField;
@property (nonatomic, strong) UIView *loginPasswordView;
@property (nonatomic, strong) UITextField *loginPasswordField;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIView *forgetPasswordView;
@property (nonatomic, strong) UIView *registerView;
@property (nonatomic, strong) UIView *otherLoginView;
@end

@implementation XGLoginPasswordViewController

#pragma mark - 生命周期及系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginBackView.hidden = YES;
    self.loginTitleLabel.text = @"登录";
    [self.view addSubview:self.loginHeadView];
    [self.view addSubview:self.loginBackgroundView];
    [self.loginBackgroundView addSubview:self.loginPhoneView];
    [self.loginBackgroundView addSubview:self.loginPasswordView];
    [self.loginBackgroundView addSubview:self.forgetPasswordView];
    [self.loginBackgroundView addSubview:self.registerView];
    [self.loginBackgroundView addSubview:self.loginBtn];
    [self.view addSubview:self.otherLoginView];
    
    self.loginHeadView.sd_layout
    .widthIs(80)
    .heightIs(80)
    .topSpaceToView(self.view, 120)
    .centerXEqualToView(self.view);
    
    self.loginBackgroundView.sd_layout
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .topSpaceToView(self.loginHeadView, -15)
    .heightIs(300);
    
    self.loginPhoneView.sd_layout
    .leftSpaceToView(self.loginBackgroundView, 15)
    .rightSpaceToView(self.loginBackgroundView, 15)
    .topSpaceToView(self.loginBackgroundView, 50)
    .heightIs(50);
    
    self.loginPasswordView.sd_layout
    .leftEqualToView(self.loginPhoneView)
    .rightEqualToView(self.loginPhoneView)
    .topSpaceToView(self.loginPhoneView, 20)
    .heightRatioToView(self.loginPhoneView, 1);
    
    self.forgetPasswordView.sd_layout
    .leftEqualToView(self.loginPhoneView)
    .widthRatioToView(self.loginPhoneView, 0.5)
    .heightIs(20)
    .topSpaceToView(self.loginPasswordView, 10);
    
    self.registerView.sd_layout
    .rightEqualToView(self.loginPhoneView)
    .widthRatioToView(self.loginPhoneView, 0.5)
    .heightRatioToView(self.forgetPasswordView, 1)
    .topEqualToView(self.forgetPasswordView);
    
    self.loginBtn.sd_layout
    .leftEqualToView(self.loginPhoneView)
    .rightEqualToView(self.loginPhoneView)
    .topSpaceToView(self.loginPasswordView, 60)
    .heightIs(40);
    
    self.otherLoginView.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.loginBackgroundView, 30)
    .widthRatioToView(self.loginBackgroundView, 1)
    .heightIs(80);
    
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
- (void)checkGetIdentifyState:(void(^)(BOOL))result{
    
    NSString *phone = [self.loginPhoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    BOOL state = YES;
    if (phone == nil || phone.length == 0 || [phone isEqualToString:@""]){
        
        MyAlertView(@"请输入您的手机号", nil);
        state = NO;
    }
    if (result){
        
        result(state);
    }
}

- (void)checkCanLoginState:(void(^)(BOOL))result{
    
    NSString *phone = [self.loginPhoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *identifyCode = [self.loginPasswordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    BOOL state = YES;
    if (phone == nil || phone.length == 0 || [phone isEqualToString:@""]){
        
        MyAlertView(@"请输入您的手机号", nil);
        state = NO;
        
    }else if (identifyCode == nil || identifyCode.length == 0 || [identifyCode isEqualToString:@""]){
        
        MyAlertView(@"请输入密码", nil);
        state = NO;
    }
    if (result){
        
        result(state);
    }
}
#pragma mark - 通知、代理及数据源方法

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.loginHeadImageView.image = newPhoto;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

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
- (UIView *)loginHeadView{
    
    if (_loginHeadView == nil){
        
        _loginHeadView = [UIView new];
        _loginHeadView.userInteractionEnabled = YES;
        _loginHeadView.backgroundColor = [UIColor whiteColor];
        _loginHeadView.layer.cornerRadius = 40.0;
        _loginHeadView.layer.masksToBounds = YES;
        
        [_loginHeadView addSubview:self.loginHeadImageView];
        self.loginHeadImageView.sd_layout
        .centerXEqualToView(_loginHeadView)
        .centerYEqualToView(_loginHeadView)
        .widthIs(40)
        .heightIs(46);
    }
    return _loginHeadView;
}

- (UIImageView *)loginHeadImageView{
    
    if (!_loginHeadImageView) {
        
        _loginHeadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_defaultHeader"]];
    }
    return _loginHeadImageView;
}

- (UIImageView *)loginBackgroundView{
    
    if (_loginBackgroundView == nil){
        
        CGFloat width = kScreenWidth - 60;
        CGFloat height = 300;
        _loginBackgroundView = [UIImageView new];
        _loginBackgroundView.bounds = CGRectMake(0, 0, width, height);
        _loginBackgroundView.userInteractionEnabled = YES;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(width/2 - 45, 0)];
        [path addQuadCurveToPoint:CGPointMake(width/2 + 45, 0) controlPoint:CGPointMake(width/2, 50)];
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

- (UIImageView *)iconImageViewWithName:(NSString *)name{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    return imageView;
}

- (UIView *)loginPhoneView{
    
    if (_loginPhoneView == nil){
        
        _loginPhoneView = [UIView new];
        [_loginPhoneView addSubview:self.loginPhoneTextField];
        UIView *phoneLine = [self lineView];
        [_loginPhoneView addSubview:phoneLine];
        
        UIImageView *phoneImageView = [self iconImageViewWithName:@"Login_phoneIcon"];
        [_loginPhoneView addSubview:phoneImageView];

        phoneImageView.sd_layout
        .widthIs(16)
        .heightIs(16)
        .centerYEqualToView(self.loginPhoneTextField)
        .leftSpaceToView(_loginPhoneView, 3);
        
        self.loginPhoneTextField.sd_layout
        .leftSpaceToView(phoneImageView, 10)
        .rightSpaceToView(_loginPhoneView, 20)
        .bottomSpaceToView(_loginPhoneView, 3)
        .topEqualToView(_loginPhoneView);
        
        phoneLine.sd_layout
        .leftEqualToView(_loginPhoneView)
        .rightEqualToView(_loginPhoneView)
        .heightIs(1)
        .bottomEqualToView(_loginPhoneView);
    }
    return _loginPhoneView;
}

- (UITextField *)loginPhoneTextField{
    
    if (_loginPhoneTextField == nil){
        
        _loginPhoneTextField = [[UITextField alloc] init];
        _loginPhoneTextField.borderStyle = UITextBorderStyleNone;
        _loginPhoneTextField.placeholder = @"请输入您的手机号码";
        _loginPhoneTextField.delegate = self;
        _loginPhoneTextField.textColor = UIColorWithRGBA(157, 157, 157, 1);
    }
    return _loginPhoneTextField;
}

- (UIView *)loginPasswordView{
    
    if (_loginPasswordView == nil){
        
        _loginPasswordView = [UIView new];
        [_loginPasswordView addSubview:self.loginPasswordField];
        
        UIView *identifyLine = [self lineView];
        [_loginPasswordView addSubview:identifyLine];
        
        UIImageView *passwordImageView = [self iconImageViewWithName:@"Login_passwordIcon"];
        [_loginPasswordView addSubview:passwordImageView];
        
        passwordImageView.sd_layout
        .widthIs(14)
        .heightIs(16)
        .centerYEqualToView(self.loginPasswordField)
        .leftSpaceToView(_loginPasswordView, 3);
        
        self.loginPasswordField.sd_layout
        .leftSpaceToView(passwordImageView, 10)
        .rightSpaceToView(_loginPasswordView, 20)
        .bottomSpaceToView(_loginPasswordView, 3)
        .topEqualToView(_loginPasswordView);
        
        identifyLine.sd_layout
        .leftEqualToView(_loginPasswordView)
        .rightEqualToView(_loginPasswordView)
        .heightIs(1)
        .bottomEqualToView(_loginPasswordView);
    }
    return _loginPasswordView;
}


- (UITextField *)loginPasswordField{
    
    if (_loginPasswordField== nil){
        
        _loginPasswordField = [[UITextField alloc] init];
        _loginPasswordField.borderStyle = UITextBorderStyleNone;
        _loginPasswordField.placeholder = @"请输入密码";
        _loginPasswordField.delegate = self;
        _loginPasswordField.textColor = UIColorWithRGBA(157, 157, 157, 1);
    }
    return _loginPasswordField;
}

- (UIButton *)loginBtn{
    
    if (_loginBtn == nil){
        
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.layer.cornerRadius = 4.0;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn setBackgroundColor:kBtnColor];
        [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
            [self checkCanLoginState:^(BOOL canLoginState) {
                
                if (canLoginState){
                    
                    [self loginClick];
                }
            }];
        }];
    }
    return _loginBtn;
}

- (void)loginClick{
    
    NSDictionary *dic = @{@"phone": self.loginPhoneTextField.text, @"password": self.loginPasswordField.text};
    [MyAFSessionManager requestWithURLString:[kTestApi stringByAppendingString:kLogin_user] parameters:dic requestType:MyRequestTypePost managerType:MyAFSessionManagerTypeJsonWithToken success:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"status"] intValue] == 0){
            
            NSDictionary *result = responseObject[@"result"];
            [MyTools savePersonInfoWithDic:result isRegister:NO headImage:nil];
        }else if (responseObject[@"message"]){
            
            MyAlertView(responseObject[@"message"], nil);
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        MyAlertView(@"网络错误", nil);
    }];
}

- (UIView *)otherLoginView{
    
    if (_otherLoginView == nil){
        
        _otherLoginView = [UIView new];
        UILabel *otherDeslLabel = [UILabel labelWithFrame:CGRectZero alignment:NSTextAlignmentCenter fontSize:13 textColor:[UIColor whiteColor] string:@"其它方式" systemFont:YES];
        [_otherLoginView addSubview:otherDeslLabel];
        
        UIImageView *otherWayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_elseWay"]];
        otherWayImageView.layer.cornerRadius = 20;
        otherWayImageView.layer.masksToBounds = YES;
        otherWayImageView.userInteractionEnabled = YES;
        [_otherLoginView addSubview:otherWayImageView];
        UITapGestureRecognizer *loginTap = [[UITapGestureRecognizer alloc] init];
        [otherWayImageView addGestureRecognizer:loginTap];
        [loginTap.rac_gestureSignal subscribeNext:^(id x) {
            
            [self presentViewController:self.mainLoginController animated:YES completion:nil];
        }];
        
        otherDeslLabel.sd_layout
        .centerXEqualToView(_otherLoginView)
        .topEqualToView(_otherLoginView)
        .widthIs(100)
        .heightIs(20);
        
        otherWayImageView.sd_layout
        .centerXEqualToView(_otherLoginView)
        .topSpaceToView(otherDeslLabel, 10)
        .widthIs(50)
        .heightIs(50);
    }
    return _otherLoginView;
}

- (UIView *)forgetPasswordView{
    
    if (_forgetPasswordView == nil){
        
        _forgetPasswordView = [UIView new];
        UILabel *forgetDesLabel = [UILabel labelWithFrame:CGRectZero alignment:NSTextAlignmentLeft fontSize:13 textColor:[UIColor blackColor] string:@"忘记密码" systemFont:YES];
        [_forgetPasswordView addSubview:forgetDesLabel];
        UITapGestureRecognizer *forgetTap = [[UITapGestureRecognizer alloc] init];
        [_forgetPasswordView addGestureRecognizer:forgetTap];
        [forgetTap.rac_gestureSignal subscribeNext:^(id x) {
            
            [self presentViewController:self.mainForgetController animated:YES completion:nil];
            
        }];
        forgetDesLabel.sd_layout
        .leftSpaceToView(_forgetPasswordView, 3)
        .topSpaceToView(_forgetPasswordView, 3)
        .rightSpaceToView(_forgetPasswordView, 3)
        .heightIs(20);
    }
    return _forgetPasswordView;
}

- (UIView *)registerView{
    
    if (_registerView == nil){
        
        _registerView = [UIView new];
        UILabel *registerDesLabel = [UILabel labelWithFrame:CGRectZero alignment:NSTextAlignmentRight fontSize:13 textColor:kBtnColor string:@"新用户注册" systemFont:YES];
        [_registerView addSubview:registerDesLabel];
        registerDesLabel.sd_layout
        .leftSpaceToView(_registerView, 3)
        .topSpaceToView(_registerView, 3)
        .rightSpaceToView(_registerView, 3)
        .heightIs(20);
        
        UITapGestureRecognizer *registerTap = [[UITapGestureRecognizer alloc] init];
        [_registerView addGestureRecognizer:registerTap];
        [registerTap.rac_gestureSignal subscribeNext:^(id x) {
            
            XGMainRegisterViewController *registerController = [[XGMainRegisterViewController alloc] init];
            [self presentViewController:registerController animated:YES completion:nil];
        }];
    }
    return _registerView;
}

- (XGMainLoginViewController *)mainLoginController{
    
    if (_mainLoginController == nil){
        
        _mainLoginController = [[XGMainLoginViewController alloc] init];
    }
    return _mainLoginController;
}
- (XGMainLoginViewController *)mainForgetController{
    
    if (_mainForgetController == nil){
        
        _mainForgetController = [[XGMainLoginViewController alloc] init];
        _mainForgetController.forgetPassword = YES;
    }
    return _mainForgetController;
}
@end
