//
//  XGChatListViewController.m
//  BonDay
//
//  Created by Duke Li on 2017/5/9.
//  Copyright © 2017年 Bonday. All rights reserved.
//

#import "XGChatListViewController.h"
#import "AFHttpTool.h"
#import "RCDChatListCell.h"
#import "RCDHttpTool.h"
#import "RCDRCIMDataSource.h"
#import "RCDUserInfo.h"
#import "UIImageView+WebCache.h"
#import <RongIMKit/RongIMKit.h>
#import "XGPrivateConversationViewController.h"
#import "TestChatListViewController.h"
#import "RCDataBaseManager.h"
#import "RCDTestMessage.h"
@interface XGChatListViewController ()<UISearchBarDelegate>
@property (nonatomic,strong)UINavigationController *searchNavigationController;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong) NSMutableArray *myDataSource;
@property(nonatomic, strong) RCConversationModel *tempModel;

@property(nonatomic, assign) NSUInteger index;

@property(nonatomic, assign) BOOL isClick;
- (void)updateBadgeValueForTabBarItem;
@end

@implementation XGChatListViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE), @(ConversationType_GROUP)]];
//        [self setDisplayConversationTypes:@[
//                                            @(ConversationType_PRIVATE),
//                                            @(ConversationType_DISCUSSION),
//                                            @(ConversationType_APPSERVICE),
//                                            @(ConversationType_PUBLICSERVICE),
//                                            @(ConversationType_GROUP),
//                                            ]];
//        
//        //聚合会话类型
//        [self setCollectionConversationType:@[ @(ConversationType_SYSTEM) ]];
        
        
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE), @(ConversationType_GROUP)]];
//        [self setDisplayConversationTypes:@[
//                                            @(ConversationType_PRIVATE),
//                                            @(ConversationType_DISCUSSION),
//                                            @(ConversationType_APPSERVICE),
//                                            @(ConversationType_PUBLICSERVICE),
//                                            @(ConversationType_GROUP),
//                                            @(ConversationType_SYSTEM)
//                                            ]];
//        
//        //聚合会话类型
//        [self setCollectionConversationType:@[ @(ConversationType_SYSTEM) ]];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.conversationListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.conversationListTableView setSeparatorInset:UIEdgeInsetsMake(15, 0, 15, 20)];
    
    // 设置在NavigatorBar中显示连接中的提示
    self.showConnectingStatusOnNavigatorBar = YES;
    
    //定位未读数会话
    self.index = 0;
    //接收定位到未读数会话的通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(GotoNextCoversation)
     name:@"GotoNextCoversation"
     object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshCell:)
                                                 name:@"RefreshConversationList"
                                               object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isClick = YES;
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(receiveNeedRefreshNotification:)
     name:@"kRCNeedReloadDiscussionListNotification"
     object:nil];
}

//由于demo使用了tabbarcontroller，当切换到其它tab时，不能更改tabbarcontroller的标题。
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"kRCNeedReloadDiscussionListNotification"
     object:nil];
    
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    UIView *cellLine = [[UIView alloc] initWithFrame:CGRectMake(66, 66, kScreenWidth-20, 1)];
    [cell.contentView addSubview:cellLine];
}


/**
 *  点击进入会话页面
 *
 *  @param conversationModelType 会话类型
 *  @param model                 会话数据
 *  @param indexPath             indexPath description
 */
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    
    if (model.conversationType == 1) {
        
        XGPrivateConversationViewController *privateController = [[XGPrivateConversationViewController alloc] init];
        privateController.conversationType = ConversationType_PRIVATE;
        privateController.isSupport = YES;
        privateController.targetId = model.targetId;
        privateController.title = model.conversationTitle;
        [MyTools pushViewControllerFrom:self To:privateController animated:YES];
        
    }else if (model.conversationType == 3){
        
        TestChatListViewController *chateVC = [[TestChatListViewController alloc]initWithConversationType:ConversationType_GROUP targetId:model.targetId];
        chateVC.titleStr = model.conversationTitle;
        chateVC.groupIDStr = model.targetId;
        [MyTools pushViewControllerFrom:self To:chateVC animated:YES];
    }
    dispatch_after(
                   dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       [self refreshConversationTableViewIfNeeded];
                   });
}




//*********************插入自定义Cell*********************//

//插入自定义会话model
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    
//    for (int i = 0; i < dataSource.count; i++) {
//        RCConversationModel *model = dataSource[i];
//        //筛选请求添加好友的系统消息，用于生成自定义会话类型的cell
//        if (model.conversationType == ConversationType_PRIVATE || model.conversationType == ConversationType_GROUP) {
//                model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
//            }
//    }
    
    self.myDataSource = dataSource;
    return dataSource;
}

