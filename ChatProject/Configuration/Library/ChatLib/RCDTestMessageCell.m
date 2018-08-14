//
//  RCDTestMessageCell.m
//  RCloudMessage
//
//  Created by 岑裕 on 15/12/17.
//  Copyright © 2015年 RongCloud. All rights reserved.
//

#import "RCDTestMessageCell.h"

#define Test_Message_Font_Size 15

@implementation RCDTestMessageCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
  RCDTestMessage *message = (RCDTestMessage *)model.content;
  CGSize size = [RCDTestMessageCell getBubbleBackgroundViewSize:message];
  
  CGFloat __messagecontentview_height = size.height;
  __messagecontentview_height += extraHeight;
  
  return CGSizeMake(collectionViewWidth, __messagecontentview_height);
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self initialize];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self initialize];
  }
  return self;
}

- (void)initialize {
  self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
  [self.messageContentView addSubview:self.bubbleBackgroundView];
  self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  [self.textLabel setFont:[UIFont systemFontOfSize:Test_Message_Font_Size]];

  self.textLabel.numberOfLines = 0;
  [self.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
  [self.textLabel setTextAlignment:NSTextAlignmentLeft];
  [self.textLabel setTextColor:UIColorWithRGBA(74, 74, 74, 1)];
  self.textLabel.userInteractionEnabled = YES;

  [self.bubbleBackgroundView addSubview:self.textLabel];
    //图片
    self.bondayImageV = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.bondayImageV.userInteractionEnabled = YES;
    [self.bubbleBackgroundView addSubview:self.bondayImageV];
    self.bondayImageV.layer.masksToBounds = YES;
    self.bondayImageV.layer.cornerRadius = 2.0f;
    
  self.bubbleBackgroundView.userInteractionEnabled = YES;
//  UILongPressGestureRecognizer *longPress =
//      [[UILongPressGestureRecognizer alloc]
//          initWithTarget:self
//                  action:@selector(longPressed:)];
//  [self.bubbleBackgroundView addGestureRecognizer:longPress];

  UITapGestureRecognizer *textMessageTap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(tapTextMessage:)];
  textMessageTap.numberOfTapsRequired = 1;
  textMessageTap.numberOfTouchesRequired = 1;
    
//  [self.textLabel addGestureRecognizer:textMessageTap];
//    [self.bondayImageV addGestureRecognizer:textMessageTap];
    [self.messageContentView  addGestureRecognizer:textMessageTap];
}

- (void)tapTextMessage:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%@",self.delegate);
  if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
    [self.delegate didTapMessageCell:self.model];
  }
}

- (void)setDataModel:(RCMessageModel *)model {
  [super setDataModel:model];
    
  [self setAutoLayout];
}

