//
//  SWRefreshViewModel.m
//  SWRefresh
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import "SWRefreshViewModel.h"
#import <objc/runtime.h>

@interface SWRefreshViewModel ()

@end

@implementation SWRefreshViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _state = SWRefreshStateIdle;
    _userInfo = [NSMutableDictionary new];
}

#pragma mark - API
- (void)beginRefreshing {
    [self beginRefreshing:SWRefreshSourceUserToken animated:YES];
}

- (void)beginRefreshing:(id)source animated:(BOOL)animated {
    self.beginRefreshingSource = source;
    if (self.state != SWRefreshStateRefreshing) {
        // temp update hasAnimation
        BOOL hasAnimation = _hasAnimation;
        _hasAnimation = animated;
        {
            self.pullingPercent = 1.0;
            self.state = SWRefreshStateRefreshing;
            [self executeRefreshingCallback];
        }
        _hasAnimation = hasAnimation;
    }
}

- (void)endRefreshing { [self endRefreshing:SWRefreshEndRefreshSuccessToken state:SWRefreshStateIdle animated:YES]; }
- (void)endRefreshingWithNoMoreData { [self endRefreshing:SWRefreshEndRefreshSuccessToken state:SWRefreshStateNoMoreData animated:YES]; }
- (void)endRefreshing:(id)reason state:(SWRefreshState)state animated:(BOOL)animated {
    self.endRefreshingReason = reason;

    // temp update hasAnimation
    BOOL hasAnimation = _hasAnimation;
    _hasAnimation = animated;
    {
        self.pullingPercent = 0.0;
        self.state = state;
    }
    _hasAnimation = hasAnimation;
}

- (void)reset {
    if ([self isRefreshing]) { [self endRefreshing]; }
    else { _state = SWRefreshStateIdle; }
}

- (void)executeRefreshingCallback {
    __unsafe_unretained dispatch_block_t block = ^{
        if (self.refreshingBlock) { self.refreshingBlock(self); }
        id target = self.refreshTarget;
        if ([target respondsToSelector:self.refreshAction]) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:self.refreshAction withObject:self];
            #pragma clang diagnostic pop
        }
    };

    if ([NSThread isMainThread]) { block(); }
    else { dispatch_async(dispatch_get_main_queue(), block); }
}

#pragma mark - property
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action {
    self.refreshTarget = target;
    self.refreshAction = action;
}

- (BOOL)isRefreshing {
    return self.state == SWRefreshStateRefreshing;
}

#define kBeginRefreshSourceKey @"__BeginRefreshSource"
- (id)beginRefreshingSource {
    return _userInfo[kBeginRefreshSourceKey];
}

- (void)setBeginRefreshingSource:(id)beginRefreshingSource {
    if (nil == beginRefreshingSource) {
        [_userInfo removeObjectForKey:kBeginRefreshSourceKey];
    } else {
        _userInfo[kBeginRefreshSourceKey] = beginRefreshingSource;
    }
}

#define kEndRefreshReasonKey @"__endRefreshReason"
- (id)endRefreshingReason {
    return _userInfo[kEndRefreshReasonKey];
}

- (void)setEndRefreshingReason:(id)endRefreshingReason {
    if (nil == endRefreshingReason) {
        [_userInfo removeObjectForKey:kEndRefreshReasonKey];
    } else {
        _userInfo[kEndRefreshReasonKey] = endRefreshingReason;
    }
}

@end
