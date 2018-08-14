//
//  ChatKeyBoardView.h
//  joinup_iphone
//
//  Created by shen_gh on 15/7/29.
//  copyRight (c) 2015年 com.joinup(Beijing). All rights reserved.
//


/**
 *  聊天键盘
 */
#import <UIKit/UIKit.h>
#import "ChatInputTextView.h"//聊天输入

@class ChatKeyBoardView;

@protocol ChatKeyBoardViewDelegate <NSObject>

@optional
//根据键盘是否弹起，设置tableView frame
-(void)keyBoardView:(ChatKeyBoardView *)keyBoard ChangeDuration:(CGFloat)durtaion;

//发送消息
-(void)keyBoardView:(ChatKeyBoardView*)keyBoard sendMessage:(NSString*)message;

- (void)emojiViewSendMessage;
-(void)sentCoffee:(ChatKeyBoardView*)chatView;
@end

@interface ChatKeyBoardView : UIView

@property (nonatomic,strong) UIView *chatBgView;//聊天框
@property (nonatomic,strong) ChatInputTextView *chatInputTextView;//聊天输入
@property (nonatomic,weak) id<ChatKeyBoardViewDelegate>delegate;
@property (nonatomic,strong) UILabel *placeLabel;
@property (nonatomic,assign) NSInteger emojiNum;
@property (nonatomic,assign)  BOOL keyBoardTap;
@property (nonatomic,assign)BOOL isCafe;

@property (nonatomic,retain) NSMutableArray *emojiArray;
@property (nonatomic,strong) UIButton *faceBtn;//表情按钮
@property (nonatomic,strong) UIButton *otherBtn;//其他按钮(图片、拍照)
@property (nonatomic,strong) UIButton *sendBtn;//发送按钮
//初始化init
- (instancetype)initWithDelegate:(id)delegate superView:(UIView *)superView hasNavBar:(BOOL)hasNavBar;

-(instancetype)initWithDelegate:(id)delegate superView:(UIView *)superView hasNavBar:(BOOL)hasNavBar isCafe:(BOOL)isCafe;

//动态调整textView的高度
-(void)textViewChangeText;

//
-(void)tapAction;

@end
