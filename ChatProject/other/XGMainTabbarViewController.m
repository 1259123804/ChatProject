//
//  XGMainTabbarViewController.m
//  ChatProject
//
//  Created by Duke Li on 2018/7/26.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGMainTabbarViewController.h"
#import "XGMainLoginViewController.h"
@interface XGMainTabbarViewController ()

@end

@implementation XGMainTabbarViewController

#pragma mark - 生命周期及系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    NSArray *titles = @[@"聊天", @"通讯录", @"动态", @"我的"];
    NSArray *normalNames = @[@"", @"", @"", @""];
    NSArray *selectNames = @[@"", @"", @"", @""];
    for (int i = 0; i < 4; i++){
        
        [viewControllers addObject:[self mainControllerWithTitle:titles[i] normalImageName:normalNames[i] selectImageName:selectNames[i]]];
    }
    self.viewControllers = viewControllers;
    
    XGMainLoginViewController *loginController = [[XGMainLoginViewController alloc] init];
    [self presentViewController:loginController animated:YES completion:^{
        
        MyAlertView(@"请登录", nil);
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 私有方法

#pragma mark - 通知、代理及数据源方法

#pragma mark - 视图及控制器创建方法
- (UINavigationController *)mainControllerWithTitle:(NSString *)title normalImageName:(NSString *)normalName selectImageName:(NSString *)selectName{
    
    XGMainBaseViewController *baseController = [[XGMainBaseViewController alloc] init];
    baseController.title = title;
    XGNavigationBaseViewController *navigationController = [[XGNavigationBaseViewController alloc] initWithRootViewController:baseController];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:nil selectedImage:nil];
    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16]} forState:UIControlStateNormal];
    navigationController.tabBarItem = item;
    return navigationController;
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
