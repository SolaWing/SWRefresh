//
//  SWRefreshAutoFooterViewModel.m
//  SWRefresh
//
//  Created by SolaWing on 16/1/3.
//  Copyright © 2016年 SW. All rights reserved.
//

#import "SWRefreshAutoFooterViewModel.h"

@implementation SWRefreshAutoFooterViewModel

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

- (void)setBottomInset:(CGFloat)bottomInset {
    if (bottomInset != _bottomInset) {
        if (self.scrollView) {
            UIEdgeInsets inset = self.scrollView.contentInset;
            CGFloat delta = bottomInset - _bottomInset;
            inset.bottom += delta;
            self.scrollView.contentInset = inset;
        }
        _bottomInset = bottomInset;
    }
}

- (void)bindScrollView:(UIScrollView *)scrollView {
    [super bindScrollView:scrollView];
    UIEdgeInsets inset = scrollView.contentInset;
    inset.bottom += _bottomInset;
    scrollView.contentInset = inset;
}

- (void)unbindScrollView:(UIScrollView *)scrollView {
    [super unbindScrollView:scrollView];
    UIEdgeInsets inset = scrollView.contentInset;
    inset.bottom -= _bottomInset;
    scrollView.contentInset = inset;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    if (self.state != SWRefreshStateIdle || !_refreshAutomatically) { return; }

    CGFloat happendOffsetY = [self happendOffsetY];
    CGFloat offsetY = self.scrollView.contentOffset.y;

    if (happendOffsetY < offsetY) {
        CGPoint oldP = [change[NSKeyValueChangeOldKey] CGPointValue];
        CGPoint newP = [change[NSKeyValueChangeNewKey] CGPointValue];
        if (oldP.y > newP.y) { return; } // 往上划, 不触发

        [self beginRefreshing:NO];
    }
}

- (CGFloat)happendOffsetY {
    UIEdgeInsets inset = self.scrollView.contentInset;
    CGFloat offsetY = self.scrollView.contentSize.height + inset.bottom - _bottomInset
        - self.scrollView.frame.size.height + _refreshThreshold;
    CGFloat minOffset = -inset.top + _bottomInset; // 最低触发点离原点有一定距离
    if (offsetY < minOffset) { return minOffset; }

    return offsetY;
}

@end
