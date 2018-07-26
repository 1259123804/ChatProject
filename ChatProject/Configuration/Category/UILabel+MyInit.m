//
//  UILabel+MyInit.m
//  BonDay
//
//  Created by 李小光 on 16/9/6.
//  Copyright © 2016年 Bonday. All rights reserved.
//

#import "UILabel+MyInit.h"

@implementation UILabel (MyInit)
+ (UILabel *)labelWithFrame:(CGRect)frame alignment:(NSTextAlignment )alignment fontSize:(CGFloat)size textColor:(UIColor *)color string:(NSString *)text systemFont:(BOOL)system{
    
    UILabel *label = [UILabel new];
    label.frame = frame;
    label.text = text;
    label.textAlignment = alignment;
    label.textColor = color;
    label.font = system ? [UIFont systemFontOfSize:size] : [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
    return label;
}

- (void)setAttributedText:(NSString *)text
       withRegularPattern:(NSString *)pattern
               attributes:(NSDictionary *)attributesDict{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    [self setAttributedText:text withRegularExpression:regex attributes:attributesDict];
}

/**
 关键字高亮设置
 */
- (void)setAttributedText:(NSString *)text
    withRegularExpression:(NSRegularExpression *)expression
               attributes:(NSDictionary *)attributesDict{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [expression enumerateMatchesInString:text options:0 range:NSMakeRange(0, [text length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange matchRange = [result range];
        if (attributesDict) {
            
            [attributedString addAttributes:attributesDict range:matchRange];
        }
        if ([result resultType] == NSTextCheckingTypeLink) {
            NSURL *url = [result URL];
            [attributedString addAttribute:NSLinkAttributeName value:url range:matchRange];
        }
        
    }];
    [self setAttributedText:attributedString];
}

@end