- (void)setAutoLayout {
  RCDTestMessage *testMessage = (RCDTestMessage *)self.model.content;
  if (testMessage) {
    self.textLabel.text = testMessage.title;
      if (testMessage.image) {
          NSString *imageUrl = nil;
        [self.bondayImageV sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
      }
  }
  CGSize textLabelSize = [[self class] getTextLabelSize:testMessage];
  CGSize bubbleBackgroundViewSize = [[self class] getBubbleSize:textLabelSize];
  CGRect messageContentViewRect = self.messageContentView.frame;
//接受
  //拉伸图片
  if (MessageDirection_RECEIVE == self.messageDirection) {
//    self.textLabel.frame =
//        CGRectMake(20, 7, textLabelSize.width, textLabelSize.height);

    messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
      messageContentViewRect.size.height = bubbleBackgroundViewSize.height;
    self.messageContentView.frame = messageContentViewRect;
    
    self.bubbleBackgroundView.frame = CGRectMake(
        0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height);
    UIImage *image = [RCKitUtility imageNamed:@"chat_from_bg_normal"
                                     ofBundle:@"RongCloud.bundle"];
    self.bubbleBackgroundView.image = [image
        resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,
                                                     image.size.width * 0.8,
                                                     image.size.height * 0.2,
                                                     image.size.width * 0.2)];
    //图片
      self.bondayImageV.sd_layout.topSpaceToView(self.bubbleBackgroundView,10)
      .leftSpaceToView(self.bubbleBackgroundView,18)
      .bottomSpaceToView(self.bubbleBackgroundView,10)
      .widthIs((bubbleBackgroundViewSize.height-20)*2);
      CGFloat height = [MyTools textHeightFromTextString:self.textLabel.text width:bubbleBackgroundViewSize.width - self.bondayImageV.width - 20 fontSize:15];
      CGFloat textLabelHeiht;
      if (bubbleBackgroundViewSize.height-20>height) {
          textLabelHeiht = height;
      }else{
          textLabelHeiht = bubbleBackgroundViewSize.height - 20;
      }
      self.textLabel.sd_layout.topSpaceToView(self.bubbleBackgroundView,10)
      .leftSpaceToView(self.bondayImageV,10)
      .rightSpaceToView(self.bubbleBackgroundView,10)
      .heightIs(height);
  }
    //发送frame
  else {
//    self.textLabel.frame =
//        CGRectMake(12, 7, textLabelSize.width, textLabelSize.height);

    messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
    messageContentViewRect.size.height = bubbleBackgroundViewSize.height;
    messageContentViewRect.origin.x =
        self.baseContentView.bounds.size.width -
        (messageContentViewRect.size.width + HeadAndContentSpacing +
         [RCIM sharedRCIM].globalMessagePortraitSize.width + 10);
    self.messageContentView.frame = messageContentViewRect;

    self.bubbleBackgroundView.frame = CGRectMake(
        0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height);
    UIImage *image = [RCKitUtility imageNamed:@"chat_to_bg_normal"
                                     ofBundle:@"RongCloud.bundle"];
    self.bubbleBackgroundView.image = [image
        resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,
                                                     image.size.width * 0.2,
                                                     image.size.height * 0.2,
                                                     image.size.width * 0.8)];
      self.bondayImageV.sd_layout.topSpaceToView(self.bubbleBackgroundView,10)
      .rightSpaceToView(self.bubbleBackgroundView,18)
      .bottomSpaceToView(self.bubbleBackgroundView,10)
      .widthIs((bubbleBackgroundViewSize.height-20)*2);
      CGFloat height = [MyTools textHeightFromTextString:self.textLabel.text width:bubbleBackgroundViewSize.width - self.bondayImageV.width - 20 fontSize:15];
      CGFloat textLabelHeiht;
      if (bubbleBackgroundViewSize.height-20>height) {
          textLabelHeiht = height;
      }else{
          textLabelHeiht = bubbleBackgroundViewSize.height - 20;
      }
      self.textLabel.sd_layout.topSpaceToView(self.bubbleBackgroundView,10)
      .rightSpaceToView(self.bondayImageV,10)
      .leftSpaceToView(self.bubbleBackgroundView,10)
      .heightIs(height);
  }
}

- (void)longPressed:(id)sender {
  UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
  if (press.state == UIGestureRecognizerStateEnded) {
    return;
  } else if (press.state == UIGestureRecognizerStateBegan) {
    [self.delegate didLongTouchMessageCell:self.model
                                    inView:self.bubbleBackgroundView];
  }
}

+ (CGSize)getTextLabelSize:(RCDTestMessage *)message {
  if ([message.title length] > 0) {
    float maxWidth =
        [UIScreen mainScreen].bounds.size.width -
        (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 -
        35;
    CGRect textRect = [message.title
        boundingRectWithSize:CGSizeMake(maxWidth/2, 8000)
                     options:(NSStringDrawingTruncatesLastVisibleLine |
                              NSStringDrawingUsesLineFragmentOrigin |
                              NSStringDrawingUsesFontLeading)
                  attributes:@{
                    NSFontAttributeName :
                        [UIFont systemFontOfSize:Test_Message_Font_Size]
                  }
                     context:nil];
    textRect.size.height = ceilf(textRect.size.height);
    textRect.size.width = ceilf(textRect.size.width);
    return CGSizeMake(textRect.size.width + 5, textRect.size.height + 5);
  } else {
    return CGSizeZero;
  }
}

+ (CGSize)getBubbleSize:(CGSize)textLabelSize {
  CGSize bubbleSize = CGSizeMake(textLabelSize.width, textLabelSize.height);

  if (bubbleSize.width + 12 + 20 > 50) {
    bubbleSize.width = bubbleSize.width + 12 + 20;
  } else {
    bubbleSize.width = 50;
  }
  if (bubbleSize.height + 7 + 7 > 40) {
    bubbleSize.height = bubbleSize.height + 7 + 7;
  } else {
    bubbleSize.height = 40;
  }
//最低约束
    bubbleSize.width = kScreenWidth - 80;
    bubbleSize.height = (kScreenWidth - 80)*0.29;
  return bubbleSize;
}

+ (CGSize)getBubbleBackgroundViewSize:(RCDTestMessage *)message {
  CGSize textLabelSize = [[self class] getTextLabelSize:message];
  return [[self class] getBubbleSize:textLabelSize];
}

@end
