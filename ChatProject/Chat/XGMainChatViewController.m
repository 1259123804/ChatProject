//
//  XGMainChatViewController.m
//  ChatProject
//
//  Created by Duke Li on 2018/7/26.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGMainChatViewController.h"
#import "XGChatSearchFriendViewController.h"
#import "DefaultPortraitView.h"
#import "RCDAddressBookTableViewCell.h"
#import "RCDAddressBookViewController.h"
#import "RCDCommonDefine.h"
#import "RCDContactTableViewCell.h"
#import "RCDHttpTool.h"
#import "RCDPersonDetailViewController.h"
#import "RCDRCIMDataSource.h"
#import "RCDSearchFriendViewController.h"
#import "RCDUserInfo.h"
#import "RCDataBaseManager.h"
#import "UIImageView+WebCache.h"
#import "pinyin.h"
#import "RCDTableView.h"
#import "RCDUIBarButtonItem.h"
#import "RCDUserInfoManager.h"
#import "RCDUtilities.h"
#import "RCDChatViewController.h"
#import "RCDForwardAlertView.h"
@interface XGMainChatViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *addSuspendView;
@property (nonatomic, strong) UIView *addSuspendBackView;
@property(strong, nonatomic) NSMutableArray *matchFriendList;
@property(strong, nonatomic) NSArray *defaultCellsTitle;
@property(strong, nonatomic) NSArray *defaultCellsPortrait;
@property(nonatomic, assign) BOOL hasSyncFriendList;
@property(nonatomic, assign) BOOL isBeginSearch;
@property (nonatomic, strong) UISearchBar *searchFriendsBar;
//@property(nonatomic, strong) NSMutableDictionary *resultDic;
@property (nonatomic, strong) RCDTableView *friendsTabelView;
@property (nonatomic, strong) NSMutableArray *friendsListArray;
@end

@implementation XGMainChatViewController


- (void)setUpView {
    [self.friendsTabelView
     setBackgroundColor:[UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1]];
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    
    [self.view addSubview:self.friendsTabelView];
    [self.view addSubview:self.searchFriendsBar];
}

- (UISearchBar *)searchFriendsBar {
    if (!_searchFriendsBar) {
        _searchFriendsBar = [[UISearchBar alloc] initWithFrame:CGRectMake(12, kNavBarHeight + 5, RCDscreenWidth - 28, 28)];
        _searchBar.placeholder = @"搜索";
        [_searchFriendsBar sizeToFit];
        [_searchFriendsBar setPlaceholder:NSLocalizedStringFromTable(@"ToSearch", @"RongCloudKit", nil)];
        [_searchFriendsBar.layer setBorderWidth:0.5];
        [_searchFriendsBar.layer
         setBorderColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1].CGColor];
        [_searchFriendsBar setDelegate:self];
        [_searchFriendsBar setKeyboardType:UIKeyboardTypeDefault];
    }
    return _searchFriendsBar;
}

