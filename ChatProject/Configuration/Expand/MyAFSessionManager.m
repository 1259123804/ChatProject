//
//  MyAFSessionManager.m
//  BonDay
//
//  Created by 李小光 on 16/5/19.
//  Copyright © 2016年 Bonday. All rights reserved.
//

#import "MyAFSessionManager.h"

@implementation MyAFSessionManager

+ (instancetype)initMyAFSessionManagerWithType:(MyAFSessionManagerType)managerType
{
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"api.bonday.cn" ofType:@".cer"];
//    NSData *cerData = [NSData dataWithContentsOfFile:path];
//    NSSet *cerSet = [NSSet setWithObjects:cerData, nil];
//    
//    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
//    policy.allowInvalidCertificates = YES;
//    policy.validatesDomainName = YES;
    
    
    MyAFSessionManager *manager = [super manager];
//    manager.securityPolicy = policy;
//    //是否需要验证自建证书，需要设置为YES
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    //是否需要验证域名，默认YES
//    manager.securityPolicy.validatesDomainName = YES;
    switch (managerType) {
        case 0:
        {
          manager.responseSerializer = [AFJSONResponseSerializer serializer];
          manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        }
           break;
        case 1:
        {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }
            break;
            
        case 2:
        {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        }
            break;
        
        case 3:
        {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
        }
            break;
        case 4:
        {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager.requestSerializer setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
            [manager.requestSerializer setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
            [manager.requestSerializer setValue:@"text/plain; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        }
            break;
        default:
            break;
    }
    [self getAppSignWithManager:manager];
    
    return manager;
}

+ (void)getAppSignWithManager:(MyAFSessionManager *)manager{
    
    NSString *sign = @"";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *interval =  [NSString stringWithFormat:@"%.0f",[NSDate date].timeIntervalSince1970];
    NSString *longitude, *latitude = @"";
    NSMutableDictionary *signDic = [@{@"cv": app_Version, @"os": @"ios", @"timestamp": interval} mutableCopy];
    NSString *token = DefaultsValueForKey(kUser_token);
    [signDic setValue:token ? token : @" " forKey:@"token"];
    [signDic setValue:@" " forKey:@"iid"];
    [signDic setValue:@" " forKey:@"i"];
    [signDic setValue:@" " forKey:@"aid"];
    MyTools *tools = [MyTools defaultTools];
    if (tools.longitude != 0 && tools.latitude != 0){
        
        longitude = tools.longitude;
        latitude = tools.latitude;
        [signDic setValue:longitude forKey:@"lng"];
        [signDic setValue:latitude forKey:@"lat"];
    }
    NSArray *keys = [signDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSString *str1 = obj1;
        NSString *str2 = obj2;
        NSComparisonResult result = [str1 compare:str2];
        return result == NSOrderedDescending; // 升序
    
    }];
    
    for (int i = 0; i < keys.count; i++){
        
        NSString *key = keys[i];
        [manager.requestSerializer setValue:signDic[key] forHTTPHeaderField:key];
        NSString *item = [key stringByAppendingString:[NSString stringWithFormat:@"=%@",[signDic[key] isEqualToString:@" "] ? @"" : signDic[key]]];
        sign = [[sign stringByAppendingString:item] stringByAppendingString:(i == keys.count - 1) ?  @"qq2622298942" : @"&"];
        
    }
    sign = [sign MD5Hash];
    [manager.requestSerializer setValue:sign forHTTPHeaderField:@"sign"];
}

//发送请求
+ (void)requestWithURLString:(NSString *)URLString parameters:(nullable id)parameters requestType:(MyRequestType)requestType managerType:(MyAFSessionManagerType)managerType success:(nullable void (^)(id _Nullable responseObject))success failure:(nullable void(^)(NSError * error))failure{
    
    MyAFSessionManager *manager = [MyAFSessionManager initMyAFSessionManagerWithType:managerType];
    
    switch (requestType) {
        case MyRequestTypeGet:{
           
            [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if(success){
                    [self cleatresponseObject:responseObject];
                    success(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (failure) {
                    
                    failure(error);
                }
            }];
        }
            break;
        case MyRequestTypePost:{
            
            [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    [self cleatresponseObject:responseObject];
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (failure) {
                    
                    failure(error);
                }
            }];
        }
            break;
        case MyRequestTypePut:{
            
            [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    
                    success(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               
                if (failure) {
                    
                    failure(error);
                }
            }];
        }
            break;
        case MyRequestTypePatch:{
           
            
            [manager PATCH:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (responseObject[@"message"]) {
                    
                    MyAlertView(responseObject[@"message"], nil);
                    
                }
                if (success) {
                    
                    success(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                MyAlertView(@"网络错误", nil);
                if (failure) {
                    
                    failure(error);
                }
            }];
        }

            break;
        case MyRequestTypeDelete:{
            
            [manager DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                    
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               
                if (failure) {
                    
                    failure(error);
                }
            }];
            
        }
            break;
        default:
            break;
    }
}
+(void)cleatresponseObject:(id)responseObject{

    NSDictionary *dic = nil;
    if ([responseObject isKindOfClass:[NSData class]]) {
        
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    }else{
        dic = responseObject;
    }
    
    if ([dic[@"code"] intValue] == 2031) {
        
    }
    //无效的token,需要重新登录
    if ([dic[@"code"] intValue] == 1004) {
        
    }
}

//get请求
- (void)getWithURLString:(NSString *)URLString parameters:(nullable id)parameters successs:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(NSError *error))failure{
    
    [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            
            failure(error);
        }
    }];
    
}

//post请求
- (void)postWithURLString:(NSString *)URLString parameters:(nullable id)parameters success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(NSError *error))failure{
    
    [self postWithURLString:URLString parameters:parameters success:^(id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
        
    } failure:^(NSError * _Nonnull error) {
       
        if (failure) {
            
            failure(error);
        }
    }];
}

//upload请求
+ (void)uploadWithURLString:(NSString *)URLString parameters:(nullable id)parameters uploadParameter:(NSDictionary *)uploadPara success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(NSError *error))failure{
    
    MyAFSessionManager *manager = [MyAFSessionManager initMyAFSessionManagerWithType:MyAFSessionManagerTypeJsonWithToken];
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:uploadPara[@"data"] name:uploadPara[@"paraName"] fileName:uploadPara[@"fileName"] mimeType:uploadPara[@"mimeType"]];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"status"] intValue] == 0){
            
            if (success) {
                
                success(responseObject);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

//delete请求
- (void)deleteWithURLString:(NSString *)URLString parameters:(nullable id)parameters success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(NSError *error))failure{
    
    [self DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        if (failure) {
            
            failure(error);
        }
    }];
    
}

//patch请求
- (void)patchWithURLString:(NSString *)URLString parameters:(nullable id)parameters success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(NSError *error))failure{
    
    [self PATCH:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            
            failure(error);
        }
    }];
    
}

@end
