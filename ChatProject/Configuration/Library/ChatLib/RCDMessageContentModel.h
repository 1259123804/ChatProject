//
//  RCDMessageContentModel.h
//  MyMVVM
//
//  Created by bonday012 on 17/3/21.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCDMessageContentModel : NSObject
/*!
 测试消息的内容
 */
@property(nonatomic, strong) NSString *content;

/*!
 测试消息的附加信息
 */
@property(nonatomic, strong) NSString *extra;
/*!
 用户ID
 */
@property(nonatomic, strong) NSString *userId;

/*!
 用户名称
 */
@property(nonatomic, strong) NSString *name;

/*!
 用户头像的URL
 */
@property(nonatomic, strong) NSString *portraitUri;
@end
