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

#define kRegister_user @"user/register/" //注册用户
#define kLogin_user @"user/login/" //登陆用户
#define kLogout_user @"user/logout/" //登出用户
#define kUser_info @"user" //获取用户信息
#define kUser_token @"user/refresh/" //刷新用户token
#define kForgotPassword @"user/forgetPassword/" //忘记密码
#define kForgotPassword_checkCode @"user/verify/" //验证验证码
#define kForgotPassword_reset @"user/verify/" //重置密码

#endif /* NetInterface_h */
