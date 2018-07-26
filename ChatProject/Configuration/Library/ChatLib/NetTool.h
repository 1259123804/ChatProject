//
//  NetTool.h
//  MyMVVM
//
//  Created by bonday012 on 17/2/24.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetTool : NSObject
+(NetTool *)shareManager;
#pragma 监测网络的可链接性
-(BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl;


/**
 
 */
-(void)httpGetRequest:(NSString *)url withParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *dataDic))success failure:(void (^)(NSError *error))failure;
-(void)httpPostRequest:(NSString *)url withParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *dataDic))success failure:(void (^)(NSError *error))failure;

@end
