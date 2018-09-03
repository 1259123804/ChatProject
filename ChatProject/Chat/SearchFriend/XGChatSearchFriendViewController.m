//
//  XGChatSearchFriendViewController.m
//  ChatProject
//
//  Created by Duke Li on 2018/8/27.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGChatSearchFriendViewController.h"
#import "MBProgressHUD.h"
#import "RCDHttpTool.h"
#import "RCDRCIMDataSource.h"
#import "RCDUserInfo.h"
#import "RCDUserInfoManager.h"
#import "RCDataBaseManager.h"
#import "UIImageView+WebCache.h"
#import "XGSearchFriendResultTableViewCell.h"

@interface XGChatSearchFriendViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,
UISearchDisplayDelegate, UISearchControllerDelegate>

@property(strong, nonatomic) NSMutableArray *searchResult;
@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) UISearchDisplayController *searchDisplayController;

@end

@implementation XGChatSearchFriendViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    [self.searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.searchBar sizeToFit];
    
    UIColor *color = self.navigationController.navigationBar.barTintColor;
    [self.navigationController.view setBackgroundColor:color];
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:XGSearchFriendResultTableViewCell.class forCellReuseIdentifier:NSStringFromClass(XGSearchFriendResultTableViewCell.class)];
    self.searchDisplayController =
    [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    [self setSearchDisplayController:self.searchDisplayController];
    [self.searchDisplayController setDelegate:self];
    [self.searchDisplayController setSearchResultsDataSource:self];
    [self.searchDisplayController setSearchResultsDelegate:self];
    
    self.navigationItem.title = @"添加好友";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // initial data
    _searchResult = [[NSMutableArray alloc] init];
    
    [self setExtraCellLineHidden:self.searchDisplayController.searchResultsTableView];
}

+ (instancetype)searchFriendViewController {
    return [[[self class] alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:244 / 255.0 alpha:1];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - searchResultDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView)
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_10_3
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
    return _searchResult.count;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return 80.f;
    return 0.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XGSearchFriendResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(XGSearchFriendResultTableViewCell.class)];
    if (cell == nil) {
        
        cell = [[XGSearchFriendResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(XGSearchFriendResultTableViewCell.class)];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        cell = [[XGSearchFriendResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(XGSearchFriendResultTableViewCell.class)];
        RCDUserInfo *user = _searchResult[indexPath.row];
        if (user) {
            cell.addBtn.tag = indexPath.row;
            [cell.addBtn addTarget:self action:@selector(addFriendClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.lblName.text = user.name;
            if ([user.portraitUri isEqualToString:@""] || user.portraitUri == nil) {
                DefaultPortraitView *defaultPortrait =
                [[DefaultPortraitView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                [defaultPortrait setColorAndLabel:user.userId Nickname:user.name];
                UIImage *portrait = [defaultPortrait imageFromView];
                cell.ivAva.image = portrait;
            } else {
                [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:user.portraitUri]
                              placeholderImage:[UIImage imageNamed:@"icon_person"]];
            }
        }
    }
    cell.ivAva.contentMode = UIViewContentModeScaleAspectFill;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)addFriendClick:(UIButton *)sender{
    
    RCDUserInfo *userInfo = self.searchResult[sender.tag];
    if ([userInfo.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"你不能添加自己到通讯录"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    } else if (!userInfo.isFriend) {
        
        NSString *addUrl = [kTestApi stringByAppendingString:kFriends_apply];
        NSDictionary *params = @{@"user_id": @([userInfo.userId intValue]), @"apply_comment": @"你好"};
        [MyAFSessionManager requestWithURLString:addUrl parameters:params requestType:MyRequestTypePost managerType:MyAFSessionManagerTypeJsonWithToken success:^(id  _Nullable responseObject) {
            
            if ([responseObject[@"status"] intValue] == 0) {
                
                MyAlertView(responseObject[@"result"][@"msg"], nil);
                
            }else if (responseObject[@"message"]){
                
                MyAlertView(responseObject[@"message"], nil);
            }
            
        } failure:^(NSError * _Nonnull error) {
            MyAlertView(@"网络错误", nil);
        }];
    }
}

#pragma mark - searchResultDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UISearchBarDelegate
/**
 *  执行delegate搜索好友
 *
 *  @param searchBar  searchBar description
 *  @param searchText searchText description
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [_searchResult removeAllObjects];
    if ([searchText length] == 11) {
        [RCDHTTPTOOL
         searchUserByPhone:searchText
         complete:^(NSMutableArray *result) {
             if (result) {
                 for (RCDUserInfo *user in result) {
                     if ([user.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
                         [self.searchResult addObject:user];
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self.searchDisplayController.searchResultsTableView reloadData];
                         });
//                         [[RCDUserInfoManager shareInstance]
//                          getUserInfo:user.userId
//                          completion:^(RCUserInfo *user) {
//                              [self.searchResult addObject:user];
//                              dispatch_async(dispatch_get_main_queue(), ^{
//                                  [self.searchDisplayController.searchResultsTableView reloadData];
//                              });
//                          }];
                     } else {
                         [self.searchResult addObject:user];
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self.searchDisplayController.searchResultsTableView reloadData];
                         });
//                         [[RCDUserInfoManager shareInstance]
//                          getFriendInfo:user.userId
//                          completion:^(RCUserInfo *user) {
//                              [self.searchResult addObject:user];
//                              dispatch_async(dispatch_get_main_queue(), ^{
//                                  [self.searchDisplayController.searchResultsTableView reloadData];
//                              });
//                          }];
                     }
                 }
             }
         }];
    }
}

//每次searchDisplayController消失的时候都会调用searchDisplayControllerDidEndSearch两次
//正常情况下两次self.searchDisplayController.searchBar的superview都会是tableView
//但是如果你快速点击，那么第二次的superview会是一个UIView，这应该是iOS的系统bug
//参考http://stackoverflow.com/questions/18965713/troubles-with-uisearchbar-uisearchdisplayviewcontroller
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    if (self.tableView != self.searchDisplayController.searchBar.superview) {
        [self.searchDisplayController.searchBar removeFromSuperview];
        [self.tableView insertSubview:self.searchDisplayController.searchBar aboveSubview:self.tableView];
    }
}

//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
