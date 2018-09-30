//
//  XGLeftChoiceViewController.m
//  ChatProject
//
//  Created by Duke Li on 2018/9/28.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGLeftChoiceViewController.h"
#import "AppDelegate.h"

#define k
@interface XGLeftChoiceViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation XGLeftChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor brownColor];
    
    UITableView *tableview = [[UITableView alloc] init];
    self.tableview = tableview;
    tableview.rowHeight = 60;
    tableview.frame = self.view.bounds;
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.scrollEnabled = NO;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = NO;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"1";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"2";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"3";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"4";
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"5";
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"6";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    otherViewController *vc = [[otherViewController alloc] init];
//    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
//
//    [tempAppDelegate.mainNavigationController pushViewController:vc animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kScreenWidth == 414 ? 200 : kScreenWidth == 375 ? 180:140;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, kScreenWidth == 414 ? 200 : kScreenWidth == 375 ? 180:150)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(45, 50, 45, 45)];
    imageView.backgroundColor = [UIColor redColor];
    [view addSubview:imageView];
    UILabel *mLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 111, 200, 16)];
    mLab.centerX = imageView.centerX;
    mLab.font = [UIFont systemFontOfSize:16];
    mLab.textColor = [UIColor whiteColor];
    mLab.textAlignment = NSTextAlignmentCenter;
    mLab.text = @"你的名字";
    [view addSubview:mLab];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 150)];
    UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 110, 130, 16)];
    logoutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn setFont:[UIFont systemFontOfSize:16]];
    [view addSubview:logoutBtn];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 150;
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
