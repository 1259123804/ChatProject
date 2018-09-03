//
//  XGChatAddFriendViewController.h
//  ChatProject
//
//  Created by Duke Li on 2018/8/27.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGChatAddFriendViewController : UITableViewController
@property(nonatomic, strong) RCUserInfo *targetUserInfo;
@property(nonatomic, strong) UILabel *lblName;
@property(nonatomic, strong) UIImageView *ivAva;
@property(nonatomic, strong) UIButton *addFriendBtn;
@property(nonatomic, strong) UIButton *startChat;

@end
