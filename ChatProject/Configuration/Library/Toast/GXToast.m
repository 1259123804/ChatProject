//
//  GXToast.m
//
//  Created by garyxuan on 16-7-13.
//  Copyright (c) 2016年 wangxiaoxuan. All rights reserved.

#import "GXToast.h"
#define ToastTextFont  [UIFont boldSystemFontOfSize:13.0f]
#define ToastTextColor [UIColor whiteColor]
#define ToastTextBackgroundColor [UIColor clearColor]
#define ToastBackgroundColor [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.75]
#define ToastDispalyDuration 0.5f

@interface GXToast ()
@end

@implementation GXToast
- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}

+ (instancetype)sharedToast{
    
    static GXToast *toast;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
       
        toast = [[[self class] alloc] initWithText:@"本课时不可预览，请参加课程"];
        
    });
    return toast;
}

- (id)initWithText:(NSString*)text
{
    if (self = [super init]) {
        NSDictionary * dict=[NSDictionary dictionaryWithObject:ToastTextFont forKey:NSFontAttributeName];
        CGRect rect=[text boundingRectWithSize:CGSizeMake(250,CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,rect.size.width + 25, rect.size.height+ 15)];
        _textLabel.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.75];
        _textLabel.textColor = ToastTextColor;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = ToastTextFont;
        _textLabel.text = text;
        _textLabel.numberOfLines = 0;
        _textLabel.layer.cornerRadius = 8.0f;
        _textLabel.layer.masksToBounds = YES;
         _duration = ToastDispalyDuration;
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)deviceOrientationDidChanged
{
    [self dismiss];
}

- (void)toastTaped:(UIButton *)sender
{
    [self dismiss];
}

- (void)appear
{
    [UIView beginAnimations:@"appear" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    _textLabel.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void)dismiss
{
    [UIView beginAnimations:@"dismiss" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didDismiss)];
    [UIView setAnimationDuration:0.3];
    _textLabel.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)didDismiss
{
    [_textLabel removeFromSuperview];
    _textLabel = nil;
}

- (void)show
{
    // Displayed on the top of app
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    _textLabel.center = window.center;
//    NSLog(@"%id",window.hidden);
    window.hidden = NO;
//    NSLog(@"%id",window.hidden);
    [window  addSubview:_textLabel];
    [self appear];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:_duration];
}

- (void)showTopWithOffset:(CGFloat)offset{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    _textLabel.center = CGPointMake(window.center.x, offset + _textLabel.frame.size.height/2);
    [window  addSubview:_textLabel];
    [self appear];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:_duration];
}

- (void)showBottomWithOffset:(CGFloat)offset{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    _textLabel.center = CGPointMake(window.center.x, window.frame.size.height-(offset + _textLabel.frame.size.height/2));
    [window  addSubview:_textLabel];
    [self appear];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:_duration];
}


#pragma mark -对外接口 External interface
 + (void)showText:(NSString*)text
 {
    [GXToast showText:text position:GXToastPositionCenter offset:0.0f duration:ToastDispalyDuration];
 }

 + (void)showText:(NSString*)text position:(GXToastPosition)position
 {
    [GXToast showText:text position:position offset:0.0f duration:ToastDispalyDuration];
 }

 + (void)showText:(NSString*)text position:(GXToastPosition)position duration:(CGFloat)duration
 {
    [GXToast showText:text position:position offset:0.0f duration:duration];
 }

 + (void)showText:(NSString*)text position:(GXToastPosition)position offset:(CGFloat)offset duration:(CGFloat)duration
 {
    GXToast *toast = [[GXToast alloc] initWithText:text];
    [toast setDuration:duration];
    if (position == GXToastPositionCenter)
    {
        [toast show];
    }else if (position == GXToastPositionTop)
    {
        [toast showTopWithOffset:offset];
    }else if (position == GXToastPositionBottom)
    {
        [toast showBottomWithOffset:offset];
    }
 }


@end
