//
//  XGLoginPasswordViewController.h
//  ChatProject
//
//  Created by Duke Li on 2018/7/27.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGLoginRegisterBaseViewController.h"
#import "XGMainLoginViewController.h"
#import "XGLoginAddInfoViewController.h"
#import "XGMainRegisterViewController.h"
@interface XGLoginPasswordViewController : XGLoginRegisterBaseViewController

@property (nonatomic, strong) XGMainLoginViewController *mainLoginController;
@property (nonatomic, strong) XGMainLoginViewController *mainForgetController;
@end
