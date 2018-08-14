//
//  XGRegisterAddInfoViewController.m
//  ChatProject
//
//  Created by Duke Li on 2018/7/27.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGRegisterAddInfoViewController.h"
#import <Photos/Photos.h>
@interface XGRegisterAddInfoViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIView *loginBackView;
@property (nonatomic, strong) UILabel *loginTitleLabel;
@property (nonatomic, strong) UIImageView *loginHeadImageView;
@property (nonatomic, strong) UIImageView *loginBackgroundView;
@property (nonatomic, strong) UIView *loginNickNameView;
@property (nonatomic, strong) UITextField *loginNickNameTextField;
@property (nonatomic, strong) UIView *loginBirthdayView;
@property (nonatomic, strong) UITextField *loginBirthdayTextField;
@property (nonatomic, strong) UIView *loginEmailView;
@property (nonatomic, strong) UITextField *loginEmailTextField;
@property (nonatomic, strong) UIView *loginSexView;
@property (nonatomic, strong) UITextField *loginSexTextField;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UILabel *loginDesLabel;
@property (nonatomic, strong) UILabel *sexDesLabel;
@property (nonatomic, strong) UIImageView *loginTopView;
@end

@implementation XGRegisterAddInfoViewController

#pragma mark - 生命周期及系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.loginBackView];
    [self.view addSubview:self.loginTopView];
    [self.view addSubview:self.loginTitleLabel];
    [self.view addSubview:self.loginHeadImageView];
    [self.view addSubview:self.loginBackgroundView];
    [self.loginBackgroundView addSubview:self.loginNickNameView];
    [self.loginBackgroundView addSubview:self.loginBirthdayView];
    [self.loginBackgroundView addSubview:self.loginEmailView];
    [self.loginBackgroundView addSubview:self.loginSexView];
    [self.loginBackgroundView addSubview:self.sexDesLabel];
    [self.loginBackgroundView addSubview:self.loginBtn];
    [self.view addSubview:self.loginDesLabel];
    
    //TODO:测试数据
    self.loginNickNameTextField.text = @"李";
    self.loginBirthdayTextField.text = @"555555";
    self.loginEmailTextField.text = @"1259123804@qq.com";
    self.loginSexTextField.text = @"男";
    
    self.loginBackView.sd_layout
    .leftSpaceToView(self.view, 20)
    .topSpaceToView(self.view, 50)
    .widthIs(30)
    .heightIs(30);
    
    self.loginTopView.sd_layout
    .leftSpaceToView(self.view, 40)
    .topSpaceToView(self.loginBackView, 30)
    .rightSpaceToView(self.view, 40)
    .heightIs((kScreenWidth - 80) * 86/600);
    
    self.loginTitleLabel.sd_layout
    .centerYEqualToView(self.loginBackView)
    .centerXEqualToView(self.view)
    .widthIs(200)
    .heightIs(50);
    
    self.loginHeadImageView.sd_layout
    .widthIs(66)
    .heightIs(66)
    .topSpaceToView(self.view, 120)
    .centerXEqualToView(self.view);
    
    self.loginBackgroundView.sd_layout
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .topSpaceToView(self.loginHeadImageView, -10)
    .heightIs(420);
    
    self.loginNickNameView.sd_layout
    .leftSpaceToView(self.loginBackgroundView, 15)
    .rightSpaceToView(self.loginBackgroundView, 15)
    .topSpaceToView(self.loginBackgroundView, 40)
    .heightIs(40);
    
    self.loginBirthdayView.sd_layout
    .leftEqualToView(self.loginNickNameView)
    .rightEqualToView(self.loginNickNameView)
    .topSpaceToView(self.loginNickNameView, 15)
    .heightRatioToView(self.loginNickNameView, 1);
    
    self.loginEmailView.sd_layout
    .leftEqualToView(self.loginNickNameView)
    .rightEqualToView(self.loginNickNameView)
    .topSpaceToView(self.loginBirthdayView, 15)
    .heightRatioToView(self.loginNickNameView, 1);
    
    self.loginSexView.sd_layout
    .leftEqualToView(self.loginNickNameView)
    .rightEqualToView(self.loginNickNameView)
    .topSpaceToView(self.loginEmailView, 15)
    .heightRatioToView(self.loginNickNameView, 1);
    
    self.sexDesLabel.sd_layout
    .leftSpaceToView(self.loginBackgroundView, 18)
    .rightEqualToView(self.loginNickNameView)
    .topSpaceToView(self.loginSexView, 5)
    .heightIs(20);
    
    self.loginBtn.sd_layout
    .leftEqualToView(self.loginNickNameView)
    .rightEqualToView(self.loginNickNameView)
    .topSpaceToView(self.sexDesLabel, 30)
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
    
    NSString *birthday = [self.loginBirthdayTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *email = [self.loginEmailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *nickName = [self.loginNickNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *sex = [self.loginSexTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    BOOL state = YES;
    if (nickName == nil || nickName.length == 0 || [nickName isEqualToString:@""]){
        
        MyAlertView(@"请输入昵称", nil);
        state = NO;
    }else if (birthday == nil || birthday.length == 0 || [birthday isEqualToString:@""]){
        
        MyAlertView(@"请输入您的生日", nil);
        state = NO;
        
    }else if (email == nil || email.length == 0 || [email isEqualToString:@""]){
        
        MyAlertView(@"请输入邮箱", nil);
        state = NO;
    }else if (sex == nil || sex.length == 0 || [sex isEqualToString:@""]){
        
        MyAlertView(@"请输入性别", nil);
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField; {
    
//    if (textField == self.loginBirthdayTextField || textField == self.loginSexTextField){
//        
//        [self.view endEditing:YES];
//        return NO;
//    }
    return YES;
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
        UITapGestureRecognizer *headImageTap = [[UITapGestureRecognizer alloc] init];
        [_loginHeadImageView addGestureRecognizer:headImageTap];
        [headImageTap.rac_gestureSignal subscribeNext:^(id x) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alertController addAction: [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (![AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]){
                    
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                        
                        if (granted){
                            
                            [self presentViewController:[self imageControllerWithType:UIImagePickerControllerSourceTypeCamera] animated:YES completion:nil];
                        }
                        return;
                    }];
                }
                [self presentViewController:[self imageControllerWithType:UIImagePickerControllerSourceTypeCamera] animated:YES completion:nil];
                
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                    
                    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                        
                        if (status == PHAuthorizationStatusAuthorized){
                            [self presentViewController:[self imageControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary] animated:YES completion:nil];
                        }
                    }];
                    return;
                }
                [self presentViewController:[self imageControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary] animated:YES completion:nil];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }];
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
        CGFloat height = 420;
        _loginBackgroundView = [UIImageView new];
        _loginBackgroundView.bounds = CGRectMake(0, 0, width, height);
        _loginBackgroundView.userInteractionEnabled = YES;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(width/2 - 40, 0)];
        [path addQuadCurveToPoint:CGPointMake(width/2 + 40, 0) controlPoint:CGPointMake(width/2, 35)];
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

