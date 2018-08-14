//
//  ChatEmojiIcons.m
//  joinup_iphone
//
//  Created by shen_gh on 15/8/4.
//  copyRight (c) 2015年 com.joinup(Beijing). All rights reserved.
//

#import "ChatEmojiIcons.h"
#import "EmojiContent.h"
@implementation ChatEmojiIcons

//获取表情包
+ (NSArray *)emojis {
    static NSArray *_emojis;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获取表情plist
        NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotion.json"];
        NSArray *emojiArr = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:emojiFilePath] options:NSJSONReadingMutableContainers error:nil];

        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < emojiArr.count; i++) {
            
            EmojiContent *content = [[EmojiContent alloc] init];
            [content setValuesForKeysWithDictionary:emojiArr[i]];
            [array addObject:content];
        }
        //图片数组
        _emojis = array;
    });
    return _emojis;
}

+(NSInteger)getEmojiPopCount{
    return [[self class] emojis].count;
}

+ (NSString *)getEmojiNameByTag:(NSInteger)tag {
    NSArray *emojis = [[self class] emojis];
    EmojiContent *content = emojis[tag];
    return content.name;
}

+(NSString *)getEmojiPopIMGNameByTag:(NSInteger)tag{
    NSString * name = [[self class]getEmojiNameByTag:tag];
    return [[self class]imgNameWithName:name];
}

+ (NSString *)getEmojiPopNameByTag:(NSInteger)tag {
   
    NSString *key = [NSString stringWithFormat:@"%@", [self getEmojiNameByTag:tag]];
    return NSLocalizedString(key, @"");
}

+(NSString *)imgNameWithName:(NSString*)name{
    return [NSString stringWithFormat:@"%@",name];
}

@end
