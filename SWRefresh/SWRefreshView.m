//
//  SWRefreshView.m
//  SWRefresh
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import "SWRefreshView.h"
#import "SWRefreshController.h"
#import "SWRefreshHeaderViewModel.h"
#import "SWRefreshBackFooterViewModel.h"

@implementation SWRefreshView

- (void)dealloc {
    self.sourceViewModel = nil;
}

+ (Class)defaultHeaderViewModelClass { return [SWRefreshHeaderViewModel class]; }
+ (Class)defaultFooterViewModelClass { return [SWRefreshBackFooterViewModel class]; }
+ (Class)defaultHeaderControllerClass { return [SWRefreshHeaderController class]; }
+ (Class)defaultFooterControllerClass { return [SWRefreshFooterController class]; }

+ (instancetype)newHeaderRefreshingBlock:(SWRefreshingBlock)block {
    SWRefreshView* headerView = [self new];

    SWRefreshHeaderViewModel* headerModel = [[self defaultHeaderViewModelClass] new];
    headerModel.refreshThreshold = headerView.frame.size.height;
    headerModel.refreshingBlock = block;
    headerView.sourceViewModel = headerModel;

    return headerView;
}

+ (instancetype)newHeaderRefreshingTarget:(id)target action:(SEL)action {
    SWRefreshView* headerView = [self new];

    SWRefreshHeaderViewModel* headerModel = [[self defaultHeaderViewModelClass] new];
    headerModel.refreshThreshold = headerView.frame.size.height;
    headerModel.refreshTarget = target;
    headerModel.refreshAction = action;
    headerView.sourceViewModel = headerModel;

    return headerView;
}

+ (instancetype)newFooterRefreshingBlock:(SWRefreshingBlock)block {
    SWRefreshView* footerView = [self new];

    SWRefreshFooterViewModel* footerModel = [[self defaultFooterViewModelClass] new];
    footerModel.refreshThreshold = footerView.frame.size.height;
    footerModel.refreshingBlock = block;
    footerView.sourceViewModel = footerModel;

    return footerView;
}

+ (instancetype)newFooterRefreshingTarget:(id)target action:(SEL)action {
    SWRefreshView* footerView = [self new];

    SWRefreshFooterViewModel* footerModel = [[self defaultFooterViewModelClass] new];
    footerModel.refreshThreshold = footerView.frame.size.height;
    footerModel.refreshTarget = target;
    footerModel.refreshAction = action;
    footerView.sourceViewModel = footerModel;

    return footerView;
}

+ (id<SWRefreshHeaderController>)headerWithRefreshingBlock:(SWRefreshingBlock)block {
    SWRefreshView* view = [self newHeaderRefreshingBlock:block];
    return [[self defaultHeaderControllerClass]
        newWithHeaderView:view model:(id)view.sourceViewModel];
}

+ (id<SWRefreshHeaderController>)headerWithRefreshingTarget:(id)target action:(SEL)action {
    SWRefreshView* view = [self newHeaderRefreshingTarget:target action:action];
    return [[self defaultHeaderControllerClass]
        newWithHeaderView:view model:(id)view.sourceViewModel];
}

+ (id<SWRefreshFooterController>)footerWithRefreshingBlock:(SWRefreshingBlock)block {
    SWRefreshView* view = [self newFooterRefreshingBlock:block];
    return [[self defaultFooterControllerClass]
        newWithFooterView:view model:(id)view.sourceViewModel];
}

+ (id<SWRefreshFooterController>)footerWithRefreshingTarget:(id)target action:(SEL)action {
    SWRefreshView* view = [self newFooterRefreshingTarget:target action:action];
    return [[self defaultFooterControllerClass]
        newWithFooterView:view model:(id)view.sourceViewModel];
}


- (void)setSourceViewModel:(SWRefreshViewModel *)sourceViewModel {
    if (_sourceViewModel != sourceViewModel) {
        if (_sourceViewModel) {
            [self unbindSourceViewModel:_sourceViewModel];
        }
        _sourceViewModel = sourceViewModel;
        if (_sourceViewModel) {
            [self bindSourceViewModel:_sourceViewModel];
        }
    }
}

- (void)bindSourceViewModel:(SWRefreshViewModel *)sourceViewModel {
    [sourceViewModel addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:@"state"];
    [sourceViewModel addObserver:self forKeyPath:@"pullingPercent" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:@"pullingPercent"];
}

- (void)unbindSourceViewModel:(SWRefreshViewModel *)sourceViewModel {
    [sourceViewModel removeObserver:self forKeyPath:@"state"];
    [sourceViewModel removeObserver:self forKeyPath:@"pullingPercent"];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString *,id> *)change context:(nullable void *)context {
    if (context == @"state") {
        SWRefreshState old = [change[NSKeyValueChangeOldKey] integerValue];
        SWRefreshState new = [change[NSKeyValueChangeNewKey] integerValue];
        if (old != new) { [self changeFromState:old to:new]; }
    } else if (context == @"pullingPercent") {
        CGFloat pullingPercent = [change[NSKeyValueChangeNewKey] floatValue];
        [self changePullingPercent:pullingPercent];
    }
}

- (void)changePullingPercent:(CGFloat)pullingPercent {}
- (void)changeFromState:(SWRefreshState)oldState to:(SWRefreshState)newState {}

@end