- (UIView *)loginNickNameView{
    
    if (_loginNickNameView == nil){
        
        _loginNickNameView = [UIView new];
        [_loginNickNameView addSubview:self.loginNickNameTextField];
        UIView *line = [self lineView];
        [_loginNickNameView addSubview:line];
        
        UILabel *desLabel = [self desNameLabelWithText:@"昵称"];
        [_loginNickNameView addSubview:desLabel];
        
        desLabel.sd_layout
        .leftSpaceToView(_loginNickNameView , 3)
        .widthIs(40)
        .heightIs(25)
        .centerYEqualToView(self.loginNickNameTextField);
        
        self.loginNickNameTextField.sd_layout
        .leftSpaceToView(desLabel , 20)
        .rightSpaceToView(_loginNickNameView, 10)
        .bottomSpaceToView(_loginNickNameView, 3)
        .topEqualToView(_loginNickNameView);
        
        line.sd_layout
        .leftEqualToView(_loginNickNameView)
        .rightEqualToView(_loginNickNameView)
        .heightIs(1)
        .bottomEqualToView(_loginNickNameView);
    }
    
    return _loginNickNameView;
}

- (UITextField *)loginNickNameTextField{
    
    if (_loginNickNameTextField == nil){
        
        _loginNickNameTextField = [[UITextField alloc] init];
        _loginNickNameTextField.borderStyle = UITextBorderStyleNone;
        _loginNickNameTextField.placeholder = @"请输入您的昵称";
        _loginNickNameTextField.delegate = self;
    }
    return _loginNickNameTextField;
}

