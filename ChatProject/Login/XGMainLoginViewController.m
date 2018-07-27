//
//  XGMainLoginViewController.m
//  ChatProject
//
//  Created by Duke Li on 2018/7/26.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGMainLoginViewController.h"
#import <Photos/Photos.h>
#import "XGReplacePasswordViewController.h"
@interface XGMainLoginViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIView *loginBackView;
@property (nonatomic, strong) UILabel *loginTitleLabel;
@property (nonatomic, strong) UIImageView *loginHeadImageView;
@property (nonatomic, strong) UIImageView *loginBackgroundView;
@property (nonatomic, strong) UIView *loginCountryCodeView;
@property (nonatomic, strong) UILabel *loginCountryCodeLabel;
@property (nonatomic, strong) UIView *loginPhoneView;
@property (nonatomic, strong) UITextField *loginPhoneTextField;
@property (nonatomic, strong) UIView *loginIdentifyView;
@property (nonatomic, strong) UITextField *loginIdentifyTextField;
@property (nonatomic, strong) UILabel *loginTimerLabel;
@property (nonatomic, strong) NSTimer *loginTimer;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UILabel *loginDesLabel;
@property (nonatomic, assign) NSInteger loginIdentifyTime;
@end

@implementation XGMainLoginViewController

#pragma mark - 生命周期及系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.loginBackView];
    [self.view addSubview:self.loginTitleLabel];
    [self.view addSubview:self.loginHeadImageView];
    [self.view addSubview:self.loginBackgroundView];
    [self.loginBackgroundView addSubview:self.loginCountryCodeView];
    [self.loginBackgroundView addSubview:self.loginPhoneView];
    [self.loginBackgroundView addSubview:self.loginIdentifyView];
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
    
    self.loginHeadImageView.sd_layout
    .widthIs(66)
    .heightIs(66)
    .topSpaceToView(self.view, 150)
    .centerXEqualToView(self.view);
    
    self.loginBackgroundView.sd_layout
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .topSpaceToView(self.loginHeadImageView, -10)
    .heightIs(270);
    
    self.loginCountryCodeView.sd_layout
    .leftSpaceToView(self.loginBackgroundView, 15)
    .rightSpaceToView(self.loginBackgroundView, 15)
    .topSpaceToView(self.loginBackgroundView, 30)
    .heightIs(40);
    
    self.loginPhoneView.sd_layout
    .leftEqualToView(self.loginCountryCodeView)
    .rightEqualToView(self.loginCountryCodeView)
    .topSpaceToView(self.loginCountryCodeView, 15)
    .heightRatioToView(self.loginCountryCodeView, 1);
    
    self.loginIdentifyView.sd_layout
    .leftEqualToView(self.loginCountryCodeView)
    .rightEqualToView(self.loginCountryCodeView)
    .topSpaceToView(self.loginPhoneView, 15)
    .heightRatioToView(self.loginCountryCodeView, 1);
    
    self.loginBtn.sd_layout
    .leftEqualToView(self.loginCountryCodeView)
    .rightEqualToView(self.loginCountryCodeView)
    .topSpaceToView(self.loginIdentifyView, 30)
    .heightIs(40);
    
    self.loginDesLabel.sd_layout
    .centerXEqualToView(self.view)
    .bottomSpaceToView(self.view, 50)
    .widthIs(kScreenWidth)
    .heightIs(40);
    
    if (self.forgetPassword){
        
        self.loginTitleLabel.text = @"找回密码";
        [self.loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
        self.loginDesLabel.hidden = YES;
    }

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
    NSString *identifyCode = [self.loginIdentifyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    BOOL state = YES;
    if (phone == nil || phone.length == 0 || [phone isEqualToString:@""]){
        
        MyAlertView(@"请输入您的手机号", nil);
        state = NO;
        
    }else if (identifyCode == nil || identifyCode.length == 0 || [identifyCode isEqualToString:@""]){
        
        MyAlertView(@"请输入验证码", nil);
        state = NO;
    }
    if (result){
        
        result(state);
    }
}


- (void)changeTimerLabelState{
    
    self.loginIdentifyTime --;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.loginTimerLabel.text = self.loginIdentifyTime <= 0 ? @"获取" : [NSString stringWithFormat:@"%ld", self.loginIdentifyTime];
    });
    if (self.loginIdentifyTime <= 0){
        
        if (self.loginTimer){
            
            [self.loginTimer invalidate];
            self.loginTimer = nil;
        }
        self.loginTimerLabel.enabled = YES;
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

- (UIImageView *)loginHeadImageView{
    
    if (_loginHeadImageView == nil){
        
        _loginHeadImageView = [[UIImageView alloc] init];
        _loginHeadImageView.userInteractionEnabled = YES;
        _loginHeadImageView.backgroundColor = [UIColor redColor];
        _loginHeadImageView.layer.cornerRadius = 33.0;
        _loginHeadImageView.layer.masksToBounds = YES;
    }
    return _loginHeadImageView;
}

- (UIImagePickerController *)imageControllerWithType:(UIImagePickerControllerSourceType)type{
    
    UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
    imageController.delegate = self;
    imageController.allowsEditing = YES;
    imageController.sourceType = type;
    return imageController;
}

- (UIImageView *)loginBackgroundView{
    
    if (_loginBackgroundView == nil){
        
        CGFloat width = kScreenWidth - 60;
        CGFloat height = 270;
        _loginBackgroundView = [UIImageView new];
        _loginBackgroundView.bounds = CGRectMake(0, 0, width, height);
        _loginBackgroundView.userInteractionEnabled = YES;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(width/2 - 35, 0)];
        [path addQuadCurveToPoint:CGPointMake(width/2 + 35, 0) controlPoint:CGPointMake(width/2, 35)];
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

- (UIView *)loginCountryCodeView{
    
    if (_loginCountryCodeView == nil){
        
        _loginCountryCodeView = [UIView new];
        [_loginCountryCodeView addSubview:self.loginCountryCodeLabel];
        UIView *codeLine = [self lineView];
        [_loginCountryCodeView addSubview:codeLine];
        
        self.loginCountryCodeLabel.sd_layout
        .leftSpaceToView(_loginCountryCodeView , 3)
        .rightSpaceToView(_loginCountryCodeView, 20)
        .bottomSpaceToView(_loginCountryCodeView, 3)
        .topEqualToView(_loginCountryCodeView);
        
        codeLine.sd_layout
        .leftEqualToView(_loginCountryCodeView)
        .rightEqualToView(_loginCountryCodeView)
        .heightIs(1)
        .bottomEqualToView(_loginCountryCodeView);
    }
    
    return _loginCountryCodeView;
}

- (UILabel *)loginCountryCodeLabel{
    
    if (_loginCountryCodeLabel == nil){
        
        _loginCountryCodeLabel = [UILabel labelWithFrame:CGRectZero alignment:NSTextAlignmentLeft fontSize:14 textColor:UIColorWithRGBA(159, 159, 159, 1) string:@"中国（+86）" systemFont:YES];
    }
    return _loginCountryCodeLabel;
}

- (UIView *)lineView{
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = UIColorWithRGBA(150, 150, 150, 1);
    return lineView;
}

- (UIView *)loginPhoneView{
    
    if (_loginPhoneView == nil){
        
        _loginPhoneView = [UIView new];
        [_loginPhoneView addSubview:self.loginPhoneTextField];
        UIView *phoneLine = [self lineView];
        [_loginPhoneView addSubview:phoneLine];
        
        self.loginPhoneTextField.sd_layout
        .leftSpaceToView(_loginPhoneView , 3)
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
    }
    return _loginPhoneTextField;
}

- (UIView *)loginIdentifyView{
    
    if (_loginIdentifyView == nil){
        
        _loginIdentifyView = [UIView new];
        [_loginIdentifyView addSubview:self.loginIdentifyTextField];
        UIView *identifyLine = [self lineView];
        [_loginIdentifyView addSubview:identifyLine];
        [_loginIdentifyView addSubview:self.loginTimerLabel];
        
        self.loginIdentifyTextField.sd_layout
        .leftSpaceToView(_loginIdentifyView , 3)
        .rightSpaceToView(_loginIdentifyView, 40)
        .bottomSpaceToView(_loginIdentifyView, 3)
        .topEqualToView(_loginIdentifyView);
        
        identifyLine.sd_layout
        .leftEqualToView(_loginIdentifyView)
        .rightEqualToView(_loginIdentifyView)
        .heightIs(1)
        .bottomEqualToView(_loginIdentifyView);
        
        self.loginTimerLabel.sd_layout
        .rightEqualToView(_loginIdentifyView)
        .centerYEqualToView(self.loginIdentifyTextField)
        .widthIs(40)
        .heightIs(25);
    }
    return _loginIdentifyView;
}

- (UILabel *)loginTimerLabel{
    
    if (_loginTimerLabel == nil){
        
        _loginTimerLabel = [UILabel labelWithFrame:CGRectZero alignment:NSTextAlignmentCenter fontSize:12 textColor:UIColorWithRGBA(150, 150, 150, 1) string:@"获取" systemFont:YES];
        _loginTimerLabel.layer.borderColor = UIColorWithRGBA(150, 150, 150, 1).CGColor;
        _loginTimerLabel.layer.borderWidth = 1.0;
        _loginTimerLabel.layer.cornerRadius = 2.0;
        _loginTimerLabel.layer.masksToBounds = YES;
        _loginTimerLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *getIdentifyTap = [[UITapGestureRecognizer alloc] init];
        [_loginTimerLabel addGestureRecognizer:getIdentifyTap];
        [getIdentifyTap.rac_gestureSignal subscribeNext:^(id x) {
            
            self.loginTimerLabel.enabled = NO;
            [self checkGetIdentifyState:^(BOOL canState) {
                
                if (canState){
                    
                    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.loginPhoneTextField.text zone:@"86" template:nil result:^(NSError *error) {
                        
                        if (!error){
                            
                            MyAlertView(@"发送成功", nil);
                            [[NSRunLoop currentRunLoop] addTimer:self.loginTimer forMode:NSRunLoopCommonModes];
                            
                        }else{
                            
                            self.loginTimerLabel.enabled = YES;
                            MyAlertView(@"发送失败,请重新获取", nil);
                        }
                    }];
                }
            }];
        }];
    }
    return _loginTimerLabel;
}

- (NSTimer *)loginTimer{
    
    if (_loginTimer == nil){
        
        self.loginIdentifyTime = 60;
        _loginTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTimerLabelState) userInfo:nil repeats:YES];
    }
    return _loginTimer;
}

