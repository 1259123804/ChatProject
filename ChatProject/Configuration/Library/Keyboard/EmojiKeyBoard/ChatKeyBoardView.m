//
//  ChatKeyBoardView.m
//  joinup_iphone
//
//  Created by shen_gh on 15/7/29.
//  Copyright (c) 2015年 com.joinup. All rights reserved.
//

#import "ChatKeyBoardView.h"
#import "ChatKeyBoardAnimationView.h"//聊天框底部contain
#import "ChatEmojiView.h"//表情键盘View
#import "EmojiObj.h"
#import "EmojiTextAttachment.h"
#import "UIView+SDAutoLayout.h"

@interface ChatKeyBoardView()<ChatEmojiViewDelegate,UITextViewDelegate>
{
    NSArray *_icons;//表情、添加按钮集
    CGFloat hight_text_one;
    ChatEmojiView *_emojiView;
}
@property (nonatomic,strong) ChatKeyBoardAnimationView *bottomView;
@property (nonatomic, assign) BOOL hasNavBar;
@end

@implementation ChatKeyBoardView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
   // [self removeObserver:self forKeyPath:@"_chatInputTextView.frame"];
    
}

#pragma mark - 初始化 init
- (instancetype)initWithDelegate:(id)delegate superView:(UIView *)superView hasNavBar:(BOOL)hasNavBar{
    self=[super init];
    if (self) {
        //布局View
        _emojiArray = [NSMutableArray array];
        _hasNavBar = hasNavBar;
        [self setUpView];
        [self addNotifations];
        [self addToSuperView:superView hasNavBar:hasNavBar];
        self.delegate=delegate;
        
    }
    return self;
}
-(instancetype)initWithDelegate:(id)delegate superView:(UIView *)superView hasNavBar:(BOOL)hasNavBar isCafe:(BOOL)isCafe{
    self=[super init];
    if (self) {
        //布局View
        self.isCafe = isCafe;
        _emojiArray = [NSMutableArray array];
        _hasNavBar = hasNavBar;
        [self setUpView];
        [self addNotifations];
        [self addToSuperView:superView hasNavBar:hasNavBar];
        self.delegate=delegate;
        
    }
    return self;
}
#pragma mark setUpView
- (void)setUpView{
    //聊天框及bottomView
    [self initChatBgView];
    //添加按钮
    [self addIcons];
    //表情视图和 图片，拍照
    [self initIconsContentView];
    
}
- (void)initChatBgView{
    //聊天框
    [self addSubview:self.chatBgView];
    [self addSubview:self.bottomView];
}

- (void)addIcons{
    
    _icons=@[self.faceBtn];
    
    for (UIButton *btn in _icons) {
        
        [self.chatBgView addSubview:btn];
        _faceBtn.sd_layout.rightSpaceToView(_chatBgView, 15);
        _faceBtn.sd_layout.bottomSpaceToView(_chatBgView, 0);
        _faceBtn.sd_layout.heightIs(kTabBarHeight);
        _faceBtn.sd_layout.widthIs(35);
    }
}


