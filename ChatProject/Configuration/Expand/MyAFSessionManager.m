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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"api.bonday.cn" ofType:@".cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:path];
    NSSet *cerSet = [NSSet setWithObjects:cerData, nil];
    
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
    policy.allowInvalidCertificates = YES;
    policy.validatesDomainName = YES;
    
    
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
            NSString *tokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            if (tokenStr) {
                [manager.requestSerializer setValue:[@"Bearer "stringByAppendingString:tokenStr] forHTTPHeaderField:@"Authorization"];
            }else{
                
                [manager.requestSerializer setValue:[MyTools getUdid] forHTTPHeaderField:@"udid"];
            }
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
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            NSString *tokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            if (tokenStr) {
                [manager.requestSerializer setValue:[@"Bearer "stringByAppendingString:tokenStr] forHTTPHeaderField:@"Authorization"];
            }else{
                [manager.requestSerializer setValue:[MyTools getUdid]  forHTTPHeaderField:@"udid"];
            }
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
    
    return manager;
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
- (void)uploadWithURLString:(NSString *)URLString parameters:(nullable id)parameters uploadParameter:(nullable uploadParameter *)uploadPara success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(NSError *error))failure{
    
    [self POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:uploadPara.data name:uploadPara.paraName fileName:uploadPara.fileName mimeType:uploadPara.mimeType];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
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