//左滑删除
- (void)rcConversationListTableView:(UITableView *)tableView
                 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                  forRowAtIndexPath:(NSIndexPath *)indexPath {
    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM
                                             targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
}

//高度
- (CGFloat)rcConversationListTableView:(UITableView *)tableView
               heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 97.0f;
}

//自定义cell
- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView
                                  cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    
    __block NSString *userName = nil;
    __block NSString *portraitUri = nil;
    NSString *textMessage = nil;
    __weak XGChatListViewController *weakSelf = self;
    //此处需要添加根据userid来获取用户信息的逻辑，extend字段不存在于DB中，当数据来自db时没有extend字段内容，只有userid
    
    if (model.conversationType == ConversationType_PRIVATE ||
        model.conversationType == ConversationType_GROUP) {
        NSLog(@"%@", NSStringFromClass([model.lastestMessage class]));
        
        if ([model.lastestMessage isKindOfClass:[RCDTestMessage class]]) {
            
            RCDTestMessage *testMessage = (RCDTestMessage *)model.lastestMessage;
            textMessage = testMessage.title;
            
        }else if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]){
            
            RCTextMessage *message = (RCTextMessage *)model.lastestMessage;
            textMessage = message.content;
        }
        
        if (model.conversationType == ConversationType_GROUP) {
            
            RCGroup *groupInfo = [[RCIM sharedRCIM] getGroupInfoCache:model.targetId];
            if (groupInfo) {
                
                userName = groupInfo.groupName;
                portraitUri = groupInfo.portraitUri;
                
            }else{
                
                [RCDHTTPTOOL getGroupByID:model.targetId successCompletion:^(RCDGroupInfo *group) {
                    if (group == nil) {
                        
                        return ;
                    }
                    RCGroup *tempGroup= [RCGroup new];
                    tempGroup.groupName = group.groupName;
                    tempGroup.groupId = group.groupId;
                    tempGroup.portraitUri = group.portraitUri;
                    [[RCDataBaseManager shareInstance] insertGroupToDB:group];
                    [weakSelf.conversationListTableView
                     reloadRowsAtIndexPaths:@[ indexPath ]
                     withRowAnimation:
                     UITableViewRowAnimationAutomatic];
                }];
            }
            
        }else if (model.conversationType == ConversationType_PRIVATE){
            RCUserInfo *userInfo = [[RCIM sharedRCIM] getUserInfoCache:model.targetId];
            if (userInfo) {
                userName = userInfo.name;
                portraitUri = userInfo.portraitUri;
            } else {
                
                [RCDHTTPTOOL
                 getUserInfoByUserID:model.targetId
                 completion:^(RCUserInfo *user) {
                     if (user == nil) {
                         return;
                     }
                     RCDUserInfo *rcduserinfo_ = [RCDUserInfo new];
                     rcduserinfo_.name = user.name;
                     rcduserinfo_.userId = user.userId;
                     rcduserinfo_.portraitUri = user.portraitUri;
                     [[RCDataBaseManager shareInstance] insertUserToDB:userInfo];
                     [weakSelf.conversationListTableView
                      reloadRowsAtIndexPaths:@[ indexPath ]
                      withRowAnimation:
                      UITableViewRowAnimationAutomatic];
                 }];
            }
            
        }
    }

    RCDChatListCell *cell =
    [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault
                           reuseIdentifier:@""];
    cell.userName = userName;
    if ([portraitUri hasPrefix:@"http"]) {
        
        portraitUri = [portraitUri stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    }else if(portraitUri){
        
        portraitUri = [@"" stringByAppendingString:portraitUri];
    }
    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri]
                  placeholderImage:[UIImage imageNamed:@"system_notice"]];
    cell.labelTime.text = [RCKitUtility ConvertMessageTime:model.sentTime/1000];
    cell.model = model;
    return cell;
}

//*********************插入自定义Cell*********************//

