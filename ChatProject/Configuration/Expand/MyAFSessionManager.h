//
//  MyAFSessionManager.h
//  BonDay
//
//  Created by 李小光 on 16/5/19.
//  Copyright © 2016年 Bonday. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, MyAFSessionManagerType) {
    MyAFSessionManagerTypeDefault          = 0,
    MyAFSessionManagerTypeWithToken        = 1,
    MyAFSessionManagerTypeJsonWithoutToken = 2,
    MyAFSessionManagerTypeJsonWithToken    = 3,
    MyAFSessionManagerTypeTextPlainWithoutToken = 4,
};

typedef NS_ENUM(NSUInteger, MyRequestType){
    
    MyRequestTypeGet                       = 0,
    MyRequestTypePost                      = 1,
    MyRequestTypePut                       = 2,
    MyRequestTypeDelete                    = 3,
    MyRequestTypePatch                     = 4,
};

NS_ASSUME_NONNULL_BEGIN

@interface uploadParameter : NSObject
/**
 *  上传的数据
 */
@property (nonatomic, strong) NSData *data;
/**
 *  服务器的参数名字
 */
@property (nonatomic, copy) NSString *paraName;
/**
 *  服务器上保存的文件名字
 */
@property (nonatomic, copy) NSString *fileName;
/**
 *上传的类型
 */
@property (nonatomic, copy) NSString *mimeType;
@end

@interface MyAFSessionManager : AFHTTPSessionManager

//初始化
+ (nullable instancetype)initMyAFSessionManagerWithType:(MyAFSessionManagerType)managerType;

//发送请求
+ (void)requestWithURLString:(NSString *)URLString parameters:(nullable id)parameters requestType:(MyRequestType)requestType managerType:(MyAFSessionManagerType)managerType success:(nullable void (^)(id _Nullable responseObject))success failure:(nullable void(^)(NSError * error))failure;

//get请求
- (void)getWithURLString:(NSString *)URLString parameters:(nullable id)parameters successs:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(NSError *error))failure;

//post请求
- (void)postWithURLString:(NSString *)URLString parameters:(nullable id)parameters success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(NSError *error))failure;

//upload请求
+ (void)uploadWithURLString:(NSString *)URLString parameters:(nullable id)parameters uploadParameter:(nullable id)uploadPara success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(NSError *error))failure;

//delete请求
- (void)deleteWithURLString:(NSString *)URLString parameters:(nullable id)parameters success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(NSError *error))failure;

//patch请求
- (void)patchWithURLString:(NSString *)URLString parameters:(nullable id)parameters success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(NSError *error))failure;
+(void)cleatresponseObject:(id)responseObject;
NS_ASSUME_NONNULL_END
@end
