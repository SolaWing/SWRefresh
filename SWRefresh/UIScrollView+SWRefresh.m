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
    id<SWRefreshHeaderController> oldHeader = self.refreshHeader;
    if (oldHeader != refreshHeader) {
        if (oldHeader) { oldHeader.scrollView = nil; }
        objc_setAssociatedObject(self, @selector(refreshHeader), refreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (refreshHeader) {
            refreshHeader.scrollView = self;
        }
    }
}

- (id<SWRefreshFooterController>)refreshFooter {
    return objc_getAssociatedObject(self, @selector(refreshFooter));
}

- (void)setRefreshFooter:(id<SWRefreshFooterController>)refreshFooter {
    id<SWRefreshFooterController> oldFooter = self.refreshFooter;
    if (oldFooter != refreshFooter) {
        if (oldFooter) { oldFooter.scrollView = nil; }
        objc_setAssociatedObject(self, @selector(refreshFooter), refreshFooter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (refreshFooter) {
            refreshFooter.scrollView = self;
        }
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

@end
