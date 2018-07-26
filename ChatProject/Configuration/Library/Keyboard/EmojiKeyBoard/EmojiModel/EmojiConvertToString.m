//
//  EmojiConvertToString.m
//  joinup_iphone
//
//  Created by shen_gh on 15/8/4.
//  copyRight (c) 2015年 com.joinup(Beijing). All rights reserved.
//

#import "EmojiConvertToString.h"
#import "ChatEmojiIcons.h"
#import "EmojiContent.h"
@implementation EmojiConvertToString

+ (NSString *)convertToCommonEmoticons:(NSString *)text{
    //表情数量
  
    NSMutableString *retText = [[NSMutableString alloc] initWithString:text];
    
    NSArray *emojis = [ChatEmojiIcons emojis];
    NSString *name = nil;
    for (EmojiContent *content in emojis) {
        
        if ([content.name isEqualToString:text]) {
            
            name = content.text;
        }
    }
    NSRange range;
    range.location = 0;
    range.length = retText.length;
    [retText replaceOccurrencesOfString:text withString:name options:NSLiteralSearch range:range];
    
    return retText;
}

@end
