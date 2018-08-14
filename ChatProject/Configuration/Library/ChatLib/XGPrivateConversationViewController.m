//
//  XGPrivateConversationViewController.m
//  BonDay
//
//  Created by Duke Li on 2017/5/4.
//  Copyright © 2017年 Bonday. All rights reserved.
//

#import "XGPrivateConversationViewController.h"
#import "UIView+SDAutoLayout.h"
#import "RCDTestMessage.h"
#import "RCDTestMessageCell.h"
#import "RCDMessageContentModel.h"
#import "RCDMessageContentModel.h"
#import "RCDRCIMDataSource.h"
#import "RCDataBaseManager.h"

@interface XGPrivateConversationViewController ()<RCMessageCellDelegate>

@end

@implementation XGPrivateConversationViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.ispushed) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    if (self.ispushed) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}


- (void)backItemClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendCourseMessage{
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"] isEqualToString:self.targetId]){
        
        return;
    }
    
    
    NSMutableDictionary *dataDics = [NSMutableDictionary dictionary];
//    [dataDics setObject:self.targetId forKey:@"toUserId"];
//    [dataDics setObject:_model.title forKey:@"title"];
//    [dataDics setObject:_model.images[0] forKey:@"image"];
//    [dataDics setObject:@"lesson" forKey:@"entityType"];
//    [dataDics setObject:_model.eid forKey:@"entityId"];
    if (self.isOneTwoOneed) {
        [dataDics setObject:[NSNumber numberWithInt:1] forKey:@"lessonType"];
    }
    NSDictionary *dataDic = @{@"data": dataDics};
    //TODO:发送自定义消息
    [MyAFSessionManager requestWithURLString:@"" parameters:dataDic requestType:MyRequestTypePost managerType:MyAFSessionManagerTypeJsonWithToken success:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] intValue] == 200) {
            
            
        }else if (responseObject[@"message"]){
            
            MyAlertView(responseObject[@"message"], nil);
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        MyAlertView(@"网络错误", nil);
    }];
    
}

- (NSInteger)calculateWeek:(NSDate *)date{
    //计算week数
    NSCalendar * myCalendar = [NSCalendar currentCalendar];
    myCalendar.timeZone = [NSTimeZone systemTimeZone];
    NSInteger week = [[myCalendar components:NSCalendarUnitWeekday fromDate:date] weekday];
    return week;
}

- (void)checkChatSupport{
    
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    [matter setDateFormat:@"HH"];
    NSInteger time = [[matter stringFromDate:[NSDate date]] integerValue];
    if ([self calculateWeek:[NSDate date]] != 1 && time >= 9 && time <= 18) {
        
        return;
    }
    //    RCTextMessage *textMessage = [RCTextMessage messageWithContent:@"您好，我们的工作时间是周一至周六的 9:00 - 18:00, 您可以先留言，我们会尽快答复。"];
    //
    //    RCMessage *message = [[RCMessage alloc] init];
    //    message.conversationType = self.conversationType;
    //    message.messageId = -1;
    //    message.messageDirection = MessageDirection_RECEIVE;
    //    message.senderUserId = self.targetId;
    //    message.sentStatus = SentStatus_SENT;
    //    message.sentTime = [NSDate date].timeIntervalSince1970 * 1000;
    //    message.content = textMessage;
    //    [self appendAndDisplayMessage:message];
    RCInformationNotificationMessage  *warningMsg = [RCInformationNotificationMessage  notificationWithMessage:@"您好，我们的工作时间是周一至周六的 9:00 - 18:00, 您可以先留言，我们会尽快答复。" extra:nil];
    BOOL saveToDB = NO;  //是否保存到数据库中
    RCMessage *savedMsg ;
    if (saveToDB) {
        savedMsg = [[RCIMClient sharedRCIMClient] insertMessage:self.conversationType targetId:[RCIM sharedRCIM].currentUserInfo.userId senderUserId:self.targetId sendStatus:SentStatus_SENT content:warningMsg];
    } else {
        savedMsg =[[RCMessage alloc] initWithType:self.conversationType targetId:self.targetId direction:MessageDirection_RECEIVE messageId:-1 content:warningMsg];//注意messageId要设置为－1
        
    }
    [self appendAndDisplayMessage:savedMsg];
}

