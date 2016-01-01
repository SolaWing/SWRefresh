//
//  UIScrollView+SWRefresh.m
//  SWRefresh
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import "UIScrollView+SWRefresh.h"
#import <objc/runtime.h>

#define DefaultHeaderViewModel SWRefreshHeaderViewModel
#define DefaultFooterViewModel SWRefreshFooterViewModel

@implementation UIScrollView (SWRefresh)

static char refreshControlKey;
- (SWRefresh *)refreshControl {
    SWRefresh* ret = objc_getAssociatedObject(self, &refreshControlKey);
    if (!ret) { // 没有时自动创建一个
        ret = [SWRefresh new]; ret.scrollView = self;
        [self setRefreshControl:ret];
    }
    return ret;
}

- (void)setRefreshControl:(SWRefresh *)refreshControl {
    objc_setAssociatedObject(self, &refreshControlKey, refreshControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SWRefreshHeaderViewModel *)refreshHeader {
    return self.refreshControl.header;
}

- (void)setRefreshHeader:(SWRefreshHeaderViewModel *)refreshHeader {
    self.refreshControl.header = refreshHeader;
}

- (SWRefreshFooterViewModel *)refreshFooter {
    return self.refreshControl.footer;
}

- (void)setRefreshFooter:(SWRefreshFooterViewModel *)refreshFooter {
    self.refreshControl.footer = refreshFooter;
}


static Class headerViewClass, headerViewModelClass, footerViewClass, footerViewModelClass;
+ (void)registerDefaultHeaderView:(Class)headerViewClass_ andModel:(Class)modelViewClass_ {
    headerViewClass = headerViewClass_;
    headerViewModelClass = modelViewClass_;
}

+ (void)registerDefaultFooterView:(Class)footerViewClass_ andModel:(Class)modelViewClass_ {
    footerViewClass = footerViewClass_;
    footerViewModelClass = modelViewClass_;
}

- (void)refreshHeader:(dispatch_block_t)callback {
    UIView<SWRefreshView>* headerView = [headerViewClass new];
    SWRefreshHeaderViewModel* headerModel = [headerViewModelClass new];
    headerModel.refreshThreshold = headerView.frame.size.height;
    headerView.sourceViewModel = headerModel;

    headerModel.refreshingBlock = callback;
    [self setRefreshHeaderView:headerView];

}

- (void)refreshFooter:(dispatch_block_t)callback {
    UIView<SWRefreshView>* footerView = [footerViewClass new];
    SWRefreshFooterViewModel* footerModel = [footerViewModelClass new];
    footerModel.refreshThreshold = footerView.frame.size.height;
    footerView.sourceViewModel = footerModel;

    footerModel.refreshingBlock = callback;
    [self setRefreshFooterView:footerView];

}

- (void)refreshHeaderTarget:(id)target action:(SEL)action {
    UIView<SWRefreshView>* headerView = [headerViewClass new];
    SWRefreshHeaderViewModel* headerModel = [headerViewModelClass new];
    headerModel.refreshThreshold = headerView.frame.size.height;
    headerView.sourceViewModel = headerModel;

    [headerModel setRefreshingTarget:target refreshingAction:action];
    [self setRefreshHeaderView:headerView];
}

- (void)refreshFooterTarget:(id)target action:(SEL)action {
    UIView<SWRefreshView>* footerView = [footerViewClass new];
    SWRefreshFooterViewModel* footerModel = [footerViewModelClass new];
    footerModel.refreshThreshold = footerView.frame.size.height;
    footerView.sourceViewModel = footerModel;

    [footerModel setRefreshingTarget:target refreshingAction:action];
    [self setRefreshFooterView:footerView];
}

- (void)setRefreshHeaderView:(UIView<SWRefreshView>*)headerView {
    self.refreshControl.headerView = headerView;
    self.refreshHeader = (id)headerView.sourceViewModel;
}

- (void)setRefreshFooterView:(UIView<SWRefreshView>*)footerView {
    self.refreshControl.footerView = footerView;
    self.refreshFooter = (id)footerView.sourceViewModel;
}

- (UIView<SWRefreshView> *)refreshHeaderView { return self.refreshControl.headerView; }
- (UIView<SWRefreshView> *)refreshFooterView { return self.refreshControl.footerView; }
@end