- (UILabel *)desNameLabelWithText:(NSString *)text{
    
    UILabel *label = [UILabel labelWithFrame:CGRectZero alignment:NSTextAlignmentLeft fontSize:16 textColor:[UIColor grayColor] string:text systemFont:NO];
    return label;
}

- (UIView *)lineView{
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = UIColorWithRGBA(150, 150, 150, 1);
    return lineView;
}

- (UIView *)loginBirthdayView{
    
    if (_loginBirthdayView == nil){
        
        _loginBirthdayView = [UIView new];
        [_loginBirthdayView addSubview:self.loginBirthdayTextField];
        UIView *line = [self lineView];
        [_loginBirthdayView addSubview:line];
        UILabel *desLabel = [self desNameLabelWithText:@"生日"];
        [_loginBirthdayView addSubview:desLabel];
        
        desLabel.sd_layout
        .leftSpaceToView(_loginBirthdayView, 3)
        .widthIs(40)
        .heightIs(25)
        .centerYEqualToView(self.loginBirthdayTextField);
        
        self.loginBirthdayTextField.sd_layout
        .leftSpaceToView(desLabel , 20)
        .rightSpaceToView(_loginBirthdayView, 10)
        .bottomSpaceToView(_loginBirthdayView, 3)
        .topEqualToView(_loginBirthdayView);
        
        line.sd_layout
        .leftEqualToView(_loginBirthdayView)
        .rightEqualToView(_loginBirthdayView)
        .heightIs(1)
        .bottomEqualToView(_loginBirthdayView);
    }
    return _loginBirthdayView;
}

- (UITextField *)loginBirthdayTextField{
    
    if (_loginBirthdayTextField== nil){
        
        _loginBirthdayTextField = [[UITextField alloc] init];
        _loginBirthdayTextField.borderStyle = UITextBorderStyleNone;
        _loginBirthdayTextField.placeholder = @"请输入您的出生日期";
        _loginBirthdayTextField.delegate = self;
    }
    return _loginBirthdayTextField;
}
- (UIView *)loginEmailView{
    
    if (_loginEmailView == nil){
        
        _loginEmailView = [UIView new];
        [_loginEmailView addSubview:self.loginEmailTextField];
        
        UIView *line = [self lineView];
        [_loginEmailView addSubview:line];
        
        UILabel *desLabel = [self desNameLabelWithText:@"邮箱"];
        [_loginEmailView addSubview:desLabel];
        
        desLabel.sd_layout
        .leftSpaceToView(_loginEmailView, 3)
        .widthIs(40)
        .heightIs(25)
        .centerYEqualToView(self.loginEmailTextField);
        
        self.loginEmailTextField.sd_layout
        .leftSpaceToView(desLabel, 20)
        .rightSpaceToView(_loginEmailView, 10)
        .bottomSpaceToView(_loginEmailView, 3)
        .topEqualToView(_loginEmailView);
        
        line.sd_layout
        .leftEqualToView(_loginEmailView)
        .rightEqualToView(_loginEmailView)
        .heightIs(1)
        .bottomEqualToView(_loginEmailView);
    }
    return _loginEmailView;
}

- (UITextField *)loginEmailTextField{
    
    if (_loginEmailTextField == nil){
        
        _loginEmailTextField = [[UITextField alloc] init];
        _loginEmailTextField.borderStyle = UITextBorderStyleNone;
        _loginEmailTextField.placeholder = @"请填写您的邮箱";
        _loginEmailTextField.delegate = self;
    }
    return _loginEmailTextField;
}

