//
//  TestChatListViewController.h
//  MyMVVM
//
//  Created by bonday012 on 17/3/13.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface TestChatListViewController : RCConversationViewController
@property (nonatomic,copy)NSString *titleStr;
@property (nonatomic,copy)NSString *groupIDStr;
@property (nonatomic,assign)BOOL ispushed;
@end