- (RCDTableView *)friendsTabelView {
    if (!_friendsTabelView) {
        CGRect searchBarFrame = self.searchFriendsBar.frame;
        CGFloat originY = CGRectGetMaxY(searchBarFrame);
        _friendsTabelView = [[RCDTableView alloc]
                             initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, self.view.bounds.size.height )
                             style:UITableViewStyleGrouped];
        
        _friendsTabelView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        if ([_friendsTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
            _friendsTabelView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        }
        if ([_friendsTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
            _friendsTabelView.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 0);
        }
        [_friendsTabelView setDelegate:self];
        [_friendsTabelView setDataSource:self];
        [_friendsTabelView setSectionIndexBackgroundColor:[UIColor clearColor]];
        [_friendsTabelView setSectionIndexColor:[UIColor darkGrayColor]];
        [_friendsTabelView
         setBackgroundColor:[UIColor colorWithRed:240.0 / 255 green:240.0 / 255 blue:240.0 / 255 alpha:1]];
        //        _friendsTabelView.style = UITableViewStyleGrouped;
        //        _friendsTabelView.tableHeaderView=self.searchFriendsBar;
        // cell无数据时，不显示间隔线
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        [_friendsTabelView setTableFooterView:v];
    }
    return _friendsTabelView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.friendsListArray = [NSMutableArray array];
    [self.navBarView addSubview:self.addImageView];
    [self.navBarView addSubview:self.headerImageView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    
    [self setUpView];
    // initial data
    self.matchFriendList = [[NSMutableArray alloc] init];
    self.allFriendSectionDic = [[NSDictionary alloc] init];
    
    self.friendsTabelView.tableFooterView = [UIView new];
    self.friendsTabelView.backgroundColor = HEXCOLOR(0xf0f0f6);
    self.friendsTabelView.separatorColor = HEXCOLOR(0xdfdfdf);
    
    self.friendsTabelView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.friendsTabelView.bounds.size.width, 0.01f)];
    
    //设置右侧索引
    self.friendsTabelView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.friendsTabelView.sectionIndexColor = HEXCOLOR(0x555555);
    
    if ([self.friendsTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.friendsTabelView setSeparatorInset:UIEdgeInsetsMake(0, 14, 0, 0)];
    }
    if ([self.friendsTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.friendsTabelView setLayoutMargins:UIEdgeInsetsMake(0, 14, 0, 0)];
    }
    
    UIImage *searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:32.0f];
    //设置顶部搜索栏的背景图片
    [self.searchFriendsBar setBackgroundImage:searchBarBg];
    //设置顶部搜索栏的背景色
    [self.searchFriendsBar setBackgroundColor:HEXCOLOR(0xf0f0f6)];
    
    //设置顶部搜索栏输入框的样式
    UITextField *searchField = [self.searchFriendsBar valueForKey:@"_searchField"];
    searchField.layer.borderWidth = 0.5f;
    searchField.layer.borderColor = [HEXCOLOR(0xdfdfdf) CGColor];
    searchField.layer.cornerRadius = 5.f;
    self.searchFriendsBar.placeholder = @"搜索";
    
    self.defaultCellsTitle = [NSArray arrayWithObjects:@"互动提醒", @"系统消息", @"陌生人消息", @"好友定制",@"通讯录好友", nil];
    self.defaultCellsPortrait = [NSArray arrayWithObjects:@"ChatList_interaction", @"ChatList_systemInfo", @"ChatList_strangerInfo", @"ChatList_suitInfo", @"ChatList_addressbookInfo",nil];
    
    self.isBeginSearch = NO;
    
    if ([RCDForwardMananer shareInstance].isForward) {
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(onCancelAction)];
        self.navigationItem.leftBarButtonItem = left;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.searchFriendsBar resignFirstResponder];
    [self sortAndRefreshWithList:[self getAllFriendList]];
    
    //自定义rightBarButtonItem
    RCDUIBarButtonItem *rightBtn = [[RCDUIBarButtonItem alloc] initContainImage:[UIImage imageNamed:@"add_friend"]
                                                                 imageViewFrame:CGRectMake(0, 0, 18, 20)
                                                                    buttonTitle:nil
                                                                     titleColor:nil
                                                                     titleFrame:CGRectZero
                                                                    buttonFrame:CGRectMake(0, 0, 18, 20)
                                                                         target:self
                                                                         action:@selector(pushAddFriend:)];
    self.tabBarController.navigationItem.rightBarButtonItems = [rightBtn setTranslation:rightBtn translation:-6];
    
    self.tabBarController.navigationItem.title = @"通讯录";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_isBeginSearch == YES) {
        [self sortAndRefreshWithList:[self getAllFriendList]];
        _isBeginSearch = NO;
        self.searchFriendsBar.showsCancelButton = NO;
        [self.searchFriendsBar resignFirstResponder];
        self.searchFriendsBar.text = @"";
        [self.matchFriendList removeAllObjects];
        [self.friendsTabelView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if (section == 0) {
        if (_isBeginSearch == YES) {
            rows = 0;
        } else {
            rows = self.defaultCellsTitle.count;
        }
    } else {
        
        //NSString *letter = self.resultDic[@"allKeys"][section - 1];
        //rows = [self.allFriendSectionDic[letter] count];
        rows = self.friendsListArray.count;
    }
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return [self.resultDic[@"allKeys"] count] + 1;
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 21.f;
}

//如果没有该方法，tableView会默认显示footerView，其高度与headerView等高
//另外如果return 0或者0.0f是没有效果的
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 22);
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.frame = CGRectMake(13, 3, 15, 15);
    title.font = [UIFont systemFontOfSize:15.f];
    title.textColor = HEXCOLOR(0x999999);
    
    [view addSubview:title];
    
    if (section == 0) {
        title.text = nil;
    } else {
        //title.text = self.resultDic[@"allKeys"][section - 1];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isDisplayID = [[NSUserDefaults standardUserDefaults] boolForKey:@"isDisplayID"];
    static NSString *reusableCellWithIdentifier = @"RCDContactTableViewCell";
    RCDContactTableViewCell *cell =
    [self.friendsTabelView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
    if (cell == nil) {
        cell = [[RCDContactTableViewCell alloc] init];
    }
    
    if (indexPath.section == 0 && indexPath.row < self.defaultCellsTitle.count) {
        if ([RCDForwardMananer shareInstance].isForward && indexPath.section == 0 && indexPath.row == 0) {
            
        }else{
            cell.nicknameLabel.text = [_defaultCellsTitle objectAtIndex:indexPath.row];
            [cell.portraitView
             setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [_defaultCellsPortrait
                                                                             objectAtIndex:indexPath.row]]]];
        }
    }
