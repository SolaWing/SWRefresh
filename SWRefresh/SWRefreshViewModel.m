//
//  SWRefreshViewModel.m
//  SWRefresh
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import "SWRefreshViewModel.h"

@implementation SWRefreshViewModel

-(void)dealloc {
    self.scrollView = nil;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _state = SWRefreshStateIdle;
}

#pragma mark - API
- (void)beginRefreshing:(BOOL)animated {
    __unsafe_unretained dispatch_block_t block = ^{
        self.pullingPercent = 1.0;
        if (self.state != SWRefreshStateRefreshing) {
            self.state = SWRefreshStateRefreshing;
            [self executeRefreshingCallback];
        }
    };
    if (animated) {
        [UIView animateWithDuration:0.25 animations:block];
    } else {
        block();
    }
}

- (void)endRefreshing:(BOOL)animated {
    __unsafe_unretained dispatch_block_t block = ^{
        self.state = SWRefreshStateIdle;
        self.pullingPercent = 0.0;
    };

    if (animated) {
        [UIView animateWithDuration:0.25 animations:block];
    } else {
        block();
    }
}

- (BOOL)isRefreshing {
    return self.state == SWRefreshStateRefreshing;
}

- (void)executeRefreshingCallback {
    __unsafe_unretained dispatch_block_t block = ^{
        if (self.refreshingBlock) { self.refreshingBlock(); }
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

- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action {
    self.refreshTarget = target;
    self.refreshAction = action;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (scrollView != _scrollView) {
        if (_scrollView) {
            [self removeScrollViewObservers:_scrollView];
        }
        _scrollView = scrollView;
        if (_scrollView) {
            [self addScrollViewObservers:_scrollView];
        }
    }
}

- (void)setState:(SWRefreshState)state {
    SWRefreshState old = self.state;
    if (state == old) { return; }
    _state = state;

    // do additional state change work
    [self changeFromState:old to:state];
}

#pragma mark - KVO

- (void)addScrollViewObservers:(UIScrollView*)scrollView {
    _scrollViewOriginInsets = scrollView.contentInset;
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:options context:@"contentOffset"];
}

- (void)removeScrollViewObservers:(UIScrollView*)scrollView {
    [scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString *,id> *)change context:(nullable void *)context {
    if (@"contentOffset" == context) {
        [self scrollViewContentOffsetDidChange:change];
    }
}

#pragma mark - Override方法
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {}
- (void)changeFromState:(SWRefreshState)oldState to:(SWRefreshState)newState {}

@end
