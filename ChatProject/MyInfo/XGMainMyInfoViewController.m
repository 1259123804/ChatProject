//
//  XGMainMyInfoViewController.m
//  ChatProject
//
//  Created by Duke Li on 2018/7/26.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGMainMyInfoViewController.h"
#import "XGMyInfoHeadTableViewCell.h"
#import "XGMyInfoChoiceTableViewCell.h"
@interface XGMainMyInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *typeImageArr;
@property (nonatomic, strong) NSArray *typeNameArr;

@end

@implementation XGMainMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.typeNameArr = @[@"我的钱包", @"兴趣约玩", @"我的会员", @"实名认证", @"二维码", @"设置"];
    self.typeImageArr = @[@"Mine_main_money", @"Mine_main_interest", @"Mine_main_vip", @"Mine_main_vip", @"Mine_main_sign", @"Mine_main_setting"];
    [self.view addSubview:self.myTableView];
   
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.myTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return section == 1 ? 5 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        XGMyInfoHeadTableViewCell *headCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGMyInfoHeadTableViewCell class])];
        NSString *userName = DefaultsValueForKey(kUser_name);
        NSString *userId = DefaultsValueForKey(kUser_id);
        headCell.nameLabel.text = userName;
        headCell.idLabel.text = userId;
        if (DefaultsValueForKey(kUser_avatar) && ![DefaultsValueForKey(kUser_avatar) isEqualToString:@""]) {
            
            [headCell.headImageView sd_setImageWithURL:[NSURL URLWithString:DefaultsValueForKey(kUser_avatar)]];
        }else{
            DefaultPortraitView *defaultPortrait =
            [[DefaultPortraitView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            [defaultPortrait setColorAndLabel:userId Nickname:userName];
            UIImage *portrait = [defaultPortrait imageFromView];
            headCell.headImageView.image = portrait;
        }
        return headCell;
    }
    XGMyInfoChoiceTableViewCell *choiceCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGMyInfoChoiceTableViewCell class])];
    if (indexPath.section == 1) {
        
        choiceCell.typeNameLabel.text = self.typeNameArr[indexPath.row];
        choiceCell.typeImageView.image = [UIImage imageNamed:self.typeImageArr[indexPath.row]];
        
    }else if (indexPath.section == 2){
        
        choiceCell.typeImageView.image = [UIImage imageNamed:self.typeImageArr.lastObject];
        choiceCell.typeNameLabel.text = self.typeNameArr.lastObject;
    }
    return choiceCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 136;
    }
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

- (UITableView *)myTableView{
    
    if (_myTableView == nil) {
        
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight) style:UITableViewStyleGrouped];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_myTableView registerClass:[XGMyInfoHeadTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XGMyInfoHeadTableViewCell class])];
        [_myTableView registerClass:[XGMyInfoChoiceTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XGMyInfoChoiceTableViewCell class])];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = UIColorWithRGBA(233, 233, 233, 1);
    }
    return _myTableView;
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
