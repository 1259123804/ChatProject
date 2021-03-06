//
//  AppDelegate.m
//  ChatProject
//
//  Created by Duke Li on 2018/7/20.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "AppDelegate.h"
#import "RCDRCIMDataSource.h"
#import "XGLoginPasswordViewController.h"
#import "AFHttpTool.h"
#import "RCDHTTPTOOL.h"
#import "RCDataBaseManager.h"
#import "RCDUtilities.h"
#import "RCDSettingUserDefaults.h"
#import "RCIM.h"
#import "RCDTestMessage.h"
#import "XGLeftChoiceViewController.h"
#define RONGCLOUD_IM_APPKEY @"pkfcgjstpoad8"
@interface AppDelegate ()<RCIMConnectionStatusDelegate, RCIMReceiveMessageDelegate>
//@property (nonatomic, strong) XGLoginPasswordViewController *loginViewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    MyTools *tool = [MyTools defaultTools];
    [tool getLocation];
    /**
     *  推送说明：
     *
     我们在知识库里还有推送调试页面加了很多说明，当遇到推送问题时可以去知识库里搜索还有查看推送测试页面的说明。
     *
     首先必须设置deviceToken，可以搜索本文件关键字“推送处理”。模拟器是无法获取devicetoken，也就没有推送功能。
     *
     当使用"开发／测试环境"的appkey测试推送时，必须用Development的证书打包，并且在后台上传"开发／测试环境"的推送证书，证书必须是development的。
     当使用"生产／线上环境"的appkey测试推送时，必须用Distribution的证书打包，并且在后台上传"生产／线上环境"的推送证书，证书必须是distribution的。
     */
    [[RCIM sharedRCIM]initWithAppKey:RONGCLOUD_IM_APPKEY];
    /* RedPacket_FTR  */
    //需要在info.plist加上您的红包的scheme，注意一定不能与其它应用重复
    //设置扩展Module的Url Scheme。
    [[RCIM sharedRCIM] setScheme:@"rongCloudRedPacket" forExtensionModule:@"JrmfPacketManager"];
    
    // 注册自定义测试消息
    [[RCIM sharedRCIM] registerMessageType:[RCDTestMessage class]];
    
    //设置会话列表头像和会话页面头像
    
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    [RCIMClient sharedRCIMClient].logLevel = RC_Log_Level_Info;
    
    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
    //    [RCIM sharedRCIM].portraitImageViewCornerRadius = 10;
    //开启用户信息和群组信息的持久化
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    //设置用户信息源和群组信息源
    [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
    [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
    
    //设置群组内用户信息源。如果不使用群名片功能，可以不设置
    //  [RCIM sharedRCIM].groupUserInfoDataSource = RCDDataSource;
    //  [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    //    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(46, 46);
    //开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus = YES;
    
    //开启发送已读回执
    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList = @[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP)];
    
    //开启多端未读状态同步
    [RCIM sharedRCIM].enableSyncReadStatus = YES;
    
    //设置显示未注册的消息
    //如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
    [RCIM sharedRCIM].showUnkownMessage = YES;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
    
    //群成员数据源
    [RCIM sharedRCIM].groupMemberDataSource = RCDDataSource;
    
    //开启消息@功能（只支持群聊和讨论组, App需要实现群成员数据源groupMemberDataSource）
    [RCIM sharedRCIM].enableMessageMentioned = YES;
    
    //开启消息撤回功能
    [RCIM sharedRCIM].enableMessageRecall = YES;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
    //  设置头像为圆形
    //  [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    //  [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    //   设置优先使用WebView打开URL
    //  [RCIM sharedRCIM].embeddedWebViewPreferred = YES;
    
    //  设置通话视频分辨率
    //  [[RCCallClient sharedRCCallClient] setVideoProfile:RC_VIDEO_PROFILE_480P];
    
    //设置Log级别，开发阶段打印详细log
    [RCIMClient sharedRCIMClient].logLevel = RC_Log_Level_Info;
    
    
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    /**
     * 统计推送打开率1
     */
    [[RCIMClient sharedRCIMClient] recordLaunchOptionsEvent:launchOptions];
    /**
     * 获取融云推送服务扩展字段1
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient]
                                     getPushExtraFromLaunchOptions:launchOptions];
    if (pushServiceData) {
        NSLog(@"该启动事件包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"%@", pushServiceData[key]);
        }
    } else {
        NSLog(@"该启动事件不包含来自融云的推送服务");
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureRcimSetting) name:kNotificationName_loginSuccess object:nil];
    if (!DefaultsValueForKey(kUser_token)){
        XGLoginPasswordViewController *loginViewController = [[XGLoginPasswordViewController alloc] init];
        self.window.rootViewController = loginViewController;
//        [self.window.rootViewController presentViewController:loginViewController animated:YES completion:^{
//
//            MyAlertView(@"请登录", nil);
//        }];
    }else{
        XGLeftChoiceViewController *leftChoiceController = [[XGLeftChoiceViewController alloc] init];
        XGMainTabbarViewController *tabbarController = [[XGMainTabbarViewController alloc] init];
        self.leftSliderController = [[XGLeftSliderViewController alloc] initWithLeftView:leftChoiceController andMainView:tabbarController];
        self.window.rootViewController = self.leftSliderController;
        [self configureRcimSetting];
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (XGLoginPasswordViewController *)loginViewController{
//
//    if (_loginViewController == nil){
//
//        _loginViewController = [[XGLoginPasswordViewController alloc] init];
//    }
//    return _loginViewController;
//}

- (void)configureRcimSetting{
    
    //登录
    NSString *token = [DEFAULTS objectForKey:kUser_RCIMToken];
    NSString *userId = [DEFAULTS objectForKey:kUser_id];
    NSString *userName = [DEFAULTS objectForKey:kUser_name];
    //NSString *password = [DEFAULTS objectForKey:@"userPwd"];
    NSString *userNickName = [DEFAULTS objectForKey:kUser_name];
    NSString *userPortraitUri = [DEFAULTS objectForKey:kUser_avatar];
    [self insertSharedMessageIfNeed];
    RCUserInfo *_currentUserInfo =
    [[RCUserInfo alloc] initWithUserId:userId
                                  name:userNickName
                              portrait:userPortraitUri];
    [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        
        //登录demoserver成功之后才能调demo 的接口
        [RCDDataSource syncGroups];
        [RCDDataSource syncFriendList:userId complete:^(NSMutableArray *result){
            
        }];
        
    }error:^(RCConnectErrorCode status) {
        [RCDDataSource syncGroups];
        NSLog(@"connect error %ld", (long)status);
        
    }tokenIncorrect:^{
        
        NSString *rcimToken = DefaultsValueForKey(kUser_RCIMToken);
        [[RCIM sharedRCIM] connectWithToken:rcimToken success:^(NSString *userId) {
            
            NSLog(@"链接成功");
            
        } error:^(RCConnectErrorCode status) {
            [self gotoLoginViewAndDisplayReasonInfo:@"登录失效，请重新登录。"];
        } tokenIncorrect:^{
            [self gotoLoginViewAndDisplayReasonInfo:@"无法连接到服务器"];
            NSLog(@"Token无效");
        }];
        
    }];
}


/**
 * 推送处理2
 */
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
#if TARGET_IPHONE_SIMULATOR
    // 模拟器不能使用远程推送
#else
    // 请检查App的APNs的权限设置，更多内容可以参考文档
    // http://www.rongcloud.cn/docs/ios_push.html。
    NSLog(@"获取DeviceToken失败！！！");
    NSLog(@"ERROR：%@", error);
#endif
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

/**
 * 推送处理4
 * userInfo内容请参考官网文档
 */
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    /**
     * 统计推送打开率2
     */
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    /**
     * 获取融云推送服务扩展字段2
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient]
                                     getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    /**
     * 统计推送打开率3
     */
    [[RCIMClient sharedRCIMClient] recordLocalNotificationEvent:notification];
    
    //  //震动
    //  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //  AudioServicesPlaySystemSound(1007);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
    RCConnectionStatus status = [[RCIMClient sharedRCIMClient] getConnectionStatus];
    if (status != ConnectionStatus_SignUp) {
        int unreadMsgCount = [[RCIMClient sharedRCIMClient]
                              getUnreadCount:@[
                                               @(ConversationType_PRIVATE),
                                               @(ConversationType_DISCUSSION),
                                               @(ConversationType_APPSERVICE),
                                               @(ConversationType_PUBLICSERVICE),
                                               @(ConversationType_GROUP)
                                               ]];
        application.applicationIconBadgeNumber = unreadMsgCount;
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    //  int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
    //    @(ConversationType_PRIVATE),
    //    @(ConversationType_DISCUSSION),
    //    @(ConversationType_APPSERVICE),
    //    @(ConversationType_PUBLICSERVICE),
    //    @(ConversationType_GROUP)
    //  ]];
    //  application.applicationIconBadgeNumber = unreadMsgCount;
    
    // 为消息分享保存会话信息
    [self saveConversationInfoForMessageShare];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state;
    // here you can undo many of the changes made on entering the background.
    if ([[RCIMClient sharedRCIMClient] getConnectionStatus] == ConnectionStatus_Connected) {
        // 插入分享消息
        [self insertSharedMessageIfNeed];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
}

//插入分享消息
- (void)insertSharedMessageIfNeed {
    NSUserDefaults *shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.rongcloud.im.share"];
    
    NSArray *sharedMessages = [shareUserDefaults valueForKey:@"sharedMessages"];
    if (sharedMessages.count > 0) {
        for (NSDictionary *sharedInfo in sharedMessages) {
            RCRichContentMessage *richMsg = [[RCRichContentMessage alloc]init];
            richMsg.title = [sharedInfo objectForKey:@"title"];
            richMsg.digest = [sharedInfo objectForKey:@"content"];
            richMsg.url = [sharedInfo objectForKey:@"url"];
            richMsg.imageURL = [sharedInfo objectForKey:@"imageURL"];
            richMsg.extra = [sharedInfo objectForKey:@"extra"];
            //      long long sendTime = [[sharedInfo objectForKey:@"sharedTime"] longLongValue];
            //      RCMessage *message = [[RCIMClient sharedRCIMClient] insertOutgoingMessage:[[sharedInfo objectForKey:@"conversationType"] intValue] targetId:[sharedInfo objectForKey:@"targetId"] sentStatus:SentStatus_SENT content:richMsg sentTime:sendTime];
            RCMessage *message = [[RCIMClient sharedRCIMClient] insertOutgoingMessage:[[sharedInfo objectForKey:@"conversationType"] intValue] targetId:[sharedInfo objectForKey:@"targetId"] sentStatus:SentStatus_SENT content:richMsg];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RCDSharedMessageInsertSuccess" object:message];
        }
        [shareUserDefaults removeObjectForKey:@"sharedMessages"];
        [shareUserDefaults synchronize];
    }
}

//为消息分享保存会话信息
- (void)saveConversationInfoForMessageShare {
    NSArray *conversationList = [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE), @(ConversationType_GROUP)]];
    
    NSMutableArray *conversationInfoList = [[NSMutableArray alloc] init];
    if (conversationList.count > 0) {
        for (RCConversation *conversation in conversationList) {
            NSMutableDictionary *conversationInfo = [NSMutableDictionary dictionary];
            [conversationInfo setValue:conversation.targetId forKey:@"targetId"];
            [conversationInfo setValue:@(conversation.conversationType) forKey:@"conversationType"];
            if (conversation.conversationType == ConversationType_PRIVATE) {
                RCUserInfo * user = [[RCIM sharedRCIM] getUserInfoCache:conversation.targetId];
                [conversationInfo setValue:user.name forKey:@"name"];
                [conversationInfo setValue:user.portraitUri forKey:@"portraitUri"];
            }else if (conversation.conversationType == ConversationType_GROUP){
                RCGroup *group = [[RCIM sharedRCIM] getGroupInfoCache:conversation.targetId];
                [conversationInfo setValue:group.groupName forKey:@"name"];
                [conversationInfo setValue:group.portraitUri forKey:@"portraitUri"];
            }
            [conversationInfoList addObject:conversationInfo];
        }
    }
    NSURL *sharedURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.cn.rongcloud.im.share"];
    NSURL *fileURL = [sharedURL URLByAppendingPathComponent:@"rongcloudShare.plist"];
    [conversationInfoList writeToURL:fileURL atomically:YES];
    
    NSUserDefaults *shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.rongcloud.im.share"];
    [shareUserDefaults setValue:[RCIM sharedRCIM].currentUserInfo.userId forKey:@"currentUserId"];
    [shareUserDefaults setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserCookies"] forKey:@"Cookie"];
    [shareUserDefaults synchronize];
}

- (void)redirectNSlogToDocumentFolder {
    NSLog(@"Log重定向到本地，如果您需要控制台Log，注释掉重定向逻辑即可。");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    [self removeExpireLogFiles:documentDirectory];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MMddHHmmss"];
    NSString *formattedDate = [dateformatter stringFromDate:currentDate];
    
    NSString *fileName = [NSString stringWithFormat:@"rc%@.log", formattedDate];
    NSString *logFilePath =
    [documentDirectory stringByAppendingPathComponent:fileName];
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+",
            stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+",
            stderr);
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    NSNumber *left = [notification.userInfo objectForKey:@"left"];
    if ([RCIMClient sharedRCIMClient].sdkRunningMode ==
        RCSDKRunningMode_Background &&
        0 == left.integerValue) {
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                             @(ConversationType_PRIVATE),
                                                                             @(ConversationType_DISCUSSION),
                                                                             @(ConversationType_APPSERVICE),
                                                                             @(ConversationType_PUBLICSERVICE),
                                                                             @(ConversationType_GROUP)
                                                                             ]];
        [UIApplication sharedApplication].applicationIconBadgeNumber =
        unreadMsgCount;
    }
}

