//
//  XGLoginRegisterBaseViewController.h
//  ChatProject
//
//  Created by xiaoguang on 2018/8/4.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGLoginRegisterBaseViewController : UIViewController
@property (nonatomic, strong) UIView *loginBackView;
@property (nonatomic, strong) UILabel *loginTitleLabel;
@property (nonatomic, strong) UILabel *loginDesLabel;
@property (nonatomic, copy) void(^dismissCurrentController)(void);
@end
