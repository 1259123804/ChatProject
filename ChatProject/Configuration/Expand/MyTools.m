//
//  MyTools.m
//  BonDay
//
//  Created by 李小光 on 16/5/4.
//  Copyright © 2016年 Bonday. All rights reserved.
//

#import "MyTools.h"
#import "ChatEmojiIcons.h"
#import "EmojiContent.h"
#import "EmojiTextAttachment.h"
#import "GTMBase64.h"
#import "AESCrypt.h"
#import "KeychainItemWrapper.h"
#define SoltKey @"RzWXIlfXVrlTK999"
@implementation MyTools
+ (MyTools *)defaultTools{
    
    static MyTools *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (tools == nil){
            
            tools = [[MyTools alloc] init];
        }
    });
    return tools;
}

- (void)getLocation{
    
    self.latitude = @"-1";
    self.longitude = @"-1";
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        //设置寻址精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 5.0;
        [self.locationManager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    //设置提示提醒用户打开定位服务
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *currentLocation = [locations lastObject];
    self.latitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    [self.locationManager stopUpdatingHeading];
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    if (self.getLocationComplete){
        
        self.getLocationComplete();
    }
    
//    //反地理编码
//    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (placemarks.count > 0) {
//            CLPlacemark *placeMark = placemarks[0];
//            currentCity = placeMark.locality;
//            if (!currentCity) {
//                currentCity = @"无法定位当前城市";
//            }
//
//            /*看需求定义一个全局变量来接收赋值*/
//            NSLog(@"----%@",placeMark.country);//当前国家
//            NSLog(@"%@",currentCity);//当前的城市
//            //            NSLog(@"%@",placeMark.subLocality);//当前的位置
//            //            NSLog(@"%@",placeMark.thoroughfare);//当前街道
//            //            NSLog(@"%@",placeMark.name);//具体地址
//
//        }
//    }];
    
}


+ (BOOL)judgePhoneNumLegalWithPhone:(NSString *)phone
{
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:phone];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:phone];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:phone];
    
    if (isMatch1 || isMatch2 || isMatch3) {
        
        return YES;
    }
    return NO;
}

+ (NSMutableAttributedString *)EmojiTextInTextView:(NSString*)text
{
    NSMutableAttributedString *emojiText = [[NSMutableAttributedString alloc]initWithString:text];
    
    NSArray *emojiArr = [ChatEmojiIcons emojis];
    
    // 若存在[就遍历所有的表情
    do {
        BOOL bFindEmoji = NO;
        for (EmojiContent *content in emojiArr) {
            // 有表情
            if ([text rangeOfString:content.text].location != NSNotFound) {
                bFindEmoji = YES;
                // 模拟属性字符串,使用普通文本占领表情位置,方便确定表情位置
                NSRange range = [text rangeOfString:content.text];
                text = [text stringByReplacingCharactersInRange:range withString:@"1"];
                // 转换成表情图片
                UIImage *img = [UIImage imageNamed:content.name];
                EmojiTextAttachment *attach = [[EmojiTextAttachment alloc]initWithData:nil ofType:nil];
                if(img) {
                    attach.image = img;
                    attach.emoName = content.name;
                    attach.Top = -3.5;
                }
                NSAttributedString *replaceAttri = [NSAttributedString attributedStringWithAttachment:attach];
                [emojiText replaceCharactersInRange:range withAttributedString:replaceAttri];
                if ([text rangeOfString:@"["].location == NSNotFound){
                    break;
                }
            }
        }
        // 若没有查找到一个表情,就退出
        if (bFindEmoji == NO) {
            break;
        } else {
            bFindEmoji = NO;
        }
    }while ([text rangeOfString:@"["].location != NSNotFound);
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    [style setLineSpacing:4];
//    [emojiText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, emojiText.length)];
    
    return emojiText;
    
    
}

