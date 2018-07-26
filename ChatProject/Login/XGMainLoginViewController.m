//
//  XGMainLoginViewController.m
//  ChatProject
//
//  Created by Duke Li on 2018/7/26.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGMainLoginViewController.h"

@interface XGMainLoginViewController ()

@end

@implementation XGMainLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:@"13253595712" zone:@"86" template:@"123456" result:^(NSError *error) {
       
        if (!error){
            
            MyAlertView(@"发送成功", nil);
            [SMSSDK commitVerificationCode:@"" phoneNumber:<#(NSString *)#> zone:<#(NSString *)#> result:<#^(NSError *error)result#>]
            
        }else{
            
            MyAlertView(@"发送失败", nil);
        }
    }];
    // Do any additional setup after loading the view.
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
