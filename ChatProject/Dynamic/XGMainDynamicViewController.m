//
//  XGMainDynamicViewController.m
//  ChatProject
//
//  Created by Duke Li on 2018/7/26.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGMainDynamicViewController.h"
#import "XGPublicDynamicViewController.h"
@interface XGMainDynamicViewController ()

@end

@implementation XGMainDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *dynamicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dynamicBtn.backgroundColor = [UIColor blueColor];
    [dynamicBtn setTitle:@"发布动态" forState:UIControlStateNormal];
    dynamicBtn.frame = CGRectMake(kScreenWidth/2-50, kScreenHeight/2 - 20, 100, 40);
    [dynamicBtn addTarget:self action:@selector(dynamicClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dynamicBtn];
    // Do any additional setup after loading the view.
}

- (void)dynamicClick{
    
    XGPublicDynamicViewController *publicDynamicController = [[XGPublicDynamicViewController alloc] init];
    [MyTools pushViewControllerFrom:self To:publicDynamicController animated:YES];
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
