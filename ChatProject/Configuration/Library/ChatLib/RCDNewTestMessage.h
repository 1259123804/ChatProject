//
//  RCDNewTestMessage.h
//  BonDay
//
//  Created by Duke Li on 2017/7/20.
//  Copyright © 2017年 Bonday. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
/*!
 测试消息的类型名
 */
#define RCDNewTestMessageTypeIdentifier @"BD:TxtUrlMsg"

@interface RCDNewTestMessage : RCMessageContent
/*!
 测试消息的内容
 */
//@property(nonatomic, strong) NSString *content;//bonday不用

/*!
 测试消息的附加信息
 */
//@property(nonatomic, strong) NSString *extra;//boday 不用

//bonday
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *entityType;
@property (nonatomic,strong) NSString *entityId;
@property (nonatomic,strong) NSDictionary *user;
@property (nonatomic,strong) NSNumber *lessonType;
/*!
 初始化测试消息
 
 @param content 文本内容
 @return        测试消息对象
 */
+ (instancetype)messageWithContent:(NSString *)content;

@end
