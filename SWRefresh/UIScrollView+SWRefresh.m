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

- (SWRefreshController*)refreshHeader {
    return objc_getAssociatedObject(self, @selector(refreshHeader));
}

- (void)setRefreshHeader:(SWRefreshController*)refreshHeader {
    SWRefreshController* oldHeader = self.refreshHeader;
    if (oldHeader != refreshHeader) {
        if (oldHeader) { oldHeader.scrollView = nil; }
        objc_setAssociatedObject(self, @selector(refreshHeader), refreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (refreshHeader) {
            refreshHeader.scrollView = self;
        }
    }
}

- (SWRefreshController*)refreshFooter {
    return objc_getAssociatedObject(self, @selector(refreshFooter));
}

- (void)setRefreshFooter:(SWRefreshController*)refreshFooter {
    SWRefreshController* oldFooter = self.refreshFooter;
    if (oldFooter != refreshFooter) {
        if (oldFooter) { oldFooter.scrollView = nil; }
        objc_setAssociatedObject(self, @selector(refreshFooter), refreshFooter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (refreshFooter) {
            refreshFooter.scrollView = self;
        }
    }
}

#pragma mark - computed property
- (id<SWRefreshViewModel>)refreshHeaderModel { return [(SWRefreshController*)self.refreshHeader model]; }
- (id<SWRefreshViewModel>)refreshFooterModel { return [(SWRefreshController*)self.refreshFooter model]; }
- (UIView<SWRefreshView> *)refreshHeaderView { return [[self.refreshHeader layouter] refreshView]; }
- (UIView<SWRefreshView> *)refreshFooterView { return [[self.refreshFooter layouter] refreshView]; }

@end