- (UIView *)loginSexView{
    
    if (_loginSexView == nil){
        
        _loginSexView = [UIView new];
        [_loginSexView addSubview:self.loginSexTextField];
        
        UIView *line = [self lineView];
        [_loginSexView addSubview:line];
        
        UILabel *desLabel = [self desNameLabelWithText:@"性别"];
        [_loginSexView addSubview:desLabel];
        
        desLabel.sd_layout
        .leftSpaceToView(_loginSexView, 3)
        .widthIs(40)
        .heightIs(25)
        .centerYEqualToView(self.loginSexTextField);
        
        self.loginSexTextField.sd_layout
        .leftSpaceToView(desLabel, 20)
        .rightSpaceToView(_loginSexView, 10)
        .bottomSpaceToView(_loginSexView, 3)
        .topEqualToView(_loginSexView);
        
        line.sd_layout
        .leftEqualToView(_loginSexView)
        .rightEqualToView(_loginSexView)
        .heightIs(1)
        .bottomEqualToView(_loginSexView);
    }
    return _loginSexView;
}

- (UITextField *)loginSexTextField{
    
    if (_loginSexTextField == nil){
        
        _loginSexTextField = [[UITextField alloc] init];
        _loginSexTextField.borderStyle = UITextBorderStyleNone;
        _loginSexTextField.placeholder = @"请选择您的性别";
        _loginSexTextField.delegate = self;
    }
    return _loginSexTextField;
}

- (UIButton *)loginBtn{
    
    if (_loginBtn == nil){
        
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:[UIColor redColor]];
        [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
            [self checkCanLoginState:^(BOOL canLoginState) {
                
                if (canLoginState){
                    
                    if (!self.infoDic){
                        
                        self.infoDic = [NSMutableDictionary dictionary];
                    }
                    [self.infoDic setValue:self.loginNickNameTextField.text forKey:@"name"];
                    [self.infoDic setValue:@(1) forKey:@"sex"];
                    [self.infoDic setValue:@"1994-11-23" forKey:@"birthday"];
                    [self.infoDic setValue:self.loginEmailTextField.text forKey:@"email"];
                    [MyAFSessionManager requestWithURLString:[kTestApi stringByAppendingString:kRegister_user] parameters:self.infoDic requestType:MyRequestTypePost managerType:MyAFSessionManagerTypeJsonWithToken success:^(id  _Nullable responseObject) {
                        
                        if ([responseObject[@"status"] intValue] == 0){
                            
                            NSDictionary *result = responseObject[@"result"];
                            [MyTools savePersonInfoWithDic:result];
                           
                        }
                        
                    } failure:^(NSError * _Nonnull error) {
                       
                        
                    }];
                   
                }
            }];
        }];
    }
    return _loginBtn;
}

- (UILabel *)loginTitleLabel{
    
    if (_loginTitleLabel == nil){
        
        _loginTitleLabel = [UILabel labelWithFrame:CGRectZero alignment:NSTextAlignmentCenter fontSize:18 textColor:[UIColor whiteColor] string:@"基本" systemFont:NO];
    }
    return _loginTitleLabel;
}

- (UILabel *)loginDesLabel{
    
    if (_loginDesLabel == nil){
        
        _loginDesLabel = [UILabel labelWithFrame:CGRectZero alignment:NSTextAlignmentCenter fontSize:14 textColor:[UIColor grayColor] string:@"登录表示同意《*****服务》" systemFont:YES];
    }
    return _loginDesLabel;
}

- (UILabel *)sexDesLabel{
    
    if (_sexDesLabel == nil){
        
        _sexDesLabel = [UILabel labelWithFrame:CGRectZero alignment:NSTextAlignmentLeft fontSize:12 textColor:[UIColor redColor] string:@"注册成功后，性别不可修改" systemFont:YES];
    }
    return _sexDesLabel;
}

- (UIImageView *)loginTopView{
    
    if (_loginTopView == nil){
        
        _loginTopView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_process1"]];
    }
    return _loginTopView;
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