#pragma mark - 收到消息监听
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    __weak typeof(&*self) blockSelf_ = self;
    //处理好友请求
    RCMessage *message = notification.object;
    if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        
        if (message.conversationType != ConversationType_SYSTEM) {
            NSLog(@"好友消息要发系统消息！！！");
#if DEBUG
            @throw [[NSException alloc]
                    initWithName:@"error"
                    reason:@"好友消息要发系统消息！！！"
                    userInfo:nil];
#endif
        }
        RCContactNotificationMessage *_contactNotificationMsg =
        (RCContactNotificationMessage *)message.content;
        if (_contactNotificationMsg.sourceUserId == nil ||
            _contactNotificationMsg.sourceUserId.length == 0) {
            return;
        }
        //该接口需要替换为从消息体获取好友请求的用户信息
        [RCDHTTPTOOL
         getUserInfoByUserID:_contactNotificationMsg.sourceUserId
         completion:^(RCUserInfo *user) {
             RCDUserInfo *rcduserinfo_ = [RCDUserInfo new];
             rcduserinfo_.name = user.name;
             rcduserinfo_.userId = user.userId;
             rcduserinfo_.portraitUri = user.portraitUri;
             
             RCConversationModel *customModel = [RCConversationModel new];
             customModel.conversationModelType =
             RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
             customModel.extend = rcduserinfo_;
             customModel.conversationType = message.conversationType;
             customModel.targetId = message.targetId;
             customModel.sentTime = message.sentTime;
             customModel.receivedTime = message.receivedTime;
             customModel.senderUserId = message.senderUserId;
             customModel.lastestMessage = _contactNotificationMsg;
             //[_myDataSource insertObject:customModel atIndex:0];
             
             // local cache for userInfo
             NSDictionary *userinfoDic = @{
                                           @"username" : rcduserinfo_.name,
                                           @"portraitUri" : rcduserinfo_.portraitUri
                                           };
             [[NSUserDefaults standardUserDefaults]
              setObject:userinfoDic
              forKey:_contactNotificationMsg.sourceUserId];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 //调用父类刷新未读消息数
                 [blockSelf_
                  refreshConversationTableViewWithConversationModel:
                  customModel];
                 [self notifyUpdateUnreadMessageCount];
                 
                 //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
                 //原因请查看super didReceiveMessageNotification的注释。
                 NSNumber *left =
                 [notification.userInfo objectForKey:@"left"];
                 if (0 == left.integerValue) {
                     [super refreshConversationTableViewIfNeeded];
                 }
             });
         }];
    } else {
        //调用父类刷新未读消息数
        [super didReceiveMessageNotification:notification];
    }
}
- (void)didTapCellPortrait:(RCConversationModel *)model {
//    if (model.conversationModelType ==
//        RC_CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE) {
//        RCDChatViewController *_conversationVC =
//        [[RCDChatViewController alloc] init];
//        _conversationVC.conversationType = model.conversationType;
//        _conversationVC.targetId = model.targetId;
//        _conversationVC.userName = model.conversationTitle;
//        _conversationVC.title = model.conversationTitle;
//        _conversationVC.conversation = model;
//        _conversationVC.unReadMessage = model.unreadMessageCount;
//        [self.navigationController pushViewController:_conversationVC animated:YES];
//    }
    
//    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
//        RCDChatViewController *_conversationVC =
//        [[RCDChatViewController alloc] init];
//        _conversationVC.conversationType = model.conversationType;
//        _conversationVC.targetId = model.targetId;
//        _conversationVC.userName = model.conversationTitle;
//        _conversationVC.title = model.conversationTitle;
//        _conversationVC.conversation = model;
//        _conversationVC.unReadMessage = model.unreadMessageCount;
//        _conversationVC.enableNewComingMessageIcon = YES; //开启消息提醒
//        _conversationVC.enableUnreadMessageIcon = YES;
//        if (model.conversationType == ConversationType_SYSTEM) {
//            _conversationVC.userName = @"系统消息";
//            _conversationVC.title = @"系统消息";
//        }
//        if ([model.objectName isEqualToString:@"RC:ContactNtf"]) {
//            RCDAddressBookViewController *addressBookVC = [RCDAddressBookViewController addressBookViewController];
//            addressBookVC.needSyncFriendList = YES;
//            [self.navigationController pushViewController:addressBookVC animated:YES];
//            return;
//        }
//        //如果是单聊，不显示发送方昵称
//        if (model.conversationType == ConversationType_PRIVATE) {
//            _conversationVC.displayUserNameInCell = NO;
//        }
//        [self.navigationController pushViewController:_conversationVC animated:YES];
//    }
//    
//    //聚合会话类型，此处自定设置。
//    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
//        
//        RCDChatListViewController *temp = [[RCDChatListViewController alloc] init];
//        NSArray *array = [NSArray
//                          arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
//        [temp setDisplayConversationTypes:array];
//        [temp setCollectionConversationType:nil];
//        temp.isEnteredToCollectionViewController = YES;
//        [self.navigationController pushViewController:temp animated:YES];
//    }
//    
//    //自定义会话类型
//    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION) {
//        //        RCConversationModel *model =
//        //        self.conversationListDataSource[indexPath.row];
//        
//        if ([model.objectName isEqualToString:@"RC:ContactNtf"]) {
//            RCDAddressBookViewController *addressBookVC = [RCDAddressBookViewController addressBookViewController];
//            [self.navigationController pushViewController:addressBookVC animated:YES];
//        }
//    }
}
/*
 //会话有新消息通知的时候显示数字提醒，设置为NO,不显示数字只显示红点
 -(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
 atIndexPath:(NSIndexPath *)indexPath
 {
 RCConversationModel *model=
 self.conversationListDataSource[indexPath.row];
 if (model.conversationType == ConversationType_PRIVATE) {
 ((RCConversationCell *)cell).isShowNotificationNumber = NO;
 }
 }
 */
