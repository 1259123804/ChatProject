//
//  XGMainTabbarViewController.m
//  ChatProject
//
//  Created by Duke Li on 2018/7/26.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGMainTabbarViewController.h"
@interface XGMainTabbarViewController ()

@end

@implementation XGMainTabbarViewController

#pragma mark - 生命周期及系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    NSArray *titles = @[@"动态", @"通讯录", @"发现", @"我的"];
    NSArray *imageNames = @[@"Tabbar_dynamic", @"Tabbar_chat", @"Tabbar_find", @"Tabbar_mine"];
    NSArray *controllers = @[@"XGMainDynamicViewController",
                             @"XGMainChatViewController",
                             @"XGMainFindViewController",
                             @"XGMainMyInfoViewController"];
    for (int i = 0; i < 4; i++){
        
        NSString *hlName = [imageNames[i] stringByAppendingString:@"_hl"];
        [viewControllers addObject:[self mainControllerWithTitle:titles[i] normalImageName:imageNames[i] selectImageName:hlName className:controllers[i]]];
    }
    self.viewControllers = viewControllers;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 私有方法

#pragma mark - 通知、代理及数据源方法

#pragma mark - 视图及控制器创建方法
- (UINavigationController *)mainControllerWithTitle:(NSString *)title normalImageName:(NSString *)normalName selectImageName:(NSString *)selectName className:(NSString *)className{
    
    XGMainBaseViewController *baseController = [[NSClassFromString(className) alloc] init];
    baseController.navTitleLabel.text = title;
    XGNavigationBaseViewController *navigationController = [[XGNavigationBaseViewController alloc] initWithRootViewController:baseController];
    navigationController.tabBarController.tabBar.translucent = YES;
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:nil selectedImage:nil];
    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:10], NSForegroundColorAttributeName: UIColorWithRGBA(153, 153, 153, 1)} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorWithRGBA(255, 112, 140, 1)} forState:UIControlStateSelected];
    item.image = [[UIImage imageNamed:normalName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [[UIImage imageNamed:selectName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
