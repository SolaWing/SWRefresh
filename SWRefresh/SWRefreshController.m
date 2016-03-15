//
//  SWRefreshController.m
//  SWRefresh
//
//  Created by SolaWing on 16/3/14.
//  Copyright © 2016年 SW. All rights reserved.
//

#import "SWRefreshController.h"

@implementation SWRefreshHeaderController

- (void)dealloc {
    self.scrollView = nil;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView != scrollView) {
        _scrollView = scrollView;

        self.headerModel.scrollView = _scrollView;
        [self layoutHeaderView];
    }
}

- (void)setHeaderModel:(__kindof SWRefreshHeaderViewModel *)headerModel {
    if (_headerModel != headerModel) {
        // bind scrollView
        if (_headerModel) {
            _headerModel.scrollView = nil;
        }
        _headerModel = headerModel;
        if (_headerModel) {
            _headerModel.scrollView = _scrollView;
        }
    }
}

- (void)setHeaderView:(__kindof UIView<SWRefreshView> *)headerView {
    if (headerView != _headerView) {
        if (_headerView) {
            [_headerView removeFromSuperview];
        }
        _headerView = headerView;
        if (_headerView) {
            _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [self layoutHeaderView];
        }
    }
}

- (void)layoutHeaderView {
    if (_scrollView) {
        [_scrollView insertSubview:_headerView atIndex:0];
        [self updateHeaderViewFrame];
    } else {
        [_headerView removeFromSuperview];
    }
}

- (void)setInsetTop:(CGFloat)insetTop {
    if (_insetTop != insetTop) {
        _insetTop = insetTop;
        [self updateHeaderViewFrame];
    }
}

- (void)updateHeaderViewFrame {
    if (_headerView && _scrollView) {
        CGRect frame = _headerView.frame;
        frame.size.width = _scrollView.bounds.size.width;
        frame.origin.y = -frame.size.height - _insetTop;
        frame.origin.x = 0;
        _headerView.frame = frame;
    }
}


@end

@implementation SWRefreshFooterController

- (void)dealloc {
    self.scrollView = nil;
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

        [self layoutFooterView];
        [self updateFooterVisible];
    }
}

- (void)setFooterModel:(__kindof SWRefreshFooterViewModel *)footerModel {
    if (_footerModel != footerModel) {
        if (_footerModel) {
            _footerModel.scrollView = nil;
        }
        _footerModel = footerModel;
        if (_footerModel) {
            if ([self isFooterVisible]) {
                _footerModel.scrollView = _scrollView;
            }
        }
    }
}

- (void)setFooterView:(__kindof UIView<SWRefreshView> *)footerView {
    if (footerView != _footerView) {
        if (_footerView) {
            [_footerView removeFromSuperview];
        }
        _footerView = footerView;
        if (_footerView) {
            _footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [self layoutFooterView];
        }
    }
}

- (void)layoutFooterView {
    if (_scrollView) {
        [_scrollView insertSubview:_footerView atIndex:0];
        [self updateFooterViewFrame];
        _footerView.hidden = ![self isFooterVisible];
    } else {
        [_footerView removeFromSuperview];
    }
}

- (void)setInsetBottom:(CGFloat)insetBottom {
    if (_insetBottom != insetBottom) {
        _insetBottom = insetBottom;
        [self updateFooterViewFrame];
    }
}

- (void)updateFooterViewFrame {
    if (_footerView && _scrollView) {
        CGRect frame = _footerView.frame;
        CGSize contentSize = _scrollView.contentSize;
        frame.size.width = contentSize.width;
        frame.origin.y = contentSize.height + _insetBottom;
        _footerView.frame = frame;
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
    _footerModel.scrollView = isFooterVisible?_scrollView:nil;
    _footerView.hidden = !isFooterVisible;
}

- (BOOL)isFooterVisible {
    return _scrollView.contentSize.height > _footerVisibleThreshold
        && (!_hideWhenNoMore || _footerModel.state != SWRefreshStateNoMoreData);
}


@end