- (void)application:(UIApplication *)application
handleWatchKitExtensionRequest:(NSDictionary *)userInfo
              reply:(void (^)(NSDictionary *))reply {
   
}
#pragma mark - RCWKAppInfoProvider
- (NSString *)getAppName {
    return @"融云";
}

- (NSString *)getAppGroups {
    return @"group.cn.rongcloud.im.WKShare";
}

- (NSArray *)getAllUserInfo {
    return [RCDDataSource getAllUserInfo:^{
        //[[RCWKNotifier sharedWKNotifier] notifyWatchKitUserInfoChanged];
    }];
}
- (NSArray *)getAllGroupInfo {
    return [RCDDataSource getAllGroupInfo:^{
        //[[RCWKNotifier sharedWKNotifier] notifyWatchKitGroupChanged];
    }];
}
- (NSArray *)getAllFriends {
    return [RCDDataSource getAllFriends:^{
        //[[RCWKNotifier sharedWKNotifier] notifyWatchKitFriendChanged];
    }];
}
- (void)openParentApp {
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:@"rongcloud://connect"]];
}
- (BOOL)getNewMessageNotificationSound {
    return ![RCIM sharedRCIM].disableMessageAlertSound;
}
- (void)setNewMessageNotificationSound:(BOOL)on {
    [RCIM sharedRCIM].disableMessageAlertSound = !on;
}
- (void)logout {

    [[RCIMClient sharedRCIMClient] disconnect:NO];
}
- (BOOL)getLoginStatus {
    NSString *token = [DEFAULTS stringForKey:@"userToken"];
    if (token.length) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - RCIMConnectionStatusDelegate

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:
                              @"您的帐号在别的设备上登录，"
                              @"您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
//        XGMainLoginViewController
//        xglogin *loginVC = [[RCDLoginViewController alloc] init];
//        RCDNavigationViewController *_navi = [[RCDNavigationViewController alloc]
//                                              initWithRootViewController:loginVC];
//        self.window.rootViewController = _navi;
    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
        [AFHttpTool getTokenSuccess:^(id response) {
            NSString *token = response[@"result"][@"token"];
            [[RCIM sharedRCIM] connectWithToken:token
                                        success:^(NSString *userId) {
                                            
                                        } error:^(RCConnectErrorCode status) {
                                            
                                        } tokenIncorrect:^{
                                            
                                        }];
        }
                            failure:^(NSError *err) {
                                
                            }];
    }
}