- (void)notifyUpdateUnreadMessageCount {
    [self updateBadgeValueForTabBarItem];
}

- (void)updateBadgeValueForTabBarItem {
//    __weak typeof(self) __weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient]
                     getUnreadCount:self.displayConversationTypeArray];
        if (count > 0) {
            //      __weakSelf.tabBarItem.badgeValue =
            //          [[NSString alloc] initWithFormat:@"%d", count];
            //TODO:设置角标
            
        } else {
            //      __weakSelf.tabBarItem.badgeValue = nil;
            
        }
        
    });
}

- (void)receiveNeedRefreshNotification:(NSNotification *)status {
    __weak typeof(&*self) __blockSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (__blockSelf.displayConversationTypeArray.count == 1 &&
            [self.displayConversationTypeArray[0] integerValue] ==
            ConversationType_DISCUSSION) {
            [__blockSelf refreshConversationTableViewIfNeeded];
        }
        
    });
}

-(void)checkVersion
{
    [RCDHTTPTOOL getVersioncomplete:^(NSDictionary *versionInfo) {
        if (versionInfo) {
            NSString *isNeedUpdate = [versionInfo objectForKey:@"isNeedUpdate"];
            NSString *finalURL;
            if ([isNeedUpdate isEqualToString:@"YES"]) {
//                __weak typeof(self) __weakSelf = self;
                //获取系统当前的时间戳
                NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval now = [dat timeIntervalSince1970] * 1000;
                NSString *timeString = [NSString stringWithFormat:@"%f", now];
                //为html增加随机数，避免缓存。
                NSString *applist = [versionInfo objectForKey:@"applist"];
                applist = [NSString stringWithFormat:@"%@?%@",applist,timeString];
                finalURL = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",applist];
            }
            [[NSUserDefaults standardUserDefaults] setObject:finalURL forKey:@"applistURL"];
            [[NSUserDefaults standardUserDefaults] setObject:isNeedUpdate forKey:@"isNeedUpdate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
}

- (void)pushToCreateDiscussion:(id)sender {
   
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    NSIndexPath *indexPath = [self.conversationListTableView indexPathForRowAtPoint:scrollView.contentOffset];
    self.index = indexPath.row;
}


-(void) GotoNextCoversation
{
    NSUInteger i;
    //设置contentInset是为了滚动到底部的时候，避免conversationListTableView自动回滚。
    self.conversationListTableView.contentInset = UIEdgeInsetsMake(0, 0, self.conversationListTableView.frame.size.height, 0);
    for (i = self.index + 1; i < self.conversationListDataSource.count; i++) {
        RCConversationModel *model = self.conversationListDataSource[i];
        if (model.unreadMessageCount > 0) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            self.index = i;
            [self.conversationListTableView scrollToRowAtIndexPath:scrollIndexPath
                                                  atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        }
    }
    //滚动到起始位置
    if (i >= self.conversationListDataSource.count) {
        //    self.conversationListTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        for (i = 0; i < self.conversationListDataSource.count; i++) {
            RCConversationModel *model = self.conversationListDataSource[i];
            if (model.unreadMessageCount > 0) {
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                self.index = i;
                [self.conversationListTableView scrollToRowAtIndexPath:scrollIndexPath
                                                      atScrollPosition:UITableViewScrollPositionTop animated:YES];
                break;
            }
        }
    }
}

- (void)updateForSharedMessageInsertSuccess{
    [self refreshConversationTableViewIfNeeded];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)onSearchCancelClick{
    [self.searchNavigationController.view removeFromSuperview];
    [self.searchNavigationController removeFromParentViewController];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self refreshConversationTableViewIfNeeded];
}

-(void)refreshCell:(NSNotification *)notify
{
    /*
     NSString *row = [notify object];
     RCConversationModel *model = [self.conversationListDataSource objectAtIndex:[row intValue]];
     model.unreadMessageCount = 0;
     NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[row integerValue] inSection:0];
     dispatch_async(dispatch_get_main_queue(), ^{
     [self.conversationListTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
     });
     */
    [self refreshConversationTableViewIfNeeded];
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
