//
//  MyTools.h
//  BonDay
//
//  Created by 李小光 on 16/5/4.
//  Copyright © 2016年 Bonday. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface MyTools : NSObject <UIAlertViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) NSString *latitude; //经度
@property (nonatomic, copy) NSString *longitude; //纬度
@property (nonatomic, copy) void(^getLocationComplete)(void);
@property (nonatomic, retain) UIViewController *topViewController; 
+ (MyTools *)defaultTools;
- (void)getLocation;

//判断手机号
+ (BOOL)judgePhoneNumLegalWithPhone:(NSString *)phone;
//转化表情符号
+ (NSMutableAttributedString *)EmojiTextInTextView:(NSString*)text;
+ (NSMutableAttributedString *)EmojiTextInTextViewWithAttributeString:(NSAttributedString *)attributestring;
//根据url获取图片的大小
+(CGSize)getImageSizeWithURL:(id)imageURL;

//  获取PNG图片的大小
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request;
//获取gif图片的大小
+(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request;
//  获取jpg图片的大小
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request;

#pragma mark - 计算两个时间的差
+ (NSString *)intervalFromLastDate: (NSInteger)late1  toTheDate:(NSInteger)late2;

//获取一段文字的size
+ (CGSize)getSizeWithlimitSize:(CGSize)size font:(CGFloat)fontSize String:(NSString *)string;

//压缩图片
+ (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize;
#pragma mark - 上传阿里云
+ (NSString *)aliyunwithImage:(UIImage *)image;
#pragma mark - 时间戳转化时间
+ (NSString *)dateStringWithinteger:(NSInteger)timeInteger choice:(int)choice;
#pragma mark - push界面
+ (void)pushViewControllerFrom:(UIViewController *)formerViewController To:(UIViewController *)lastedViewController animated:(BOOL)animated;
//传入textFiledLabel获取的输入字符串并调用方法判断
+ (BOOL)isPureInt:(NSString*)string;

//AES+Base64解码
+ (NSString *)base64AndAesWithString:(NSString *)codeString;
//设置内部阴影
+ (void)setInnerShadowWithView:(UIView *)baseView;
//裁剪图片
+ (UIImage *)cutImageWithSourceImage:(UIImage *)sourceImage size:(CGSize)targetSize;
//旋转图片
+ (UIImage *)translateMyImage:(UIImage *)image superImage:(UIImage *)superImage;
+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;
//获取游客课点
+ (void)getLessonPointWithBlock:(void(^)(void))completion;
+ (NSString *)getUdid;

//16进制字符串转成UIColor
+ (UIColor *)turnToUIColorWithColorStr:(NSString *)color;

//JPush设置alias
+ (void)jpushSetTagsAndTags;
//图片转换成https
+ (NSString *)changeUrlWithString:(NSString *)url;

+ (UIView *)maskBackgroundViewWithFrame:(CGRect)rect corners:(UIRectCorner)corners size:(CGSize)size shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius shadowColor:(UIColor *)shadowColor;

//标题
+ (void)setTitleLableWithController:(UIViewController *)controller title:(NSString *)title isSystem:(BOOL)system fontSize:(CGFloat)fontSize textColor:(UIColor *)color;
//wkwebView内部跳转验证
+ (void)wkwebView:(WKWebView *)webView jumpBrowser:(BOOL)jumpBrowser checkAction:(WKNavigationAction *)navigationAction handler:(void(^)(WKNavigationActionPolicy))handler;
+ (NSString *)suitImageViewAndFontSizeWithString:(NSString *)content;
+ (void)uploadImageWithImage:(NSArray *)uploadImages uploadType:(NSString *)type completion:(void(^)(NSDictionary *, NSArray *))completion;
+ (void)savePersonInfoWithDic:(NSDictionary *)infoDic isRegister:(BOOL)isRegister headImage:(UIImage *)headImage;
+ (void)clearUserInfo;
@end
