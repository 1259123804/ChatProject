//
//  UIImage+Color.h
//  navigationBar渐变
//
//  Created by 李小光 on 16/8/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)
+ (UIImage *)imageWithColor:(UIColor *)color;
//取颜色color背景图片
+ (UIImage *)imageFormColor:(UIColor *)color frame:(CGRect)frame;
@end