//聊天框
- (UIView *)chatBgView{
    if (!_chatBgView) {
        if (self.isCafe == YES) {
            _chatBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kTabBarHeight+0.5)];
            [_chatBgView setBackgroundColor:UIColorWithRGBA(245, 245, 245, 1)];
            [_chatBgView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            [_chatBgView.layer setBorderWidth:0.5];
            [_chatBgView addSubview:self.chatInputTextView];
            UIImageView *cofeImageV = [[UIImageView alloc]initWithFrame:CGRectMake(16, 5, 40, 37)];
            cofeImageV.image = [UIImage imageNamed:@"coffee"];
            cofeImageV.clipsToBounds = YES;
            cofeImageV.userInteractionEnabled = YES;
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cofeImageVclick)];
            [cofeImageV addGestureRecognizer:gesture];
            [_chatBgView addSubview:cofeImageV];
            
            self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_chatInputTextView.frame.origin.x+5, _chatInputTextView.frame.origin.y, CGRectGetWidth(_chatInputTextView.frame)-5, CGRectGetHeight(_chatInputTextView.frame))];
            self.placeLabel.enabled = NO;
            self.placeLabel.backgroundColor = [UIColor clearColor];
            self.placeLabel.font = [UIFont systemFontOfSize:15];
            self.placeLabel.textColor = [UIColor lightGrayColor];
            self.placeLabel.text = @"向他提问";
            [_chatBgView addSubview:self.placeLabel];
            [_chatBgView bringSubviewToFront:self.placeLabel];
        }else{
        _chatBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kTabBarHeight+0.5)];
        [_chatBgView setBackgroundColor:UIColorWithRGBA(245, 245, 245, 1)];
        [_chatBgView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [_chatBgView.layer setBorderWidth:0.5];
        [_chatBgView addSubview:self.chatInputTextView];
        
        self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_chatInputTextView.frame.origin.x+5, _chatInputTextView.frame.origin.y, CGRectGetWidth(_chatInputTextView.frame)-5, CGRectGetHeight(_chatInputTextView.frame))];
        self.placeLabel.enabled = NO;
        self.placeLabel.backgroundColor = [UIColor clearColor];
        self.placeLabel.font = [UIFont systemFontOfSize:15];
        self.placeLabel.textColor = [UIColor lightGrayColor];
        self.placeLabel.text = @"回复";
        [_chatBgView addSubview:self.placeLabel];
        [_chatBgView bringSubviewToFront:self.placeLabel];
    }
    }
    return _chatBgView;
}
-(void)cofeImageVclick{
    if (self.delegate) {
        [self.delegate sentCoffee:self];
    }

    
}
//聊天框底部View
- (ChatKeyBoardAnimationView *)bottomView{
    if (!_bottomView) {
        _bottomView=[[ChatKeyBoardAnimationView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.chatBgView.frame), kScreenWidth, ChatEmojiView_Hight)];
         self.bottomView.backgroundColor = UIColorWithRGBA(245, 245, 245, 1);
    }
    return _bottomView;
}

-(void)initIconsContentView{
    
    _emojiView = [ChatEmojiView sharedEmojiView];
    _emojiView.delegate = self;
    _emojiView.scroll.contentOffset = CGPointZero;
    _emojiView.pageControl.currentPage = 0;
    
   // _otherView = [[ChatOtherView alloc]init];
   // _otherView.delegate = self;
}



#pragma mark 添加表情、+按钮
//- (void)addIcons{
//    _icons=@[self.faceBtn,self.otherBtn];
//    
//    for (UIButton *btn in _icons) {
//        [btn setImage:[UIImage imageNamed:@"chat_bottom_keyboard_nor"] forState:UIControlStateSelected];
//        [btn addTarget:self action:@selector(iconsAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.chatBgView addSubview:btn];
//    }
//}

//表情
- (UIButton *)faceBtn{
    if (!_faceBtn) {
        _faceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        //[_faceBtn setFrame:CGRectMake(CGRectGetMaxX(_chatInputTextView.frame)+10, 0, 35, kTabBarHeight)];
        
        //_faceBtn.translatesAutoresizingMaskIntoConstraints = NO;
       
        
//        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:_faceBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.chatBgView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-15];
//        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:_faceBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.chatBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
////        
//        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:_faceBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kTabBarHeight];
//        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:_faceBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:35];
//        
//        [_chatBgView addConstraint:constraint1];
//        [_chatBgView addConstraint:constraint2];
//        [_chatBgView addConstraint:constraint3];
//        [_chatBgView addConstraint:constraint4];
        
        [_faceBtn setImage:[UIImage imageNamed:@"ic_emoji_blue"] forState:UIControlStateNormal];
        [_faceBtn addTarget:self action:@selector(iconsAction:) forControlEvents:UIControlEventTouchUpInside];
        [_faceBtn setImage:[UIImage imageNamed:@"chat_bottom_keyboard_nor"] forState:UIControlStateSelected];
        
        [_faceBtn setTag:1];
    }
    return _faceBtn;
}
//+
//- (UIButton *)otherBtn{
//    if (!_otherBtn) {
//        _otherBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        [_otherBtn setFrame:CGRectMake(self.faceBtn.current_x_w, 0, 40, kTabBarHeight)];
//        [_otherBtn setImage:[UIImage imageNamed:@"ic_add_blue"] forState:UIControlStateNormal];
//        [_otherBtn setTag:2];
//    }
//    return _otherBtn;
//}

