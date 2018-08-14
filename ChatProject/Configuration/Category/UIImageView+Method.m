//
//  UIImageView+Method.m
//  BonDay
//
//  Created by Duke Li on 2018/5/7.
//  Copyright © 2018年 Bonday. All rights reserved.
//

#import "UIImageView+Method.h"

@implementation UIImageView (Method)
+ (UIImageView *)imageViewWithImageName:(NSString *)imageName frame:(CGRect)frame{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = frame;
    return imageView;
}
@end
