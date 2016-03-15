//
//  UIScrollView+SWRefresh.m
//  SWRefresh
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import "UIScrollView+SWRefresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (SWRefresh)

- (id<SWRefreshHeaderController>)refreshHeader {
    return objc_getAssociatedObject(self, @selector(refreshHeader));
}

- (void)setRefreshHeader:(id<SWRefreshHeaderController>)refreshHeader {
    objc_setAssociatedObject(self, @selector(refreshHeader), refreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (refreshHeader) {
        refreshHeader.scrollView = self;
    }
}

- (id<SWRefreshFooterController>)refreshFooter {
    return objc_getAssociatedObject(self, @selector(refreshFooter));
}

- (void)setRefreshFooter:(id<SWRefreshFooterController>)refreshFooter {
    objc_setAssociatedObject(self, @selector(refreshFooter), refreshFooter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (refreshFooter) {
        refreshFooter.scrollView = self;
    }
}

#pragma mark - computed property
- (SWRefreshHeaderViewModel *)refreshHeaderModel { return [self.refreshHeader headerModel]; }
- (SWRefreshFooterViewModel *)refreshFooterModel { return [self.refreshFooter footerModel]; }
- (UIView<SWRefreshView> *)refreshHeaderView { return [self.refreshHeader headerView]; }
- (UIView<SWRefreshView> *)refreshFooterView { return [self.refreshFooter footerView]; }
- (void)setRefreshHeaderModel:(__kindof SWRefreshHeaderViewModel *)refreshHeaderModel {
    [self.refreshHeader setHeaderModel:refreshHeaderModel];
}

- (void)setRefreshFooterModel:(__kindof SWRefreshFooterViewModel *)refreshFooterModel {
    [self.refreshFooter setFooterModel:refreshFooterModel];
}

- (void)setRefreshHeaderView:(__kindof UIView<SWRefreshView> *)refreshHeaderView {
    id<SWRefreshHeaderController> controller = self.refreshHeader;
    if (!refreshHeaderView) {
        [controller setHeaderView:nil];
        return;
    }
    if (!controller) {
         controller = [[refreshHeaderView.class defaultHeaderControllerClass] new];
    }
    [controller setHeaderModel:(id)refreshHeaderView.sourceViewModel];
    [controller setHeaderView:refreshHeaderView];
}

- (void)setRefreshFooterView:(__kindof UIView<SWRefreshView> *)refreshFooterView {
    id<SWRefreshFooterController> controller = self.refreshFooter;
    if (!refreshFooterView) {
        [controller setFooterView:nil];
        return;
    }
    if (!controller) {
        controller = [[refreshFooterView.class defaultFooterControllerClass] new];
    }
    [controller setFooterModel:(id)refreshFooterView.sourceViewModel];
    [controller setFooterView:refreshFooterView];
}

+ (Class)defaultRefreshHeaderClass { return [SWRefreshHeaderController class]; }
+ (Class)defaultRefreshFooterClass { return [SWRefreshFooterController class]; }
@end
