//
//  UILabel+MyInit.h
//  BonDay
//
//  Created by 李小光 on 16/9/6.
//  Copyright © 2016年 Bonday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MyInit)

+ (UILabel *)labelWithFrame:(CGRect )frame alignment:(NSTextAlignment )alignment fontSize:(CGFloat )size textColor:(UIColor *)color string:(NSString *)text systemFont:(BOOL)system;
- (void)setAttributedText:(NSString *)text
       withRegularPattern:(NSString *)pattern
               attributes:(NSDictionary *)attributesDict;
- (void)setAttributedText:(NSString *)text
    withRegularExpression:(NSRegularExpression *)expression
               attributes:(NSDictionary *)attributesDict;
@end
