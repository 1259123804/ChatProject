//
//  ChatEmojiView.h
//  joinup_iphone
//
//  Created by shen_gh on 15/7/29.
//  copyRight (c) 2015年 com.joinup(Beijing). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiButton.h"
#import "EmojiObj.h"
#import "EmojiScrollView.h"
#import "CommentEmoji.h"
#import "IconButton.h"
#import "SMPageControl.h"//第三方pageControl

typedef NS_ENUM(NSInteger, ChatEmojiViewIconType){
    ChatEmojiViewIconTypeCommon = 0,//经典表情
    ChatEmojiViewIconTypeOther //******************自定义表情:后期版本拓展**********
};

@class EmojiObj;

@protocol ChatEmojiViewDelegate <NSObject>

@required
- (void)chatEmojiViewSelectEmojiIcon:(EmojiObj*)objIcon;//选择了某个表情
- (void)chatEmojiViewTouchUpinsideDeleteButton;//点击了删除表情

@optional
- (void)chatEmojiViewTouchUpinsideSendButton;//点击了发送表情

@end

#define ChatEmojiView_Hight    210.0f //表情View的高度
#define ChatEmojiView_Bottom_H 40.0f
#define ChatEmojiView_Bottom_W 52.0f

@interface ChatEmojiView : UIView


@property (nonatomic, strong) SMPageControl * pageControl;
@property (nonatomic, strong) EmojiScrollView *scroll;
@property (nonatomic, strong) IconButton *selectIcon;
@property (nonatomic, copy) NSArray * iconS;
@property (nonatomic,weak) id<ChatEmojiViewDelegate>delegate;
+ (instancetype)sharedEmojiView;

@end
