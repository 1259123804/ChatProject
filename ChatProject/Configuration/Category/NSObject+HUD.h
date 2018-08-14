//
//  NSObject+HUD.h
//  BonDay
//
//  Created by   文进 on 16/2/25.
//  Copyright © 2016年 BonDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HUD)

/**弹出文字提示*/
-(void)showAlert:(NSString *)text;

/**显示忙*/
- (void)showBusy;

/**隐藏提示*/
- (void) hideProgress;



@end
