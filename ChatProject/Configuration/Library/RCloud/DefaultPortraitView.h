//
//  DefaultPortraitView.h
//  ChatProject
//
//  Created by Duke Li on 2018/8/30.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultPortraitView : UIView
@property(nonatomic, strong) NSString *firstCharacter;

- (void)setColorAndLabel:(NSString *)userId Nickname:(NSString *)nickname;

- (UIImage *)imageFromView;

@end
