//
//  NSObject+Parse.m
//  BonDay
//
//  Created by   文进 on 16/2/25.
//  Copyright © 2016年 BonDay. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 1.解析类, 解析的对象就两种: NSDicationary, NSArray
 2.每个解析类 都会有一个parse方法, 传入字典/数组, 返回当前对象
 3.解决 key不存在, value不存在而崩溃的问题(防御性编程)
 4.考虑 key 和 系统关键词冲突问题
 5.考虑 解析类中存在数组的问题
 */

#import "NSObject+Parse.h"

@implementation NSObject (Parse)

+ (id)parseArr:(NSArray *)arr{
    NSMutableArray *array = [NSMutableArray new];
    for (id obj in arr) {
        [array addObject:[self parse:obj]];
    }
    return [array copy];
}

+ (id)parseDic:(NSDictionary *)dic{
    id model = [self new];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        /** 考虑key的问题 */
        key = [self replacePropertyForKey:key];
        
        /** 考虑数组的问题 */
        if ([obj isKindOfClass:[NSArray class]]) {
            // 由子类重写的方法中获取array的key所对应的解析类
            Class class =[self objectClassInArray][key];
            if (class) {
                obj = [class parseArr:obj];
            }
        }
        
        [model setValue:obj forKey:key];
    }];
    return model;
}

+ (id)parse:(id)responseObj{
    if ([responseObj isKindOfClass:[NSArray class]]) {
        return [self parseArr:responseObj];
    }
    if ([responseObj isKindOfClass:[NSDictionary class]]) {
        return [self parseDic:responseObj];
    }
    return responseObj;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

- (void)setNilValueForKey:(NSString *)key{}

+ (NSString *)replacePropertyForKey:(NSString *)key{
    //特殊情况处理
    if ([key isEqualToString:@"id"]) return @"ID";
    if ([key isEqualToString:@"description"]) {
        return @"desc";
    }
    //    ......根据具体情况 具体添加
    return key;
}
/** 不实现会报错, 此类只有子类重写才有效 */
+ (NSDictionary *)objectClassInArray{
    return nil;
}


@end

