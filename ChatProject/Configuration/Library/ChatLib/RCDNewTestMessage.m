//
//  RCDNewTestMessage.m
//  BonDay
//
//  Created by Duke Li on 2017/7/20.
//  Copyright © 2017年 Bonday. All rights reserved.
//

#import "RCDNewTestMessage.h"

@implementation RCDNewTestMessage
///初始化
+ (instancetype)messageWithContent:(NSString *)content {
    RCDNewTestMessage *text = [[RCDNewTestMessage alloc] init];
    if (text) {
        text.title = content;
    }
    return text;
}

///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.entityType = [aDecoder decodeObjectForKey:@"entityType"];
        self.entityId = [aDecoder decodeObjectForKey:@"entityId"];
        self.lessonType = [aDecoder decodeObjectForKey:@"lessonType"];
    }
    return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.entityId forKey:@"entityId"];
    [aCoder encodeObject:self.entityType forKey:@"entityType"];
    [aCoder encodeObject:self.lessonType forKey:@"lessonType"];
    
    
    
}

///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.title forKey:@"title"];
    if (self.image) {
        [dataDict setObject:self.image forKey:@"image"];
    }
    if (self.entityType) {
        [dataDict setObject:self.entityType forKey:@"entityType"];
    }
    if (self.entityId) {
        [dataDict setObject:self.entityId forKey:@"entityId"];
    }
    if (self.lessonType) {
        [dataDict setObject:self.lessonType forKey:@"lessonType"];
        
    }
    
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name
                 forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri
                 forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId
                 forKeyedSubscript:@"id"];
        }
        
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}

///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        
        NSDictionary *dictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:kNilOptions
                                          error:&error];
        
        if (dictionary) {
            self.title = dictionary[@"title"];
            self.image = dictionary[@"image"];
            self.entityId = dictionary[@"entityId"];
            self.entityType = dictionary[@"entityType"];
            self.lessonType = dictionary[@"lessonType"];
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

/// 会话列表中显示的摘要
- (NSString *)conversationDigest {
    return self.title;
}

///消息的类型名
+ (NSString *)getObjectName {
    return RCDNewTestMessageTypeIdentifier;
}


@end