-(BOOL)onRCIMCustomLocalNotification:(RCMessage*)message
                      withSenderName:(NSString *)senderName{
    //群组通知不弹本地通知
    if ([message.content isKindOfClass:[RCGroupNotificationMessage class]]) {
        return YES;
    }
    return NO;
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    if ([message.content
         isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *msg =
        (RCInformationNotificationMessage *)message.content;
        // NSString *str = [NSString stringWithFormat:@"%@",msg.message];
        if ([msg.message rangeOfString:@"你已添加了"].location != NSNotFound) {
            [RCDDataSource syncFriendList:[RCIM sharedRCIM].currentUserInfo.userId
                                 complete:^(NSMutableArray *friends){
                                 }];
        }
    } else if ([message.content
                isMemberOfClass:[RCContactNotificationMessage class]]) {
        RCContactNotificationMessage *msg =
        (RCContactNotificationMessage *)message.content;
        if ([msg.operation
             isEqualToString:
             ContactNotificationMessage_ContactOperationAcceptResponse]) {
            [RCDDataSource syncFriendList:[RCIM sharedRCIM].currentUserInfo.userId
                                 complete:^(NSMutableArray *friends){
                                 }];
        }
    } else if ([message.content
                isMemberOfClass:[RCGroupNotificationMessage class]]) {
        RCGroupNotificationMessage *msg =
        (RCGroupNotificationMessage *)message.content;
        if ([msg.operation isEqualToString:@"Dismiss"] &&
            [msg.operatorUserId
             isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
                [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP
                                                    targetId:message.targetId];
                [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP
                                                         targetId:message.targetId];
            } else if ([msg.operation isEqualToString:@"Quit"]   ||
                       [msg.operation isEqualToString:@"Add"]    ||
                       [msg.operation isEqualToString:@"Kicked"] ||
                       [msg.operation isEqualToString:@"Rename"]) {
                if (![msg.operation isEqualToString:@"Rename"]) {
                    [RCDHTTPTOOL getGroupMembersWithGroupId:message.targetId
                                                      Block:^(NSMutableArray *result) {
                                                          [[RCDataBaseManager shareInstance]
                                                           insertGroupMemberToDB:result
                                                           groupId:message.targetId
                                                           complete:^(BOOL results) {
                                                               
                                                           }];
                                                      }];
                }
                [RCDHTTPTOOL getGroupByID:message.targetId
                        successCompletion:^(RCDGroupInfo *group) {
                            [[RCDataBaseManager shareInstance] insertGroupToDB:group];
                            [[RCIM sharedRCIM] refreshGroupInfoCache:group
                                                         withGroupId:group.groupId];
                            [[NSNotificationCenter defaultCenter]
                             postNotificationName:@"UpdeteGroupInfo"
                             object:message.targetId];
                        }];
            }
    }
}

/* RedPacket_FTR  */
//如果您使用了红包等融云的第三方扩展，请实现下面两个openURL方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if ([[RCIM sharedRCIM] openExtensionModuleUrl:url]) {
        return YES;
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[RCIM sharedRCIM] openExtensionModuleUrl:url]) {
        return YES;
    }
    return YES;
}