//    if (indexPath.section == 0 && indexPath.row == 3) {
//        if (isDisplayID == YES) {
//            cell.userIdLabel.text = [RCIM sharedRCIM].currentUserInfo.userId;
//        }
//        cell.nicknameLabel.text = [RCIM sharedRCIM].currentUserInfo.name;
//        [cell.portraitView sd_setImageWithURL:[NSURL URLWithString:[RCIM sharedRCIM].currentUserInfo.portraitUri]
//                             placeholderImage:[UIImage imageNamed:@"contact"]];
//    }
    if (indexPath.section != 0) {
        //NSString *letter = self.resultDic[@"allKeys"][indexPath.section - 1];
        
        //NSArray *sectionUserInfoList = self.allFriendSectionDic[letter];
        //RCDUserInfo *userInfo = sectionUserInfoList[indexPath.row];
        RCDUserInfo *userInfo = self.friendsListArray[indexPath.row];
        if (userInfo) {
            if (isDisplayID == YES) {
                cell.userIdLabel.text = userInfo.userId;
            }
            cell.nicknameLabel.text = userInfo.name;
            if ([userInfo.portraitUri isEqualToString:@""]) {
                DefaultPortraitView *defaultPortrait =
                [[DefaultPortraitView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                [defaultPortrait setColorAndLabel:userInfo.userId Nickname:userInfo.name];
                UIImage *portrait = [defaultPortrait imageFromView];
                cell.portraitView.image = portrait;
            } else {
                [cell.portraitView sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri]
                                     placeholderImage:[UIImage imageNamed:@"contact"]];
            }
        }
    }
    if ([RCIM sharedRCIM].globalConversationAvatarStyle == RC_USER_AVATAR_CYCLE &&
        [RCIM sharedRCIM].globalMessageAvatarStyle == RC_USER_AVATAR_CYCLE) {
        cell.portraitView.layer.masksToBounds = YES;
        cell.portraitView.layer.cornerRadius = 20.f;
    } else {
        cell.portraitView.layer.masksToBounds = YES;
        cell.portraitView.layer.cornerRadius = 5.f;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.portraitView.contentMode = UIViewContentModeScaleAspectFill;
    cell.nicknameLabel.font = [UIFont systemFontOfSize:15.f];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([RCDForwardMananer shareInstance].isForward && indexPath.section == 0 && indexPath.row == 0) {
        return 0.01;
    }
    return 55.5;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return nil;
   // return self.resultDic[@"allKeys"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.friendsTabelView deselectRowAtIndexPath:indexPath animated:YES];
    RCDUserInfo *user = nil;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                
                return;
            } break;
                
            case 1: {
                RCDAddressBookViewController *addressBookVC = [RCDAddressBookViewController addressBookViewController];
                [MyTools pushViewControllerFrom:self To:addressBookVC animated:YES];
                return;
                
            } break;
                
            case 2: {
                
                return;
                
            } break;
                
            case 3: {
                
                if ([RCDForwardMananer shareInstance].isForward) {
                    RCConversation *conver = [[RCConversation alloc] init];
                    conver.targetId = [RCIM sharedRCIM].currentUserInfo.userId;
                    conver.conversationType = ConversationType_PRIVATE;
                    [RCDForwardMananer shareInstance].toConversation = conver;
                    [[RCDForwardMananer shareInstance] showForwardAlertViewInViewController:self];
                    return;
                }
                
                RCDPersonDetailViewController *detailViewController = [[RCDPersonDetailViewController alloc] init];
                [self.navigationController pushViewController:detailViewController animated:YES];
                detailViewController.userId = [RCIM sharedRCIM].currentUserInfo.userId;
                return;
            }
                
            default:
                break;
        }
    }
