//
//  TestChatListViewController.m
//  MyMVVM
//
//  Created by bonday012 on 17/3/13.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "TestChatListViewController.h"
#import "UIView+SDAutoLayout.h"
#import "RCDTestMessage.h"
#import "RCDTestMessageCell.h"
#import "RCDMessageContentModel.h"
#import "RCDMessageContentModel.h"
#import "RCDRCIMDataSource.h"
#import "RCDataBaseManager.h"
#import "RCDUserInfoManager.h"
#import "RCDHttpTool.h"
#import "RCDUtilities.h"

@interface TestChatListViewController ()<RCMessageCellDelegate>
@end

@implementation TestChatListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.defaultHistoryMessageCountOfChatRoom = 50;

}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
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
//    [RCIM sharedRCIM].receiveMessageDelegate = self;

//    [RCDDataSource syncGroups];
//    [RCDDataSource getAllGroupInfo:^{
//        
//    }];
//    [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:[DEFAULTS objectForKey:@"user_id"] completion:^(RCUserInfo *userInfo) {
//    }];
//    [[RCIM sharedRCIM].groupInfoDataSource getGroupInfoWithGroupId:self.groupIDStr completion:^(RCGroup *groupInfo) {
//        
//    }];
//    [RCDHTTPTOOL getGroupByID:self.targetId
//            successCompletion:^(RCDGroupInfo *group) {
//                NSLog(@"group:%@",group.groupName);
//                NSLog(@"group:%@",group.portraitUri);
//                RCGroup *Group =
//                [[RCGroup alloc] initWithGroupId:self.targetId
//                                       groupName:group.groupName
//                                     portraitUri:group.portraitUri];
//                [[RCIM sharedRCIM] refreshGroupInfoCache:Group
//                                             withGroupId:self.targetId];
//            }];
//    [[RCIM sharedRCIM]getUserInfoCache:[DEFAULTS objectForKey:@"user_id"]];
//    [[RCIM sharedRCIM]getGroupInfoCache:self.groupIDStr];
    [self refreshUserInfoOrGroupInfo];
    if (self.ispushed) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight)];
        headView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:headView];
        UILabel *label = [[UILabel alloc] init];
        [headView addSubview:label];
        label.sd_layout.topSpaceToView(headView,20)
        .centerXEqualToView(headView)
        .widthIs(200)
        .heightIs(40);
        label.textColor = UIColorWithRGBA(74, 74, 74, 1); 
        label.font = [UIFont systemFontOfSize:17.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.titleStr;
        //返回按钮
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, kNavBarHeight)];
        [headView addSubview:backView];
        UIImageView *backImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ac_back"]];
        [backView addSubview:backImageV];
        backImageV.userInteractionEnabled = YES;
        backImageV.contentMode = UIViewContentModeScaleAspectFit;
        backImageV.sd_layout.topSpaceToView(backView,26)
        .leftSpaceToView(backView,15)
        .widthIs(12)
        .heightIs(20);
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backImageViewClick)];
        [backView addGestureRecognizer:gesture];
    }
}
- (void)backImageViewClick{
    
}

- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageContent {
  if ([messageContent isMemberOfClass:[RCTextMessage class]]) {
     RCTextMessage *textMsg = (RCTextMessage *)messageContent;
     textMsg.extra = @"111";
      RCUserInfo *_currentUserInfo =
      [[RCUserInfo alloc] initWithUserId:DefaultsObjectForKey(@"user_id") name:DefaultsObjectForKey(@"display_name") portrait:[@"" stringByAppendingString:DefaultsObjectForKey(@"avatar")]];
      textMsg.senderUserInfo = _currentUserInfo;
//#pragma mark - 向自己的server发送消息
      NSArray *groupIDArr = @[self.groupIDStr];
      NSDictionary *dataDic = @{@"data":@{@"content":textMsg.content,@"groupIds":groupIDArr}};
      NSString *urlStr = [@"" stringByAppendingString:@"rong/publishGroupMessage"];
      [[NetTool shareManager] httpPostRequest:urlStr withParameter:dataDic success:^(NSDictionary *dataDic) {
//          NSDictionary *dic =dataDic;
          NSString *token = dataDic[@"code"];
          if ([token integerValue] == 200) {
              NSLog(@"消息发送成功");
          }else{
              MyAlertView(dataDic[@"message"], nil);
          }

      } failure:^(NSError *error) {
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
    NSMutableArray *dataArr = self.conversationDataRepository;
    NSLog(@"%@",dataArr);
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
- (void)joinChatRoom:(NSString *)targetId
        messageCount:(int)messageCount
             success:(void (^)(void))successBlock
               error:(void (^)(RCErrorCode status))errorBlock{

}
- (void)refreshUserInfoOrGroupInfo {
    
    //刷新自己头像昵称
    RCUserInfo *_currentUserInfo =
    [[RCUserInfo alloc] initWithUserId:DefaultsObjectForKey(@"user_id")
                                  name:DefaultsObjectForKey(@"display_name")
                              portrait:DefaultsObjectForKey(@"avatar")];
    [[RCIM sharedRCIM] refreshUserInfoCache:_currentUserInfo withUserId:_currentUserInfo.userId];    
    
    //打开群聊强制从demo server 获取群组信息更新本地数据库
    if (self.conversationType == ConversationType_GROUP) {
        __weak typeof(self) weakSelf = self;
        [RCDHTTPTOOL getGroupByID:self.targetId
                successCompletion:^(RCDGroupInfo *group) {
                    RCGroup *Group =
                    [[RCGroup alloc] initWithGroupId:weakSelf.targetId
                                           groupName:group.groupName
                                         portraitUri:group.portraitUri];
                    [[RCIM sharedRCIM] refreshGroupInfoCache:Group
                                                 withGroupId:weakSelf.targetId];

                }];
    }
    //更新群组成员用户信息的本地缓存
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *groupList =
        [[RCDataBaseManager shareInstance] getGroupMember:self.targetId];
        NSArray *resultList =
        [[RCDUserInfoManager shareInstance] getFriendInfoList:groupList];
        groupList = [[NSMutableArray alloc] initWithArray:resultList];
        for (RCUserInfo *user in groupList) {
            if ([user.portraitUri isEqualToString:@""]) {
                user.portraitUri = [RCDUtilities defaultUserPortrait:user];
            }
            if ([user.portraitUri hasPrefix:@"file:///"]) {
                NSString *filePath = [RCDUtilities
                                      getIconCachePath:[NSString
                                                        stringWithFormat:@"user%@.png", user.userId]];
                if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                    NSURL *portraitPath = [NSURL fileURLWithPath:filePath];
                    user.portraitUri = [portraitPath absoluteString];
                } else {
                    user.portraitUri = [RCDUtilities defaultUserPortrait:user];
                }
            }
            NSLog(@"%@",user.userId);
            [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)inputTextViewDidTouchSendKey:(UITextView *)inputTextView{
//    NSLog(@"%@",inputTextView.text);
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
