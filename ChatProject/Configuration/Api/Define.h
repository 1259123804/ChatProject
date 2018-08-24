//
//  Define.h
//  ChatProject
//
//  Created by Duke Li on 2018/7/26.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#ifndef Define_h
#define Define_h

//宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//导航条高度
#define kNavBarHeight (([UIScreen mainScreen].bounds.size.height >= 812.0) ? (88.0) : (64.0))
//标签栏的高度
#define kTabBarHeight (([UIScreen mainScreen].bounds.size.height >= 812.0) ? (83.0) : (49.0))
//颜色
#define UIColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define kBtnColor UIColorWithRGBA(255,112,140,1)

#pragma mark - NSUserDefaultsName
#define DefaultsSetValueForKey(value, key) [[NSUserDefaults standardUserDefaults] setValue:value forKey:key]
#define DefaultsSetObjectForKey(value, key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define DefaultsSynchronize [[NSUserDefaults standardUserDefaults] synchronize]
#define DefaultsRemoveObjectForKey(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]
#define DefaultsValueForKey(key) [[NSUserDefaults standardUserDefaults] valueForKey:key]
#define DefaultsObjectForKey(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#pragma mark - infoName
#define kUser_name @"kUser_name" //个人昵称
#define kUser_avatar @"kUser_avatar" //个人头像
#define kUser_token @"kUser_token" //个人token


//LocalInfoName
#define kNSUserDefaultKey_displayName @"kNSUserDefaultKey_displayName" //保存个人昵称

//NotificationName
#define kNotificationName_dismissLogin @"kNotificationName_dismissLogin" //移除登陆和注册的页面
#define kNotificationName_loginSuccess @"kNotificationName_loginSuccess" //登录成功
#endif /* Define_h */
