//
//  UIScrollView+Refresh.m
//  BonDay
//
//  Created by   文进 on 16/2/25.
//  Copyright © 2016年 BonDay. All rights reserved.
//

#import "UIScrollView+Refresh.h"

@implementation UIScrollView (Refresh)

/** 添加头部刷新 */
- (void)addHeaderRefresh:(MJRefreshComponentRefreshingBlock)refreshBlock{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshBlock];
}
/** 开始头部刷新 */
- (void)beginHeaderRefresh{
    [self.mj_header beginRefreshing];
}
/** 结束头部刷新 */
- (void)endHeaderRefresh{
    [self.mj_header endRefreshing];
}
/** 添加脚部刷新 */
- (void)addFooterRefresh:(MJRefreshComponentRefreshingBlock)refreshBlock{
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshBlock];
}
/** 开始脚部刷新 */
- (void)beginFooterRefresh{
    [self.mj_footer beginRefreshing];
}
/** 结束脚部刷新 */
- (void)endFooterRefresh{
    [self.mj_footer endRefreshing];
}


@end

