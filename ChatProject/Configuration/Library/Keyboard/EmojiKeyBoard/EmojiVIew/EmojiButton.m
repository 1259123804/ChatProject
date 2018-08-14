//
//  EmojiButton.m
//  joinup_iphone
//
//  Created by shen_gh on 15/8/4.
//  copyRight (c) 2015年 com.joinup(Beijing). All rights reserved.
//

#import "EmojiButton.h"
#import "EmojiObj.h"

@implementation EmojiButton

-(void)setEmojiIcon:(EmojiObj *)emojiIcon{
    _emojiIcon = emojiIcon;
    NSString *path = [[NSBundle mainBundle] resourcePath];
    NSString *resourcePath = [NSString stringWithFormat:@"%@/%@",path, emojiIcon.emojiImgName];
    [self setImage:[UIImage imageWithContentsOfFile:resourcePath] forState:UIControlStateNormal];
}

@end
