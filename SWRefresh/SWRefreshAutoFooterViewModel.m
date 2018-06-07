//
//  SWRefreshAutoFooterViewModel.m
//  SWRefresh
//
//  Created by SolaWing on 16/1/3.
//  Copyright © 2016年 SW. All rights reserved.
//

#import "SWRefreshAutoFooterViewModel.h"

#define kAutoRefreshMinInterval 0.5
@implementation SWRefreshAutoFooterViewModel {
}

- (void)initialize {
    [super initialize];
    _refreshAutomatically = YES;
}

- (void)setRefreshThreshold:(CGFloat)refreshThreshold {
    [super setRefreshThreshold:refreshThreshold];
    // _refreshThreshold更大, 会造成回弹, 这种情况请用backFooterViewModel
    if (_refreshThreshold > _bottomInset) {
        self.bottomInset = _refreshThreshold;
    }
}

static inline void scrollViewChangeBottomInset(SWRefreshViewModel* model, UIScrollView* scrollView, CGFloat deltaBottomInset) {
    if (deltaBottomInset == 0) return;
    UIEdgeInsets inset = scrollView.contentInset;
    inset.bottom += deltaBottomInset;
    // SWRefreshViewModel inner should always use setScrollViewTempInset, to avoid
    // override scrollViewOriginInsets when already set a tempinset like top
    [model setScrollViewTempInset:inset];
}

- (void)setBottomInset:(CGFloat)bottomInset {
    if (bottomInset != _bottomInset) {
        if (self.weakScrollView) {
            scrollViewChangeBottomInset(self, self.scrollView, bottomInset - _bottomInset);
        }
        _bottomInset = bottomInset;
    }
}

- (void)bindScrollView:(UIScrollView *)scrollView {
    [super bindScrollView:scrollView];
    scrollViewChangeBottomInset(self, scrollView, _bottomInset);
}

- (void)unbindScrollView:(UIScrollView *)scrollView {
    [super unbindScrollView:scrollView];
    if (self.weakScrollView) {
        scrollViewChangeBottomInset(self, scrollView, -_bottomInset);
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    // use track, don't use drag.
    // drag became false lately, and may already bounces back, cause won't refreshing.
    // when slow drag, may no offset change when drag or tracking change.
    __unsafe_unretained bool(^canAutoRefresh)() = ^bool{
        return (_refreshAutomatically &&
                self.state != SWRefreshStateNoMoreData &&
                !self.scrollView.isTracking);
    };
    if ( [self isRefreshing] ) { return; }

    CGFloat pullingOffsetY = [self pullingOffsetY];
    CGFloat offsetY = self.scrollView.contentOffset.y;

    CGFloat pullingPercent = ^CGFloat{
        if (self.pullingLength > 0) { // 计算percent
            // 开始改变pullingPercent的位置
            CGFloat happendOffsetY = pullingOffsetY  - self.pullingLength;
            if (offsetY < happendOffsetY) {
                return 0;
            } else {
                return (offsetY - happendOffsetY) / self.pullingLength;
            }
        } else {
            return offsetY > pullingOffsetY ? 1 : 0;
        }
    }();
    if (self.pullingPercent != pullingPercent) {
        self.pullingPercent = pullingPercent;
    }

    if (pullingOffsetY < offsetY && canAutoRefresh()) {
        CGFloat bounceOffset = self.scrollView.contentSize.height
            + self.scrollView.contentInset.bottom - self.scrollView.frame.size.height;
        if (offsetY <= bounceOffset) {
            CGPoint oldP = [change[NSKeyValueChangeOldKey] CGPointValue];
            CGPoint newP = [change[NSKeyValueChangeNewKey] CGPointValue];
            if (oldP.y >= newP.y) { return; } // 往上划, 不触发
        }

        [self beginRefreshing:YES];
    }
}

- (void)changeFromState:(SWRefreshState)oldState to:(SWRefreshState)newState {
    if (oldState == SWRefreshStateRefreshing) {
        // 限制自动刷新频率, 可预防反复失败的情况
        if (_refreshAutomatically) {
            _refreshAutomatically = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kAutoRefreshMinInterval * NSEC_PER_SEC),
                dispatch_get_main_queue(), ^{
                    self->_refreshAutomatically = YES;
            });
        }
    }
}

- (CGFloat)pullingOffsetY {
    UIEdgeInsets inset = ^{
        if (@available(iOS 11.0, *)) {
            return self.scrollView.adjustedContentInset;
        } else {
            return self.scrollView.contentInset;
        }
    }();
    // 自动触发点在刚显示view, 加上偏移值
    CGFloat bounceOffset = self.scrollView.contentSize.height
        + inset.bottom - self.scrollView.frame.size.height;
    CGFloat offsetY = bounceOffset - _bottomInset + _refreshThreshold;
    CGFloat minOffset = -inset.top + fmax(_pullingLength, 20); // 最低触发点离原点有一定距离
    if (offsetY < minOffset) { return minOffset; }

    return offsetY;
}

@end
