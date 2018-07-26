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
    [SMSSDK commitVerificationCode:@"652198" phoneNumber:@"13253595712" zone:@"86" result:^(NSError *error) {

        NSLog(@"%@", error.userInfo[@"description"]);

        if (error){

            MyAlertView(@"验证失败", nil);

        }else{

            MyAlertView(@"验证成功", nil);
        }
    }];
//    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:@"13253595712" zone:@"86" template:nil result:^(NSError *error) {
//
//        if (!error){
//
//            MyAlertView(@"发送成功", nil);
//
//        }else{
//
//            MyAlertView(@"发送失败", nil);
//        }
//    }];
   
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