//聊天输入
- (ChatInputTextView *)chatInputTextView{
    if (!_chatInputTextView) {
        _chatInputTextView=[[ChatInputTextView alloc]init];
        [_chatInputTextView setFont:[UIFont systemFontOfSize:15]];
        [_chatInputTextView setBackgroundColor:[UIColor whiteColor]];
        [_chatInputTextView.layer setBorderWidth:0.5];
        [_chatInputTextView.layer setBorderColor:UIColorWithRGBA(229, 229, 229, 1).CGColor];
        [_chatInputTextView.layer setCornerRadius:4];
        [_chatInputTextView.layer setMasksToBounds:YES];
        [_chatInputTextView setReturnKeyType:UIReturnKeySend];
        [_chatInputTextView setEnablesReturnKeyAutomatically:YES];
        [_chatInputTextView setTextContainerInset:UIEdgeInsetsMake(10, 0, 5, 0)];
        [_chatInputTextView setDelegate:self];
        
        hight_text_one = [_chatInputTextView.layoutManager usedRectForTextContainer:_chatInputTextView.textContainer].size.height;
        if (self.isCafe == YES) {
            [_chatInputTextView setFrame:CGRectMake(5+72, 5,kScreenWidth-60-5-72, hight_text_one+20)];

        }else
        [_chatInputTextView setFrame:CGRectMake(5, 5,kScreenWidth-60-5, hight_text_one+20)];
       
    }
    return _chatInputTextView;
}

//发送
//- (UIButton *)sendBtn{
//    if (!_sendBtn) {
//        _sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        [_sendBtn setFrame:CGRectMake(self.chatInputTextView.current_x_w+8, 8, kScreenWidth-10-(self.chatInputTextView.current_x_w+3),kTabBarHeight-16)];
//        [_sendBtn.layer setBorderColor:kAppMainLightBrownColor.CGColor];
//        [_sendBtn.layer setBorderWidth:0.5];
//        [_sendBtn setTitleColor:kAppMainLightBrownColor forState:UIControlStateNormal];
//        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
//        [_sendBtn.titleLabel setFont:UIFont_size(14.0)];
//        [_sendBtn setBackgroundImage:[UIImage imageFormColor:kAppWhiteColor frame:_sendBtn.bounds] forState:UIControlStateNormal];
//        [_sendBtn setBackgroundImage:[UIImage imageFormColor:kAppLineColor frame:_sendBtn.bounds] forState:UIControlStateHighlighted];
//        [_sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _sendBtn;
//}

#pragma mark textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if(![textView hasText] && [text isEqualToString:@""]) {
        return NO;
    }
    if ([text isEqualToString:@"\n"]) {
        [self sendMessage];
        return NO;
    }
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"111");
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    
    [self textViewChangeText];
    self.placeLabel.text = @"";
}

//- (void)textViewDidChangeSelection:(UITextView *)textView
//{
//    NSLog(@"textView:%@",NSStringFromRange(textView.selectedRange));
//    
//    NSRange range = NSMakeRange(0, textView.attributedText.length);
//    
//    NSLog(@"myrange:%@", NSStringFromRange(range));
//    if (range.length != 0){
//        
//        self.placeLabel.text = nil;
//    }
//    
//    
//   
//    
//}

