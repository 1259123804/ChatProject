//
//  NSObject+HUD.m
//  BonDay
//
//  Created by   文进 on 16/2/25.
//  Copyright © 2016年 BonDay. All rights reserved.
//

#import "NSObject+HUD.h"
#import "MBProgressHUD.h"

@implementation NSObject (HUD)
/**获取当前屏幕的最上方的正在显示的view*/

- (UIView *)currentView{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    //vc：可能是导航控制器，标签控制器，普通控制器
    if ([vc isKindOfClass:[UITabBarController class]]) {
        vc = [(UITabBarController *)vc  selectedViewController];
    }
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)vc visibleViewController];
    }
    return vc.view;
    
}
/**弹出文字提示*/
-(void)showAlert:(NSString *)text {
    
    //防止在非主线程中调用此方法会报错
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:[self currentView] animated:YES];
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
        progressHUD.mode = MBProgressHUDModeText;
        progressHUD.label.text= text;
        [progressHUD hideAnimated:YES afterDelay:1.5];
    });
    
    
}
/**显示忙*/
- (void)showBusy {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [MBProgressHUD hideHUDForView:[self currentView] animated:YES];
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
        [progressHUD hideAnimated:[self currentView] afterDelay:YES];
    }];
    
}
/**隐藏提示*/
- (void) hideProgress {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [MBProgressHUD hideHUDForView:[self currentView] animated:YES];
        
    }];
    
}@end
