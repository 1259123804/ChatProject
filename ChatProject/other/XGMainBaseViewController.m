//
//  XGMainBaseViewController.m
//  ChatProject
//
//  Created by Duke Li on 2018/7/26.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGMainBaseViewController.h"

@interface XGMainBaseViewController ()

@end

@implementation XGMainBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    [self.view addSubview:self.navBarView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)navBarView{
    if (_navBarView == nil) {
        
        _navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight)];
        _navBarView.backgroundColor = [UIColor whiteColor];
        [_navBarView addSubview:self.navTitleLabel];
    }
    return _navBarView;
}



- (UILabel *)navTitleLabel{
    
    if (_navTitleLabel == nil){
        
        _navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 100, kNavBarHeight - 35, 200, 25)];
        _navTitleLabel.textColor = UIColorWithRGBA(51, 51, 51, 1);
        _navTitleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _navTitleLabel;
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