-(void)sendMessage{
    
    if (![self.chatInputTextView hasText]&&(self.chatInputTextView.text.length==0)) {
        return;
    }
    NSString *plainText = self.chatInputTextView.plainText;
    //空格处理
    plainText = [plainText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (plainText.length > 0) {
        [self sendMessage:plainText];
        self.chatInputTextView.text = @"";
        [self textViewChangeText];
        [self tapAction];
    }
    
}


#pragma mark 添加通知
- (void)addNotifations{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHiden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
}
#pragma mark - 系统键盘通知事件
-(void)keyBoardHiden:(NSNotification*)noti{
    //隐藏键盘
    if (_keyBoardTap==NO) {
        CGRect endF = [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
        CGFloat duration = [[noti.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect fram = self.frame;
        
        if (_hasNavBar) {
            
             fram.origin.y = (endF.origin.y - self.chatBgView.frame.size.height-kNavBarHeight);
        }else{
            
            fram.origin.y = (endF.origin.y - self.chatBgView.frame.size.height);
        }
        
     
        [UIView animateWithDuration:duration animations:^{
            self.keyBoardTap = NO;
            self.frame = fram;
            
        }];
        [self changeDuration:duration];
    }else{
        _keyBoardTap = NO;
        
    }
    
}

-(void)duration:(CGFloat)duration EndF:(CGRect)endF{
    
    _keyBoardTap = NO;
    self.frame = endF;
    [self changeDuration:duration];
}

#pragma mark - self delegate action
-(void)changeDuration:(CGFloat)duration{
    //动态调整tableView高度
    if (_delegate&&[self.delegate respondsToSelector:@selector(keyBoardView:ChangeDuration:)]) {
        [self.delegate keyBoardView:self ChangeDuration:duration];
    }
}
- (void)sendMessage:(NSString *)message{
    //发送消息
    if (_delegate&&[self.delegate respondsToSelector:@selector(keyBoardView:sendMessage:)]) {
        [_delegate keyBoardView:self sendMessage:message];
    }
}
//-(void)imagePickerControllerSourceType:(UIImagePickerControllerSourceType)sourceType{
//    //相册  拍照
//    if (_delegate&&[self.delegate respondsToSelector:@selector(keyBoardView:imgPicType:)]) {
//        [self.delegate keyBoardView:self imgPicType:sourceType];
//    }
//}


-(void)keyBoardShow:(NSNotification*)noti{
    //显示键盘
    CGRect endF = [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    if (_keyBoardTap==NO) {
        for (UIButton *btn in _icons) {
            btn.selected = NO;
        }
        [self.bottomView addSubview:[UIView new]];
        NSTimeInterval duration = [[noti.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect fram = self.frame;
        
        if (_hasNavBar) {
            
             fram.origin.y = (endF.origin.y - _chatBgView.frame.size.height-kNavBarHeight);
        }else{
            
            fram.origin.y = (endF.origin.y - _chatBgView.frame.size.height);
        }
        
        [UIView animateWithDuration:duration animations:^{
            self.keyBoardTap = NO;
            self.frame = fram;
        }];
        [self changeDuration:duration];
    }else{
        
        _keyBoardTap = NO;
    }
    
}

- (void)addToSuperView:(UIView *)superView hasNavBar:(BOOL)hasNavbar{
    
    if (hasNavbar) {
        //键盘的高度
        CGFloat s_h = CGRectGetHeight(superView.frame)-kNavBarHeight;
        CGRect frame = CGRectMake(0,s_h-kTabBarHeight-0.5,kScreenWidth, s_h+0.5);
        self.frame = frame;
        [superView addSubview:self];
        
    }else{
        
        CGFloat s_h = CGRectGetHeight(superView.frame);
        CGRect frame = CGRectMake(0,s_h-kTabBarHeight-0.5,kScreenWidth, s_h+0.5);
        self.frame = frame;
        [superView addSubview:self];
    }
}

#pragma mark Event
- (void)iconsAction:(UIButton *)sender{
   
    if (sender.selected) {
        [self.chatInputTextView becomeFirstResponder];
        return;
    }else{
        _keyBoardTap = YES;
        [self.chatInputTextView resignFirstResponder];
    }
    for (UIButton * b in _icons) {
        if ([b isEqual:sender]) {
            sender.selected = !sender.selected;
        }else{
            b.selected = NO;
        }
    }
    UIView * visiableView;
   
    switch (sender.tag) {
        case 1:
        {
            //表情
            visiableView=_emojiView;
        }
            break;
        
        default:{
            visiableView=[[UIView alloc]init];
        }
            break;
    }
    
    [self.bottomView addSubview:visiableView];
    CGRect fram = self.frame;
    
    if (_hasNavBar) {
        
        fram.origin.y =kScreenHeight- (CGRectGetHeight(visiableView.frame) + self.chatBgView.bounds.size.height)-kNavBarHeight;
    }else{
        
        fram.origin.y =kScreenHeight- (CGRectGetHeight(visiableView.frame) + self.chatBgView.bounds.size.height);
    }
    
    
    [UIView animateWithDuration:DURTAION animations:^{
        self.keyBoardTap = NO;
        self.frame = fram;
    }];
    //[self changeDuration:DURTAION];
}

#pragma mark - self public api action
-(void)tapAction{
    UIButton * b = [[UIButton alloc]init];
    b.selected = NO;
    [self iconsAction:b];
}

//动态调整textView的高度
-(void)textViewChangeText{
    CGFloat h = [self.chatInputTextView.layoutManager usedRectForTextContainer:self.chatInputTextView.textContainer].size.height;
    self.chatInputTextView.contentSize = CGSizeMake(self.chatInputTextView.contentSize.width, h+20);
    CGFloat five_h = hight_text_one*5.0f;
    h = h>five_h?five_h:h;
    CGRect frame = self.chatInputTextView.frame;
    CGFloat diff = self.chatBgView.frame.size.height - self.chatInputTextView.frame.size.height;
    if (frame.size.height == h+20) {
        if (h == five_h) {
            [self.chatInputTextView setContentOffset:CGPointMake(0, self.chatInputTextView.contentSize.height - h - 20) animated:NO];
        }
        return;
    }
    
    frame.size.height = h+20;
    self.chatInputTextView.frame = frame;
    [self topLayoutSubViewWithH:(frame.size.height+diff)];
    [self.chatInputTextView setContentOffset:CGPointZero animated:YES];
}

-(void)topLayoutSubViewWithH:(CGFloat)hight{
    CGRect frame = self.chatBgView.frame;
    CGFloat diff = hight - frame.size.height;
    frame.size.height = hight;
    self.chatBgView.frame = frame;
    
    frame = self.bottomView.frame;
    frame.origin.y = CGRectGetHeight(self.chatBgView.bounds);
    self.bottomView.frame = frame;
    
    frame = self.frame;
    frame.origin.y -= diff;

    _keyBoardTap = NO;
    self.frame = frame;
        

    //[self changeDuration:DURTAION];
}


#pragma mark Event
- (void)sendBtnClicked{
    //发送
    if (![self.chatInputTextView hasText]&&(self.chatInputTextView.text.length==0)) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"不能发送空白消息" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    NSString *plainText = self.chatInputTextView.plainText;
    //空格处理
    plainText = [plainText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (plainText.length > 0) {
        [self sendMessage:plainText];
        
        self.chatInputTextView.text = @"";
        [self textViewChangeText];
    }
    
}
#pragma mark - 发送消息
-(void)sentMessage{

    
}
#pragma mark - chat Emoji View Delegate
- (void)chatEmojiViewSelectEmojiIcon:(EmojiObj *)objIcon{
    //选择了某个表情
    [self textViewDidChange:_chatInputTextView];
    EmojiTextAttachment *attach = [[EmojiTextAttachment alloc] initWithData:nil ofType:nil];
    attach.Top = -3.5;
    attach.image = [UIImage imageNamed:objIcon.emojiImgName];
 
    NSMutableAttributedString * attributeString =[[NSMutableAttributedString alloc]initWithAttributedString:self.chatInputTextView.attributedText];;
    if (attach.image && attach.image.size.width > 1.0f) {
        attach.emoName = objIcon.emojiString;
        [attributeString insertAttributedString:[NSAttributedString attributedStringWithAttachment:attach] atIndex:_chatInputTextView.selectedRange.location];
        NSLog(@"++++%@", attributeString);
        NSRange range;
        range.location = self.chatInputTextView.selectedRange.location;
        range.length = 1;
        
        NSParagraphStyle *paragraph = [NSParagraphStyle defaultParagraphStyle];
        [attributeString setAttributes:@{NSAttachmentAttributeName:attach, NSFontAttributeName:self.chatInputTextView.font,NSBaselineOffsetAttributeName:[NSNumber numberWithInt:0.0], NSParagraphStyleAttributeName:paragraph} range:range];
    }
    self.chatInputTextView.attributedText = attributeString;
    [self textViewChangeText];
}
- (void)chatEmojiViewTouchUpinsideSendButton{
    //表情键盘：点击发送表情
   
    if (_delegate && [_delegate respondsToSelector:@selector(emojiViewSendMessage)]) {
        
        [_delegate emojiViewSendMessage];
    }
}
- (void)chatEmojiViewTouchUpinsideDeleteButton{
    //点击了删除表情
    NSRange range = self.chatInputTextView.selectedRange;
    NSInteger location = (NSInteger)range.location;
    if (location == 0) {
        return;
    }
    range.location = location-1;
    range.length = 1;
    NSMutableAttributedString *attStr = [self.chatInputTextView.attributedText mutableCopy];
    [attStr deleteCharactersInRange:range];
    self.chatInputTextView.attributedText = attStr;
    self.chatInputTextView.selectedRange = range;
    [self textViewChangeText];
}

@end