#pragma mark - 转化为表情格式文字
+ (NSMutableAttributedString *)EmojiTextInTextViewWithAttributeString:(NSMutableAttributedString *)attributestring
{
    
    NSString *text = attributestring.string;
    NSArray *emojiArr = [ChatEmojiIcons emojis];
    
    // 若存在[就遍历所有的表情
    do {
        BOOL bFindEmoji = NO;
        for (EmojiContent *content in emojiArr) {
            // 有表情
            if ([text rangeOfString:content.text].location != NSNotFound) {
                bFindEmoji = YES;
                // 模拟属性字符串,使用普通文本占领表情位置,方便确定表情位置
                NSRange range = [text rangeOfString:content.text];
                text = [text stringByReplacingCharactersInRange:range withString:@"1"];
                
                // 转换成表情图片
                UIImage *img = [UIImage imageNamed:content.name];
                
                EmojiTextAttachment *attach = [[EmojiTextAttachment alloc]initWithData:nil ofType:nil];
                if(img) {
                    attach.image = img;
                    attach.emoName = content.name;
                    attach.Top = -3.5;
                }
                
                NSAttributedString *replaceAttri = [NSAttributedString attributedStringWithAttachment:attach];
                [attributestring replaceCharactersInRange:range withAttributedString:replaceAttri];
                if ([text rangeOfString:@"["].location == NSNotFound){
                    break;
                }
            }
        }
        // 若没有查找到一个表情,就退出
        if (bFindEmoji == NO) {
            break;
        } else {
            bFindEmoji = NO;
        }
    }while ([text rangeOfString:@"["].location != NSNotFound);
    //    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    //    [style setLineSpacing:4];
    //    [emojiText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, emojiText.length)];
    
    return attributestring;
    
    
}
+ (CGSize)getImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;// url不正确返回CGSizeZero
    
//    NSString* absoluteString = URL.absoluteString;
    
#ifdef dispatch_main_sync_safe
    if([[SDImageCache sharedImageCache] diskImageExistsWithKey:absoluteString])
    {
        UIImage* image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:absoluteString];
        if(!image)
        {
            NSData* data = [[SDImageCache sharedImageCache] performSelector:@selector(diskImageDataBySearchingAllPathsForKey:) withObject:URL.absoluteString];
            image = [UIImage imageWithData:data];
        }
        if(image)
        {
            return image.size;
        }
    }
#endif
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self getGIFImageSizeWithRequest:request];
    }
    else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        
        if(image)
        {
#ifdef dispatch_main_sync_safe
            [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:YES imageData:data forKey:URL.absoluteString toDisk:YES];
#endif
            size = image.size;
        }
    }
    return size;
}

- (id)diskImageDataBySearchingAllPathsForKey:(id)key
{
    return nil;
}




