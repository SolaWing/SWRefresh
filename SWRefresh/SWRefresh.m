//
//  SWRefresh.m
//  SWRefresh
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import "SWRefresh.h"

@implementation SWRefresh

- (void)dealloc {
    // release bind scrollView when deallocing
    self.header = nil;
    self.footer = nil;
    self.scrollView = nil;
}

- (instancetype)init {
    if (self = [super init]) {
        _footerVisibleThreshold = 200;
    }
    return self;
}

#pragma mark - property
- (void)setHeader:(SWRefreshHeaderViewModel *)header {
    if (_header != header) {
        // bind scrollView
        if (_header) {
            _header.scrollView = nil;
        }
        _header = header;
        if (_header) {
            _header.scrollView = _scrollView;
        }
    }
}

- (void)setFooter:(SWRefreshFooterViewModel *)footer {
    if (_footer != footer) {
        if (_footer) {
            _footer.scrollView = nil;
        }
        _footer = footer;
        if (_footer) {
            if ([self isFooterVisible]) {
                _footer.scrollView = _scrollView;
            }
        }
    }
}

- (void)setHeaderView:(UIView<SWRefreshView> *)headerView {
    if (headerView != _headerView) {
        if (_headerView) {
            [_headerView removeFromSuperview];
        }
        _headerView = headerView;
        if (_headerView) {
            _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [_scrollView insertSubview:_headerView atIndex:0];
            [self updateHeaderViewFrame];
        }
    }
}

- (void)setFooterView:(UIView<SWRefreshView> *)footerView {
    if (footerView != _footerView) {
        if (_footerView) {
            [_footerView removeFromSuperview];
        }
        _footerView = footerView;
        if (_footerView) {
            [_scrollView insertSubview:footerView atIndex:0];
            [self updateFooterViewFrame];
            _footerView.hidden = ![self isFooterVisible];
        }
    }
}

- (void)setInsetTop:(CGFloat)insetTop {
    if (_insetTop != insetTop) {
        _insetTop = insetTop;
        [self updateHeaderViewFrame];
    }
}

- (void)setInsetBottom:(CGFloat)insetBottom {
    if (_insetBottom != insetBottom) {
        _insetBottom = insetBottom;
        [self updateFooterViewFrame];
    }
}

- (void)updateHeaderViewFrame {
    if (_headerView) {
        CGRect frame = _headerView.frame;
        frame.size.width = _scrollView.bounds.size.width;
        frame.origin.y = -frame.size.height - _insetTop;
        frame.origin.x = 0;
        _headerView.frame = frame;
    }
}

- (void)updateFooterViewFrame {
    if (_footerView) {
        CGRect frame = _footerView.frame;
        CGSize contentSize = _scrollView.contentSize;
        frame.size.width = contentSize.width;
        frame.origin.y = contentSize.height + _insetBottom;
        _footerView.frame = frame;
    }
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView != scrollView) {
        if (_scrollView) {
            [_scrollView removeObserver:self forKeyPath:@"contentSize"];
        }
        _scrollView = scrollView;
        if (_scrollView) {
            [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld context:@"contentSize"];
        }
    }
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString *,id> *)change context:(nullable void *)context {
    if (@"contentSize" == context) {
        if (!CGSizeEqualToSize( [change[NSKeyValueChangeOldKey] CGSizeValue], _scrollView.contentSize )) {
            [self updateFooterViewFrame];
            [self updateFooterVisible];
        }
    }
}

- (void)setFooterVisibleThreshold:(CGFloat)footerVisibleThreshold {
    if (footerVisibleThreshold != _footerVisibleThreshold) {
        _footerVisibleThreshold = footerVisibleThreshold;
        [self updateFooterVisible];
    }
}

- (void)updateFooterVisible {
    BOOL isFooterVisible = [self isFooterVisible];
    _footer.scrollView = isFooterVisible?_scrollView:nil;
    _footerView.hidden = !isFooterVisible;
}

- (BOOL)isFooterVisible {
    return _scrollView.contentSize.height > _footerVisibleThreshold
        && (!_hideWhenNoMore || _footer.state != SWRefreshStateNoMoreData);
}

@end