- (void)viewDidLoad {
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //输入框设置
    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER_EXTENTION];
    [self.pluginBoardView removeItemAtIndex:2];
    
    //
    ///注册自定义测试消息Cell
    [self registerClass:[RCDTestMessageCell class] forCellWithReuseIdentifier:@"RCDTestMessageCell"];
    
    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:DefaultsObjectForKey(@"user_id") name:DefaultsObjectForKey(@"display_name") portrait:DefaultsObjectForKey(@"avatar")];
    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userInfo.userId];
    //    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    //    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    //    [RCIM sharedRCIM].receiveMessageDelegate = self;
    if (self.ispushed) {
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ac_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backItemClick)];
        self.navigationItem.leftBarButtonItem = leftItem;
        
    }
    
    [self checkChatSupport];
    [self sendCourseMessage];
    //    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:kLocalFIle_courseFile];
    //    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    //
    //        NSMutableArray *tempArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    //        BOOL isFirst = YES;
    //        if (tempArray == nil) {
    //
    //            tempArray = [NSMutableArray array];
    //
    //        }else{
    //
    //            for (NSString *str in tempArray) {
    //
    //                if ([str isEqualToString:self.courseId]) {
    //
    //                    isFirst = NO;
    //                    break;
    //                }
    //            }
    //        }
    //        //判断是否是首次进入该课程的咨询界面
    //        if (isFirst) {
    //
    //            if (!_isSupport && self.model) {
    //
    //                [self sendCourseMessage];
    //                //加入新的课程ID
    //                [tempArray addObject:self.courseId];
    //            }
    //        }
    //        [NSKeyedArchiver archiveRootObject:tempArray toFile:filePath];
    //
    //    }else{
    //
    //        //TODO:发送自定义消息
    //        if (!_isSupport && self.model) {
    //
    //            [self sendCourseMessage];
    //            NSMutableArray *tempArray = [NSMutableArray arrayWithObjects:self.courseId, nil];
    //            [[NSFileManager defaultManager] createFileAtPath:filePath contents:[NSKeyedArchiver archivedDataWithRootObject:tempArray] attributes:nil];
    //        }
    //
    //    }
}




/*!
 发送消息到服务器
 * @param toUserId:发送给某个用户的id
 * @param content:发送给用户的信息
 */
//- (void)sendMessage:(RCMessageContent *)messageContent pushContent:(NSString *)pushContent{
//
//    if ([messageContent isMemberOfClass:[RCTextMessage class]]) {
//        RCTextMessage *textMsg = (RCTextMessage *)messageContent;
//        textMsg.extra = @"111";
//        NSDictionary *dataDic = @{@"data":@{@"content":textMsg.content,@"toUserId":self.targetId}};
//        NSString *urlStr = [KBonDay stringByAppendingString:KLessonChat_sendMessage];
//
//        [MyAFSessionManager requestWithURLString:urlStr parameters:dataDic requestType:MyRequestTypePost managerType:MyAFSessionManagerTypeJsonWithToken success:^(id  _Nullable responseObject) {
//
//            NSString *token = responseObject[@"code"];
//            if ([token integerValue] == 200) {
//                NSLog(@"消息发送成功");
//            }else if (responseObject[@"message"]){
//
//                MyAlertView(responseObject[@"message"], nil);
//            }else{
//
//                NSLog(@"消息发送失败");
//            }
//
//        } failure:^(NSError * _Nonnull error) {
//            NSLog(@"消息发送失败：%@",error);
//        }];
//    }
//
//}
- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageContent {
    if ([messageContent isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *textMsg = (RCTextMessage *)messageContent;
        textMsg.extra = @"111";
        NSDictionary *dataDic = @{@"data":@{@"content":textMsg.content,@"toUserId":self.targetId}};
        NSString *urlStr = @"";
        
        [MyAFSessionManager requestWithURLString:urlStr parameters:dataDic requestType:MyRequestTypePost managerType:MyAFSessionManagerTypeJsonWithToken success:^(id  _Nullable responseObject) {
            
            NSString *token = responseObject[@"code"];
            if ([token integerValue] == 200) {
                NSLog(@"消息发送成功");
            }else if (responseObject[@"message"]){
                
                MyAlertView(responseObject[@"message"], nil);
            }else{
                
                NSLog(@"消息发送失败");
            }
            
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"消息发送失败：%@",error);
        }];
#pragma  mark - 阻断消息传送
        
        messageContent = nil;
    }
    return messageContent;
}
/*!
 自定义消息Cell显示的回调
 
 @param collectionView  当前CollectionView
 @param indexPath       该Cell对应的消息Cell数据模型在数据源中的索引值
 @return                自定义消息需要显示的Cell
 
 @discussion 自定义消息如果需要显示，则必须先通过RCIM的registerMessageType:注册该自定义消息类型，
 并在会话页面中通过registerClass:forCellWithReuseIdentifier:注册该自定义消息的Cell，否则将此回调将不会被调用。
 */

-(RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RCMessageModel *model = self.conversationDataRepository[indexPath.row];
    NSString * cellIndentifier=@"RCDTestMessageCell";
    RCDTestMessageCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier           forIndexPath:indexPath];
    cell.delegate = self;
    [cell setDataModel:model];
    return cell;
}

- (CGSize)rcConversationCollectionView:(UICollectionView *)collectionView
                                layout:(UICollectionViewLayout *)collectionViewLayout
                sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    RCDTestMessageCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    RCMessageModel *model = self.conversationDataRepository[indexPath.row];
    return  [RCDTestMessageCell sizeForMessageModel:model withCollectionViewWidth:kScreenWidth referenceExtraHeight:80];
    //    return CGSizeMake(kScreenWidth-80, (kScreenWidth-80)*0.27);
}
-(void)didTapMessageCell:(RCMessageModel *)model{
    [super didTapMessageCell:model];
    if ([model.objectName isEqualToString:@"KM:BondayMsg"]) {
        RCDTestMessage *testMessage = (RCDTestMessage *)model.content;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:testMessage.entityType forKey:@"type"];
        [dic setObject:testMessage.entityId forKey:@"id"];
        
        if ([testMessage.lessonType integerValue] == 1) {
            [dic setObject:[NSNumber numberWithBool:YES] forKey:@"isOneTwoOneed"];
        }
    }
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