//  获取PNG图片的大小
+ (CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request

{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取gif图片的大小
+ (CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request

{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

//  获取jpg图片的大小
+ (CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ([data length] <= 0x58) {
        
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
            
        }else if (word == 0xe1) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xaf, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xb0, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xad, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xae, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
            
        } else {
            
            return CGSizeMake(160, 120);
        }
    }
}

#pragma mark - 计算两个时间的差
+ (NSString *)intervalFromLastDate: (NSInteger)late1  toTheDate:(NSInteger)late2
{
    NSInteger cha = late2-late1;
    if (cha < 60 ) {
        return @"刚刚";
        
    }else if (cha < 60*60) {
        
        return [NSString stringWithFormat:@"%ld分钟前", cha/60];
    }else if (cha < 60*60*24){
        return [NSString stringWithFormat:@"%ld小时前", cha/3600];
    }else if (cha <60*60*24*2){
        return [NSString stringWithFormat:@"昨天"];
    }else if (cha <60*60*24*3){
        return [NSString stringWithFormat:@"前天"];
    }else{
        
        NSDateFormatter *matter = [[NSDateFormatter alloc] init];
        [matter setDateFormat:@"yyyy年MM日dd时"];
        
        NSDate *Date = [NSDate dateWithTimeIntervalSince1970:late1];
        
        return [matter stringFromDate:Date];
    }
    
}

+ (CGSize)getSizeWithlimitSize:(CGSize)size font:(CGFloat)fontSize String:(NSString *)string{
    
    CGSize mySize = [string boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return mySize;
}



+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
        
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
        
    } else if (rootViewController.presentedViewController) {
        
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
        
    } else {
        
        return rootViewController;
    }
}

//压缩图片
+ (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    
    CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,0.5);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        return finallImageData;
    }
    
    return imageData;
}
#pragma mark - 上传阿里云
+ (NSString *)aliyunwithImage:(UIImage *)image
{
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    [matter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateStr = [matter stringFromDate:[NSDate date]];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]) {
        
        dateStr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] stringByAppendingString:dateStr];
    }else{
        
        NSString *str = nil;
        
        for (int i = 0; i<16; i++) {
            
            str = [NSString stringWithFormat:@"%d", arc4random()%10];
        }
        
        dateStr = [dateStr stringByAppendingString:str];
    }
    
    id<OSSCredentialProvider> credential = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
        NSString *signature = nil;
        NSString *accessId = nil;
        NSString *putUrl = @""; //上传接口
        NSURL * URL = [NSURL URLWithString:putUrl];
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:URL];
        [request setHTTPMethod:@"post"];
        NSString *param=[NSString stringWithFormat:@"content=%@",contentToSign];
        [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
        NSError *error1 = nil;
        NSURLResponse * response = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error1];
        if (error1) {
            NSLog(@"error: %@",[error1 localizedDescription]);
        }else{
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *dic = dataDic[@"data"];
            signature = dic[@"signature"];
            accessId = dic[@"accessId"];
        }
        return [NSString stringWithFormat:@"OSS %@:%@",accessId, signature];
    }];
    NSString *endPoint = @"http://oss-cn-hangzhou.aliyuncs.com";
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential];
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    put.bucketName = @"bonday";
    //选择的图片
    NSData *data = [MyTools resetSizeOfImageData:image maxSize:100];
    for (int i = 0; i < 6; i++) {
        NSLog(@"%d", arc4random()%9);
        dateStr = [dateStr stringByAppendingString:[NSString stringWithFormat:@"%d", arc4random()%9]];
    }
    put.objectKey = [NSString stringWithFormat:@"images/%@.png", dateStr];
    put.uploadingData = UIImagePNGRepresentation([UIImage imageWithData:data]);
    //  [_imageArray addObject:put.objectKey];
    OSSTask *putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"upload object success!");
            
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
        
    }];
    
    return put.objectKey;
}

#pragma mark-时间戳转化时间
+ (NSString *)dateStringWithinteger:(NSInteger)timeInteger choice:(int)choice
{
    NSInteger dateInt = timeInteger/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateInt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    switch (choice) {
        case 1:
            [formatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case 2:
            [formatter setDateFormat:@"MM月dd日"];
            break;
        case 3:
            [formatter setDateFormat:@"HH:mm"];
        default:
            break;
    }
    
    return [formatter stringFromDate:date];
}

//获取的输入字符串并调用方法判断是否全是数字

+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string]; //定义一个NSScanner，扫描string
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+ (UIImage *)resizableImageWithImage:(UIImage *)image
{
    // 获取原有图片的宽高的一半
    CGFloat w = image.size.width * 0.5;
    CGFloat h = image.size.height * 0.5;
    // 生成可以拉伸指定位置的图片
    UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];
    return newImage;
}

#pragma mark - push界面
+ (void)pushViewControllerFrom:(UIViewController *)formerViewController To:(UIViewController *)lastedViewController animated:(BOOL)animated{

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    formerViewController.navigationItem.backBarButtonItem = barButtonItem;
    formerViewController.navigationController.navigationBar.tintColor = UIColorWithRGBA(74, 74, 74, 1);
    [lastedViewController setHidesBottomBarWhenPushed:YES];
    [formerViewController.navigationController pushViewController:lastedViewController animated:animated];
    
}

#pragma mark - AES BASE64解码
+ (NSString *)base64AndAesWithString:(NSString *)codeString{
   
    NSString *aesString = [AESCrypt decrypt:codeString password:SoltKey];
    NSString *base64String = [GTMBase64 decodeBase64String:aesString];
    return [GTMBase64 decodeBase64String:base64String];
}

