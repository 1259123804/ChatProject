//
//  NetTool.m
//  MyMVVM
//
//  Created by bonday012 on 17/2/24.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "NetTool.h"

@implementation NetTool

+(NetTool *)shareManager{

    static NetTool *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        if (manager == nil) {
            manager = [[NetTool alloc]init];
        }
    });
    return manager;
}
-(void)httpGetRequest:(NSString *)url withParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *tokenStr = DefaultsValueForKey(kUser_token);
    if (tokenStr) {
        [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"token"];
    }
    [manager GET:url parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            NSDictionary *dic = nil;
            if ([responseObject isKindOfClass:[NSData class]]) {
                dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            }else{
                dic = responseObject;
            }
            success(dic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
     
}
-(void)httpPostRequest:(NSString *)url withParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //wode
    NSString *tokenStr = DefaultsObjectForKey(kUser_token);
    if (tokenStr) {
        [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"token"];
    }

//    [manager GET:url parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        if (success) {
//            NSDictionary *dic = nil;
//            if ([responseObject isKindOfClass:[NSData class]]) {
//                dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            }else{
//                dic = responseObject;
//            }
//            success(dic);
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
    
    [manager POST:url parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSDictionary *dic = nil;
            if ([responseObject isKindOfClass:[NSData class]]) {
                dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            }else{
                dic = responseObject;
            }
            success(dic);
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }

    }];
    
}
-(BOOL)netWorkReachabilityWithURLString:(NSString *)strUrl{
    __block BOOL netState = NO;
    
    NSURL *baseURL = [NSURL URLWithString:strUrl];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:baseURL];
    NSOperationQueue *operationQueue = manager.operationQueue;
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                netState = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netState = NO;
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
    
    return netState;

}
@end
