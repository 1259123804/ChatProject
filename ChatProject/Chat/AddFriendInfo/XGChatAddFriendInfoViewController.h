//
//  XGChatAddFriendInfoViewController.h
//  ChatProject
//
//  Created by Duke Li on 2018/9/3.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGChatAddFriendInfoViewController : UITableViewController
+ (instancetype)addressBookViewController;

@property(nonatomic, strong) NSArray *keys;

@property(nonatomic, strong) NSMutableDictionary *allFriends;

@property(nonatomic, strong) NSArray *allKeys;

@property(nonatomic, strong) NSArray *seletedUsers;

@property(nonatomic, assign) BOOL hideSectionHeader;

@property(nonatomic, assign) BOOL needSyncFriendList;
@end
