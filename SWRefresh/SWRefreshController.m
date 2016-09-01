//
//  SWRefreshViewController.m
//  SWRefresh
//
//  Created by SolaWing on 16/8/25.
//  Copyright © 2016年 SW. All rights reserved.
//

#import "SWRefreshController.h"
#import <objc/runtime.h>

@implementation SWRefreshController

-(void)dealloc {
    self.scrollView = nil;
    self.model = nil;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {

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

- (void)setModel:(id<SWRefreshViewModel>)model {
    if (model != _model) {
        if (_model) {
            [(NSObject*)_model removeObserver:self forKeyPath:@"state"];
        }
        _model = model;
        if (_model) {
            [(NSObject*)_model addObserver:self forKeyPath:@"state"
                                   options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                                   context:@"state"];
        }
    }
}

// - (void)setLayouter:(id<SWRefreshLayouter>)layouter {
//     if (layouter != _layouter) {
//         if (_layouter) {
//             [_layouter setScrollView:nil];
//             [_layouter refreshView].sourceViewModel = nil;
//         }
//         _layouter = layouter;
//         if (_layouter) {
//             [_layouter setScrollView:_scrollView];
//             [_layouter refreshView].sourceViewModel = _model;
//         }
//     }
// }

static char TempInsetKey;
- (void)setScrollViewTempInset:(UIEdgeInsets)inset {
    UIScrollView* scrollView = self.scrollView;
    if (scrollView) {
        if ([self isSettingTempInset]) {
            // sometimes KVO change inset
            scrollView.contentInset = inset;
        } else {
            id value = @YES;
            objc_setAssociatedObject(scrollView, &TempInsetKey, value, OBJC_ASSOCIATION_ASSIGN);
            scrollView.contentInset = inset;
            objc_setAssociatedObject(scrollView, &TempInsetKey, nil, OBJC_ASSOCIATION_ASSIGN);
        }
    }
}

- (BOOL)isSettingTempInset {
    UIScrollView* scrollView = self.scrollView;
    if (scrollView) {
        return objc_getAssociatedObject(scrollView, &TempInsetKey) != nil;
    }
    return NO;
}

+ (CGFloat)animationDuration { return 0.25; }

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
    } else if (@"state" == context) {
        SWRefreshState o = [change[NSKeyValueChangeOldKey] integerValue];
        SWRefreshState n = [change[NSKeyValueChangeNewKey] integerValue];
        if (o != n) {
            if (self.model.hasAnimation) {
                // when call -[UICollectionView reload] before endRefreshing,
                // reload will also animated and cause flicker.
                // may caused by update view's property. so delay it
                if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:[self.class animationDuration] delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
                            [self changeFromState:o to:n];
                        } completion:nil];
                    });
                } else {
                    [UIView animateWithDuration:[self.class animationDuration] delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
                        [self changeFromState:o to:n];
                    } completion:nil];
                }
            } else {
                [self changeFromState:o to:n];
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
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
