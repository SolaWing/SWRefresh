//
//  SWRefreshBackFooterViewModel.m
//  SWRefresh
//
//  Created by SolaWing on 16/1/3.
//  Copyright © 2016年 SW. All rights reserved.
//

#import "SWRefreshBackFooterViewModel.h"

@implementation SWRefreshBackFooterViewModel

- (void)unbindScrollView:(UIScrollView *)scrollView {
    [super unbindScrollView:scrollView];
    if (self.state == SWRefreshStateRefreshing) {
        self.state = SWRefreshStateIdle;
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    CGPoint offset = self.scrollView.contentOffset;
    if (self.state == SWRefreshStateRefreshing) {
        if ( self.scrollView.dragging ) {
            // Keep footer, inset 应该在 origin bottom inset 和 加上高度之前
            CGFloat happendOffsetY = [self happendOffsetY];
            CGFloat extendOffset = offset.y - happendOffsetY;
            if (extendOffset < 0) { extendOffset = 0; }
            else if (extendOffset > _refreshThreshold) { extendOffset = _refreshThreshold; }

            UIEdgeInsets inset = self.scrollView.contentInset;
            inset.bottom = extendOffset + self.scrollViewOriginInsets.bottom;
            [self setScrollViewTempInset:inset];
        }
        return;
    }

    // inset可能改变
    // _scrollViewOriginInsets = self.scrollView.contentInset;
    // 刚好出现offset
    CGFloat happendOffsetY = [self happendOffsetY];

    // 没达到临界点
    if ( happendOffsetY > offset.y ) return;

    CGFloat pullingPercent = (offset.y - happendOffsetY) / _refreshThreshold;

    if (self.scrollView.isDragging && self.state != SWRefreshStateNoMoreData) {
        CGFloat pullingOffsetY = happendOffsetY + _refreshThreshold;
        self.pullingPercent = pullingPercent;

        if (self.state == SWRefreshStateIdle) {
            if (offset.y > pullingOffsetY) { self.state = SWRefreshStatePulling; }
        } else if (self.state == SWRefreshStatePulling) {
            if (offset.y < pullingOffsetY) { self.state = SWRefreshStateIdle; }
        }
    } else if (self.state == SWRefreshStatePulling) { // pulling状态下松开
        [self beginRefreshing:YES];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

- (void)changeFromState:(SWRefreshState)oldState to:(SWRefreshState)newState {
    NSAssert([NSThread isMainThread], @"should change state in main thread!");

    if (oldState == SWRefreshStateRefreshing) {
        // 恢复inset, 只更改bottom
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.bottom = self.scrollViewOriginInsets.bottom;
        [self setScrollViewTempInset:inset];
    } else if (newState == SWRefreshStateRefreshing) {
        // 保持inset, 只更改bottom
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.bottom = _refreshThreshold + self.scrollViewOriginInsets.bottom;
        [self setScrollViewTempInset:inset];
    }
}

- (CGFloat)happendOffsetY {
    UIEdgeInsets _scrollViewOriginInsets = self.scrollViewOriginInsets;
    CGFloat offsetY = self.scrollView.contentSize.height + _scrollViewOriginInsets.bottom - self.scrollView.frame.size.height;
    /** the two insetTop may different */
    CGFloat minOffset = -fmin( _scrollViewOriginInsets.top, self.scrollView.contentInset.top );
    if (offsetY < minOffset) { return minOffset; }

    return offsetY;
}

@end
