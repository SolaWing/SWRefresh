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

@property (nonatomic, getter=isAnimating) BOOL animating;

@end

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
    _userInfo = [NSMutableDictionary new];
}

#pragma mark - API
- (void)beginRefreshing:(BOOL)animated {
    return [self beginRefreshing:animated source:SWRefreshSourceUserToken];
}

- (void)beginRefreshing:(BOOL)animated source:(id)source{
    self.beginRefreshingSource = source;
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
    return [self endRefreshingWithState:SWRefreshStateIdle animated:animated
                                 reason:SWRefreshEndRefreshSuccessToken];
}

- (void)endRefreshing:(BOOL)animated reason:(id)reason {
    return [self endRefreshingWithState:SWRefreshStateIdle animated:animated
                                 reason:SWRefreshEndRefreshSuccessToken];
}

- (void)endRefreshingWithState:(SWRefreshState)state animated:(BOOL)animated reason:(id)reason {
    __unsafe_unretained dispatch_block_t block = ^{
        self.state = state;
        self.pullingPercent = 0.0;
    };

    self.endRefreshingReason = reason;

    if (animated) {
        // when call -[UICollectionView reload] before endRefreshing,
        // reload will also animated and cause flicker.
        // so delay it
        self.animating = YES;
        id completeBlock = ^(BOOL finish){
            self.animating = NO;
        };
        if ([_scrollView isKindOfClass:[UICollectionView class]]) {
            dispatch_block_t strongBlock = [block copy];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01* NSEC_PER_SEC),
                dispatch_get_main_queue(), ^
            {
                [UIView animateWithDuration:self.endRefreshingAnimationDuration delay:0
                                    options:UIViewAnimationOptionBeginFromCurrentState
                                 animations:strongBlock completion:completeBlock];
            });
        } else {
            [UIView animateWithDuration:self.endRefreshingAnimationDuration delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:block completion:completeBlock];
        }
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
            [self unbindScrollView:_scrollView];
        }
        _scrollView = scrollView;
        if (_scrollView) {
            [self bindScrollView:_scrollView];
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

static char TempInsetKey;
- (void)setScrollViewTempInset:(UIEdgeInsets)inset {
    UIScrollView* scrollView = self.scrollView;
    if (scrollView) {
        id value = @YES;
        objc_setAssociatedObject(scrollView, &TempInsetKey, value, OBJC_ASSOCIATION_ASSIGN);
        scrollView.contentInset = inset;
        objc_setAssociatedObject(scrollView, &TempInsetKey, nil, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (BOOL)isSettingTempInset {
    UIScrollView* scrollView = self.scrollView;
    if (scrollView) {
        return objc_getAssociatedObject(scrollView, &TempInsetKey) != nil;
    }
    return NO;
}

#pragma mark - property
#define kAnimatingKey @"__animating"
- (BOOL)isAnimating {
    return [_userInfo[kAnimatingKey] boolValue];
}

- (void)setAnimating:(BOOL)animating {
    if (animating) {
        _userInfo[kAnimatingKey] = @YES;
    } else {
        [_userInfo removeObjectForKey:kAnimatingKey];
    }
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

#define kEndRefreshingAnimationDurationKey @"__endRefreshAnimationDuration"
- (NSTimeInterval)endRefreshingAnimationDuration {
    id duration = _userInfo[kEndRefreshingAnimationDurationKey];
    if (duration) { return [duration doubleValue]; }
    return 0.25; // default value
}

- (void)setEndRefreshingAnimationDuration:(NSTimeInterval)endRefreshingAnimationDuration {
    if (endRefreshingAnimationDuration == 0) {
        [_userInfo removeObjectForKey:kEndRefreshingAnimationDurationKey];
    } else {
        _userInfo[kEndRefreshingAnimationDurationKey] = @(endRefreshingAnimationDuration);
    }
}

#pragma mark - KVO
- (void)bindScrollView:(UIScrollView*)scrollView {
    _scrollViewOriginInsets = scrollView.contentInset;
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:options context:@"contentOffset"];
    [scrollView addObserver:self forKeyPath:@"contentInset" options:options context:@"contentInset"];
}

- (void)unbindScrollView:(UIScrollView*)scrollView {
    [scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [scrollView removeObserver:self forKeyPath:@"contentInset"];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString *,id> *)change context:(nullable void *)context {
    if (@"contentOffset" == context) {
        [self scrollViewContentOffsetDidChange:change];
    } else if (@"contentInset" == context) {
        // check if change temp inset
        if (![self isSettingTempInset]) {
            [self scrollViewContentInsetDidChange:change];
        }
    }
}

#pragma mark - Override方法
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {}
- (void)scrollViewContentInsetDidChange:(NSDictionary *)change {
    UIEdgeInsets inset = [change[NSKeyValueChangeNewKey] UIEdgeInsetsValue];
    self.scrollViewOriginInsets = inset;
}

- (void)changeFromState:(SWRefreshState)oldState to:(SWRefreshState)newState {}

@end