//设置群组通知消息没有提示音
-(BOOL)onRCIMCustomAlertSound:(RCMessage*)message
{
    //当应用处于前台运行，收到消息不会有提示音。
    //  if ([message.content isMemberOfClass:[RCGroupNotificationMessage class]]) {
    return YES;
    //  }
    //  return NO;
}

- (void)loginSuccess:(NSString *)userName
              userId:(NSString *)userId
               token:(NSString *)token
            password:(NSString *)password {
    //保存默认用户
    [DEFAULTS setObject:userName forKey:@"userName"];
    [DEFAULTS setObject:password forKey:@"userPwd"];
    [DEFAULTS setObject:token forKey:@"userToken"];
    [DEFAULTS setObject:userId forKey:@"userId"];
    [DEFAULTS synchronize];
    //保存“发现”的信息
    [RCDHTTPTOOL getSquareInfoCompletion:^(NSMutableArray *result) {
        [DEFAULTS setObject:result forKey:@"SquareInfoList"];
        [DEFAULTS synchronize];
    }];
    
    [AFHttpTool getUserInfo:userId
                    success:^(id response) {
                        if ([response[@"code"] intValue] == 200) {
                            NSDictionary *result = response[@"result"];
                            NSString *nickname = result[@"nickname"];
                            NSString *portraitUri = result[@"portraitUri"];
                            RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId
                                                                             name:nickname
                                                                         portrait:portraitUri];
                            if (!user.portraitUri || user.portraitUri.length <= 0) {
                                user.portraitUri = [RCDUtilities defaultUserPortrait:user];
                            }
                            [[RCDataBaseManager shareInstance] insertUserToDB:user];
                            [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
                            [RCIM sharedRCIM].currentUserInfo = user;
                            [DEFAULTS setObject:user.portraitUri forKey:@"userPortraitUri"];
                            [DEFAULTS setObject:user.name forKey:@"userNickName"];
                            [DEFAULTS synchronize];
                        }
                    }
                    failure:^(NSError *err){
                        
                    }];
    //同步群组
    [RCDDataSource syncGroups];
    [RCDDataSource syncFriendList:userId
                         complete:^(NSMutableArray *friends){
                         }];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        RCDMainTabBarViewController *mainTabBarVC = [[RCDMainTabBarViewController alloc] init];
//        RCDNavigationViewController *rootNavi = [[RCDNavigationViewController alloc] initWithRootViewController:mainTabBarVC];
//        self.window.rootViewController = rootNavi;
//
//    });
}

