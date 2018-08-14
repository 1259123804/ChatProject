//
//  XGPrivateConversationViewController.h
//  BonDay
//
//  Created by Duke Li on 2017/5/4.
//  Copyright © 2017年 Bonday. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
@interface XGPrivateConversationViewController : RCConversationViewController
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) NSString *groupIDStr;
@property (nonatomic,assign) BOOL ispushed;
@property (nonatomic, assign) BOOL isSupport;
@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, assign) BOOL isCustomSupport;
@property (nonatomic,assign) BOOL isOneTwoOneed;

@end