//    NSString *letter = self.resultDic[@"allKeys"][indexPath.section - 1];
//    NSArray *sectionUserInfoList = self.allFriendSectionDic[letter];
//    user = sectionUserInfoList[indexPath.row];
//    if (user == nil) {
//        return;
//    }
    
    RCDChatViewController *chatViewController = [[RCDChatViewController alloc] init];
    chatViewController.conversationType = ConversationType_PRIVATE;
    user = self.friendsListArray[indexPath.row];
    chatViewController.targetId = user.userId;
    chatViewController.title = user.name;
    chatViewController.needPopToRootView = YES;
    chatViewController.displayUserNameInCell = NO;
    [MyTools pushViewControllerFrom:self To:chatViewController animated:YES];
    return;
    if ([RCDForwardMananer shareInstance].isForward) {
        RCConversation *conver = [[RCConversation alloc] init];
        conver.targetId = user.userId;
        conver.conversationType = ConversationType_PRIVATE;
        [RCDForwardMananer shareInstance].toConversation = conver;
        [[RCDForwardMananer shareInstance] showForwardAlertViewInViewController:self];
        return;
    }
    
    RCUserInfo *userInfo = [RCUserInfo new];
    userInfo.userId = user.userId;
    userInfo.portraitUri = user.portraitUri;
    userInfo.name = user.name;
    
    RCDPersonDetailViewController *detailViewController = [[RCDPersonDetailViewController alloc] init];
    detailViewController.userId = user.userId;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchFriendsBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate
/**
 *  执行delegate搜索好友
 *
 *  @param searchBar  searchBar description
 *  @param searchText searchText description
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.matchFriendList removeAllObjects];
    if (searchText.length <= 0) {
        [self sortAndRefreshWithList:[self getAllFriendList]];
    } else {
        for (RCUserInfo *userInfo in [self getAllFriendList]) {
            //忽略大小写去判断是否包含
            if ([userInfo.name rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound ||
                [[RCDUtilities hanZiToPinYinWithString:userInfo.name] rangeOfString:searchText
                                                                            options:NSCaseInsensitiveSearch]
                .location != NSNotFound) {
                [self.matchFriendList addObject:userInfo];
            }
        }
        [self sortAndRefreshWithList:self.matchFriendList];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchFriendsBar.showsCancelButton = NO;
    [self.searchFriendsBar resignFirstResponder];
    self.searchFriendsBar.text = @"";
    [self.matchFriendList removeAllObjects];
    [self sortAndRefreshWithList:[self getAllFriendList]];
    _isBeginSearch = NO;
    [self.friendsTabelView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (_isBeginSearch == NO) {
        _isBeginSearch = YES;
        [self.friendsTabelView reloadData];
    }
    self.searchFriendsBar.showsCancelButton = YES;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - 获取好友并且排序

- (NSArray *)getAllFriendList {
    NSMutableArray *friendList = [[NSMutableArray alloc] init];
    NSMutableArray *userInfoList = [NSMutableArray arrayWithArray:[[RCDataBaseManager shareInstance] getAllFriends]];
    for (RCDUserInfo *user in userInfoList) {
        if ([user.status isEqualToString:@"1"]) {
            [friendList addObject:user];
        }
    }
    if (friendList.count <= 0 && !self.hasSyncFriendList) {
        [RCDDataSource syncFriendList:[RCIM sharedRCIM].currentUserInfo.userId complete:^(NSMutableArray *result) {
            self.hasSyncFriendList = YES;
            [self sortAndRefreshWithList:[self getAllFriendList]];
        }];
    }
    //如有好友备注，则显示备注
    NSArray *resultList = [[RCDUserInfoManager shareInstance] getFriendInfoList:friendList];
    return resultList;
}

- (void)sortAndRefreshWithList:(NSArray *)friendList {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //self.resultDic = [RCDUtilities sortedArrayWithPinYinDic:friendList];
        self.friendsListArray = [NSMutableArray arrayWithArray:friendList];
        dispatch_async(dispatch_get_main_queue(), ^{
            //self.allFriendSectionDic = self.resultDic[@"infoDic"];
            [self.friendsTabelView reloadData];
        });
    });
}

/**
 *  添加好友
 *
 *  @param sender sender description
 */
- (void)pushAddFriend:(id)sender {
    RCDSearchFriendViewController *searchFirendVC = [RCDSearchFriendViewController searchFriendViewController];
    [self.navigationController pushViewController:searchFirendVC animated:YES];
}