-(void)gotoLoginViewAndDisplayReasonInfo:(NSString *)reason
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:nil
                                   message:reason
                                  delegate:nil
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil, nil];
        ;
        [alertView show];
//        RCDLoginViewController *loginVC =
//        [[RCDLoginViewController alloc] init];
//        RCDNavigationViewController *_navi = [[RCDNavigationViewController alloc]
//                                              initWithRootViewController:loginVC];
//        self.window.rootViewController = _navi;
        
    });
}

-(void)removeExpireLogFiles:(NSString *)logPath {
    //删除超过时间的log文件
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *fileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:logPath error:nil]];
//    NSDate *currentDate = [NSDate date];
//    //NSDate *expireDate = [NSDate dateWithTimeIntervalSinceNow: LOG_EXPIRE_TIME];
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *fileComp = [[NSDateComponents alloc] init];
//    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//    fileComp = [calendar components:unitFlags fromDate:currentDate];
//    for (NSString *fileName in fileList) {
//        //rcMMddHHmmss.log length is 16
//        if (fileName.length != 16) {
//            continue;
//        }
//        if (![[fileName substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"rc"]) {
//            continue;
//        }
//        int month = [[fileName substringWithRange:NSMakeRange(2, 2)] intValue];
//        int date = [[fileName substringWithRange:NSMakeRange(4, 2)] intValue];
//        if (month > 0) {
//            [fileComp setMonth:month];
//        } else {
//            continue;
//        }
//        if (date > 0) {
//            [fileComp setDay:date];
//        } else {
//            continue;
//        }
//        NSDate *fileDate = [calendar dateFromComponents:fileComp];
//
//        if ([fileDate compare:currentDate] == NSOrderedDescending || [fileDate compare:expireDate] == NSOrderedAscending) {
//            [fileManager removeItemAtPath:[logPath stringByAppendingPathComponent:fileName] error:nil];
//        }
//    }
    
}

@end