- (UITextField *)loginIdentifyTextField{
    
    if (_loginIdentifyTextField == nil){
        
        _loginIdentifyTextField = [[UITextField alloc] init];
        _loginIdentifyTextField.borderStyle = UITextBorderStyleNone;
        _loginIdentifyTextField.placeholder = @"请输入验证码";
        _loginIdentifyTextField.delegate = self;
    }
    return _loginIdentifyTextField;
}

- (UIButton *)loginBtn{
    
    if (_loginBtn == nil){
        
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:[UIColor redColor]];
        [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
            [self checkCanLoginState:^(BOOL canLoginState) {
                
                if (canLoginState){
                    [SMSSDK commitVerificationCode:self.loginIdentifyTextField.text phoneNumber:self.loginPhoneTextField.text zone:@"86" result:^(NSError *error) {
                        
                        NSLog(@"%@", error.userInfo[@"description"]);
                        if (error){
                            
                            MyAlertView(@"验证失败", nil);
                            
                        }else{
                            
                            MyAlertView(@"验证成功", nil);
                            if (self.forgetPassword){
                                
                                XGReplacePasswordViewController *replacePasswordController = [[XGReplacePasswordViewController alloc] init];
                                [self presentViewController:replacePasswordController animated:YES completion:nil];
                            }else{
                                
                                //直接登录
                                [self dismissViewControllerAnimated:YES completion:nil];
                            }
                        }
                    }];
                }
            }];
        }];
    }
    return _loginBtn;
}

- (UILabel *)loginTitleLabel{
    
    if (_loginTitleLabel == nil){
        
        _loginTitleLabel = [UILabel labelWithFrame:CGRectZero alignment:NSTextAlignmentCenter fontSize:18 textColor:[UIColor whiteColor] string:@"手机登录" systemFont:NO];
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
