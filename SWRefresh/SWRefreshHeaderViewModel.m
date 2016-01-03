//
//  SWRefreshHeaderViewModel.m
//  SWRefresh
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import "SWRefreshHeaderViewModel.h"

@implementation SWRefreshHeaderViewModel

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    CGPoint offset = self.scrollView.contentOffset;
    if (self.state == SWRefreshStateRefreshing) {
        // Keep header, inset 应该在 origin top inset 和 加上高度之前
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.top = -offset.y;
        if (inset.top < _scrollViewOriginInsets.top) { inset.top = _scrollViewOriginInsets.top; }
        else if (inset.top > _refreshThreshold + _scrollViewOriginInsets.top) {
            inset.top = _refreshThreshold + _scrollViewOriginInsets.top;
        }
        self.scrollView.contentInset = inset;
        return;
    }

    // inset可能改变
    _scrollViewOriginInsets = self.scrollView.contentInset;
    // 刚好出现offset
    CGFloat happendOffsetY = -_scrollViewOriginInsets.top;

    // 没达到临界点
    if ( happendOffsetY < offset.y ) return;

    CGFloat pullingPercent = (happendOffsetY - offset.y) / _refreshThreshold;

    if (self.scrollView.isDragging) {
        CGFloat pullingOffsetY = happendOffsetY - _refreshThreshold;
        self.pullingPercent = pullingPercent;

        if (self.state == SWRefreshStateIdle) {
            if (offset.y < pullingOffsetY) { self.state = SWRefreshStatePulling; }
        } else if (self.state == SWRefreshStatePulling) {
            if (offset.y > pullingOffsetY) { self.state = SWRefreshStateIdle; }
        }
    } else if (self.state == SWRefreshStatePulling) { // pulling状态下松开
        [self beginRefreshing:YES];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

- (void)changeFromState:(SWRefreshState)oldState to:(SWRefreshState)newState {
    NSAssert([NSThread isMainThread], @"should change state in main thread!");

    if (newState == SWRefreshStateIdle) {
        if (oldState == SWRefreshStateRefreshing) {
            // 恢复inset, 只更改top
            UIEdgeInsets inset = self.scrollView.contentInset;
            inset.top = _scrollViewOriginInsets.top;
            self.scrollView.contentInset = inset;
        }
    } else if (newState == SWRefreshStateRefreshing) {
        // 保持inset, 只更改top
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.top = _refreshThreshold + _scrollViewOriginInsets.top;
        self.scrollView.contentInset = inset;
    }
}

@end