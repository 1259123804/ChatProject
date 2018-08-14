//
//  XGLoginRegisterBaseViewController.m
//  ChatProject
//
//  Created by xiaoguang on 2018/8/4.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGLoginRegisterBaseViewController.h"

@interface XGLoginRegisterBaseViewController ()

@end

@implementation XGLoginRegisterBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissMyController) name:kNotificationName_dismissLogin object:nil];
    // Do any additional setup after loading the view.
}
- (void)dismissMyController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