#pragma mark - 设置内部阴影
+ (void)setInnerShadowWithView:(UIView *)baseView{
    
    CAShapeLayer* shadowLayer = [CAShapeLayer layer];
    [shadowLayer setFrame:baseView.bounds];
    
    // Standard shadow stuff
    [shadowLayer setShadowColor:[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] CGColor]];
    [shadowLayer setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    [shadowLayer setShadowOpacity:1.0f];
    [shadowLayer setShadowRadius:1];
    
    // Causes the inner region in this example to NOT be filled.
    [shadowLayer setFillRule:kCAFillRuleEvenOdd];
    
    // Create the larger rectangle path.
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectInset(baseView.bounds, -42, -42));
    
    // Add the inner path so it's subtracted from the outer path.
    // someInnerPath could be a simple bounds rect, or maybe
    // a rounded one for some extra fanciness.
    CGPathRef someInnerPath = [UIBezierPath bezierPathWithRoundedRect:baseView.bounds cornerRadius:0.0f].CGPath;
    CGPathAddPath(path, NULL, someInnerPath);
    CGPathCloseSubpath(path);
    
    [shadowLayer setPath:path];
    CGPathRelease(path);
    
    [[baseView layer] addSublayer:shadowLayer];
    CAShapeLayer* maskLayer = [CAShapeLayer layer];
    [maskLayer setPath:someInnerPath];
    [shadowLayer setMask:maskLayer];
    
}

//裁剪图片
+ (UIImage *)cutImageWithSourceImage:(UIImage *)sourceImage size:(CGSize)targetSize{
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect targetRect = CGRectZero;
    
    //裁剪后的image的原点位置
    targetRect.origin = CGPointZero;
    
    //裁剪后的image的宽度
    targetRect.size.width  = sourceImage.size.width;
    
    //裁剪后的image的长度
    targetRect.size.height = sourceImage.size.height-20;
    
    //裁剪图片
    [sourceImage drawInRect:targetRect];
    
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//旋转图片
+ (UIImage *)translateMyImage:(UIImage *)image superImage:(UIImage *)superImage{
    
    float scaleX = 1.0;
    float scaleY = 1.0;
    double rotate = M_PI;
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    float translateX = -rect.size.width;
    float translateY = -rect.size.height;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), superImage.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
    
}

//获取课点，个人信息
+ (void)getLessonPointWithBlock:(void (^)(void))completion{
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"user_token"]) {
        
        NSString *url = @""; //获取个人信息
        url = [NSString stringWithFormat:url, [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]];
        [MyAFSessionManager requestWithURLString:url parameters:nil requestType:MyRequestTypeGet managerType:MyAFSessionManagerTypeJsonWithToken success:^(id  _Nullable responseObject) {
            
            if ([responseObject[@"code"] intValue] == 200) {
                
               
                if (completion) {
                    
                    completion();
                }
            }
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
}

+ (void)mergeVisitorAndLoginorWithController:(UIViewController *)controller WithBlock:(void (^)(UIAlertView *))completion{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否将游客模式中购买的课点，课程与App账户合并" message:nil delegate:controller cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    [alertView show];
    
    if (completion) {
        
        completion(alertView);
    }
}

+ (NSString *)getUdid{
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"myKey" accessGroup:nil];
    NSString *udid = [wrapper objectForKey:(__bridge id)kSecAttrAccount];
    if ([udid isEqualToString:@""] || udid.length == 0 || udid == nil) {
        
        udid = [UIDevice currentDevice].identifierForVendor.UUIDString;
        [wrapper setObject:udid forKey:(__bridge id)kSecAttrAccount];
    }
    return udid;
}

+ (UIColor *)turnToUIColorWithColorStr:(NSString *)color{
    
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return UIColorWithRGBA(r, g, b, 1);
}

//jpush设置tags和alias
+ (void)jpushSetTagsAndTags{
    
    if (DefaultsObjectForKey(@"user_id")) {
        
        [JPUSHService setTags:nil alias:DefaultsObjectForKey(@"user_id") fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            
            NSLog(@"%@", iAlias);
        }];
        
    }else{
        
        [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            
            NSLog(@"%@", iAlias);
        }];
    }
}
//图片转换成https
+ (NSString *)changeUrlWithString:(NSString *)url{
    
    if (url) {
        
        if ([url hasPrefix:@"http"]) {
            
            url = [url stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
        }else{
            url = [@"" stringByAppendingString:url];
        }
    }
    return url;
}

+ (UIView *)maskBackgroundViewWithFrame:(CGRect)rect corners:(UIRectCorner)corners size:(CGSize)size shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius shadowColor:(UIColor *)shadowColor{
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:rect];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.cornerRadius = size.width;
    backgroundView.clipsToBounds = NO;
    backgroundView.layer.shadowColor = shadowColor.CGColor;
    backgroundView.layer.shadowOffset = shadowOffset;
    backgroundView.layer.shadowOpacity = 1;
    backgroundView.layer.shadowRadius = shadowRadius;
    
    UIView *headView = [[UIView alloc] initWithFrame:backgroundView.bounds];
    [backgroundView addSubview:headView];
    headView.sd_layout
    .topEqualToView(backgroundView)
    .leftEqualToView(backgroundView)
    .rightEqualToView(backgroundView)
    .bottomEqualToView(backgroundView);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:headView.bounds byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = headView.bounds;
    shapeLayer.path = bezierPath.CGPath;
    headView.layer.mask = shapeLayer;
    return backgroundView;
}
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size{
    //iOS7之后
    /*
     第一个参数: 预设空间 宽度固定  高度预设 一个最大值
     第二个参数: 行间距 如果超出范围是否截断
     第三个参数: 属性字典 可以设置字体大小
     */
    
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    //返回计算出的行高
    return rect.size.height;
}

