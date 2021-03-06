//
//  NetInterface.h
//  ChatProject
//
//  Created by Duke Li on 2018/7/26.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#ifndef NetInterface_h
#define NetInterface_h

#define kTestApi @"http://111.231.67.131:1000/api/" //测试接口

#pragma mark - 登录注册
#define kRegister_user @"user/register/" //注册用户
#define kLogin_user @"user/login/" //登陆用户
#define kLogout_user @"user/logout/" //登出用户
#define kUser_info @"user" //获取用户信息
#define kUser_refreshToken @"user/refresh/" //刷新用户token
#define kForgotPassword @"password/forget/" //忘记密码
#define kForgotPassword_checkCode @"password/verify/" //验证验证码
#define kForgotPassword_reset @"password/reset/" //重置密码

#pragma mark - 通讯录
#define kFriends_apply @"friends/apply/" //好友申请
#define kFriends_search @"friends/search/" //好友搜索
#define kFriends_applylist @"friends/applylist/" //好友请求列表
#define kFriends_list @"friends/list/" //好友列表
#define kFriends_accept @"friends/accept/" //接受好友请求

#pragma mark - 发布动态
#define kPicture_upload @"picture/upload/" //上传图片
#define kdynamic_publish @"dongtai/publish/" //发布动态

#endif /* NetInterface_h */