- (UIImage *)GetImageWithColor:(UIColor *)color andHeight:(CGFloat)height {
    CGRect r = CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)onCancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[RCDForwardMananer shareInstance] clear];
}

- (UIView *)addImageView{
    
    if (_addImageView == nil) {
        
        _addImageView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 51, kNavBarHeight - 43, 40, 40)];
        UIImageView *addView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatList_addIcon"]];
        addView.frame = CGRectMake(12, 12, 16, 16);
        [_addImageView addSubview:addView];
        
        UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] init];
        [_addImageView addGestureRecognizer:addTap];
        [[addTap rac_gestureSignal] subscribeNext:^(id x) {
            
            [self.view addSubview:self.addSuspendBackView];
        }];
    }
    return _addImageView;
}

- (UIImageView *)headerImageView{
    
    if (_headerImageView == nil) {
       
        _headerImageView = [[UIImageView alloc] initWithImage:nil];
        _headerImageView.frame = CGRectMake(10, CGRectGetMidY(self.navTitleLabel.frame) - 20 , 40, 40);
        _headerImageView.layer.cornerRadius = 20.0;
        _headerImageView.layer.masksToBounds = YES;
    //_headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        if (DefaultsValueForKey(kUser_avatar) && ![DefaultsValueForKey(kUser_avatar) isEqualToString:@""]) {
            
            [_headerImageView sd_setImageWithURL:[NSURL URLWithString:DefaultsValueForKey(kUser_avatar)]];
        }else{
            
            DefaultPortraitView *portrait = [[DefaultPortraitView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            [portrait setColorAndLabel:DefaultsValueForKey(kUser_id) Nickname:DefaultsValueForKey(kUser_name)];
            _headerImageView.image = [portrait imageFromView];
        }
    }
    return _headerImageView;
}

- (UIView *)addSuspendBackView{
    
    if (_addSuspendBackView == nil) {
        
        _addSuspendBackView = [[UIView alloc] initWithFrame:self.view.bounds];
        _addSuspendBackView.backgroundColor = [UIColor clearColor];
        [_addSuspendBackView addSubview:self.addSuspendView];
        
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] init];
        [_addSuspendBackView addGestureRecognizer:backTap];
        [[backTap rac_gestureSignal] subscribeNext:^(id x) {
           
            [self.addSuspendBackView removeFromSuperview];
        }];
    }
    return _addSuspendBackView;
}

- (UIView *)addSuspendView{
    
    if (_addSuspendView == nil) {
        
        _addSuspendView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 103, CGRectGetMaxY(self.addImageView.frame) + 5, 92, 68)];
        _addSuspendView.backgroundColor = [UIColor whiteColor];
        _addSuspendView.layer.shadowOpacity = 1.0;
        _addSuspendView.layer.shadowColor = UIColorWithRGBA(0, 0, 0, 0.3).CGColor;
        _addSuspendView.layer.shadowOffset = CGSizeMake(0, 0);
        _addSuspendView.layer.shadowRadius = 4.0;
        
        UILabel *firstLabel = [self addChoiceLabelWithTitle:@"添加好友"];
        UILabel *secondLabel = [self addChoiceLabelWithTitle:@"扫一扫"];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, 92, 1)];
        lineView.backgroundColor = UIColorWithRGBA(0, 0, 0, 0.1);
        [_addSuspendView addSubview:lineView];
        
        [_addSuspendView addSubview:firstLabel];
        [_addSuspendView addSubview:secondLabel];
    }
    return _addSuspendView;
}
- (UILabel *)addChoiceLabelWithTitle:(NSString *)title{
  
    CGRect rect = CGRectMake(0, [title isEqualToString:@"添加好友"] ? 0 : 35, 92, 33);
    UILabel *choiceLabel = [UILabel labelWithFrame:rect alignment:NSTextAlignmentCenter fontSize:13 textColor:UIColorWithRGBA(51, 51, 51, 1) string:title systemFont:NO];
    choiceLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *choiceTap = [[UITapGestureRecognizer alloc] init];
    [choiceLabel addGestureRecognizer:choiceTap];
    [[choiceTap rac_gestureSignal] subscribeNext:^(id x) {
        
        if ([title isEqualToString:@"添加好友"]){
            
            XGChatSearchFriendViewController *addFriendController = [XGChatSearchFriendViewController searchFriendViewController];
            [MyTools pushViewControllerFrom:self To:addFriendController animated:YES];
        }
        return;
        
        MyAlertView(title, nil);
    }];
    return choiceLabel;
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