+ (void)setTitleLableWithController:(UIViewController *)controller title:(NSString *)title isSystem:(BOOL)system fontSize:(CGFloat)fontSize textColor:(UIColor *)color{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.textColor = color;
    label.text = title;
    label.font = system ? [UIFont systemFontOfSize:fontSize] : [UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium];
    label.textAlignment = NSTextAlignmentCenter;
    controller.navigationItem.titleView = label;
}

+ (void)wkwebView:(WKWebView *)webView jumpBrowser:(BOOL)jumpBrowser checkAction:(WKNavigationAction *)navigationAction handler:(void(^)(WKNavigationActionPolicy))handler{
    
    if (!jumpBrowser) {
        
        if (navigationAction.targetFrame == nil){
            
            [webView loadRequest:navigationAction.request];
        }
        
    }else{
        NSURL *URL = navigationAction.request.URL;
        NSString *scheme = [URL scheme];
        if ([scheme isEqualToString:@"tel"]) {
            NSString *resourceSpecifier = [URL resourceSpecifier];
            NSString *callPhone = [NSString stringWithFormat:@"tel://%@", resourceSpecifier];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            });
            handler(WKNavigationActionPolicyCancel);
            return;
        }else if (([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"] || [scheme isEqualToString:@"mailto"]) && (navigationAction.navigationType == WKNavigationTypeLinkActivated)){
            
            [[UIApplication sharedApplication] openURL: URL];
            handler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    handler(WKNavigationActionPolicyAllow);
}

+ (NSString *)suitImageViewAndFontSizeWithString:(NSString *)content{
    
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<style type=\"text/css\"> \n"
                       "body {font-size:40px;color:#686868}\n"
                       "</style> \n"
                       "</head> \n"
                       "<body>"
                       "<script type='text/javascript'>"
                       "window.onload = function(){\n"
                       "var $img = document.getElementsByTagName('img');\n"
                       "for(var p in  $img){\n"
                       " $img[p].style.width = '100%%';\n"
                       "$img[p].style.height ='auto'\n"
                       "}\n"
                       "}"
                       "</script>%@"
                       "</body>"
                       "</html>", content];
    return htmls;
}

+ (void)savePersonInfoWithDic:(NSDictionary *)infoDic{
    
    NSDictionary *user = infoDic[@"user"];
    DefaultsSetValueForKey(infoDic[@"token"], kUser_token);
    DefaultsSetValueForKey(user[@"name"], kUser_name);
    DefaultsSetValueForKey(user[@"avatar"], kUser_avatar);
    DefaultsSynchronize;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_dismissLogin object:nil];
}

@end
