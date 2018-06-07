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

+ (instancetype)newWithHeaderView:(UIView<SWRefreshView> *)headerView model:(SWRefreshHeaderViewModel *)model {
    SWRefreshHeaderController* ctrl = [self new];
    ctrl->_headerView = headerView;
    ctrl->_headerModel = model;
    return ctrl;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView != scrollView) {
        _scrollView = scrollView;

        self.headerModel.scrollView = _scrollView;
        if (_headerView) {
            [self layoutHeaderView];
        }
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
            [self layoutHeaderView];
        }
    }
}

- (void)layoutHeaderView {
    if (_scrollView) {
        _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_scrollView insertSubview:_headerView atIndex:0];
        [self updateHeaderViewFrame];
    } else {
        [_headerView removeFromSuperview];
    }
}

- (void)setHeaderOffset:(CGFloat)headerOffset {
    if (_headerOffset != headerOffset) {
        _headerOffset = headerOffset;
        if (_scrollView && _headerView) {
            [self updateHeaderViewFrame];
        }
    }
}

- (void)updateHeaderViewFrame {
    CGRect frame = _headerView.frame;
    frame.size.width = _scrollView.bounds.size.width;
    frame.origin.y = -frame.size.height - _headerOffset;
    frame.origin.x = 0;
    _headerView.frame = frame;
}


@end

@implementation SWRefreshFooterController

- (void)dealloc {
    self.footerModel = nil;
    self.scrollView = nil;
}

+ (instancetype)newWithFooterView:(UIView<SWRefreshView> *)footerView model:(SWRefreshFooterViewModel *)model {
    SWRefreshFooterController* ctrl = [self new];
    ctrl->_footerView = footerView;
    ctrl.footerModel = model;
    return ctrl;
}

- (instancetype)init {
    if (self = [super init]) {
        _footerVisibleThreshold = 200;
    }
    return self;
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

        if (_footerView) {
            [self layoutFooterView];
        }
        if (_footerModel) {
            _footerModel.scrollView = (_scrollView && [self isFooterVisible])?_scrollView:nil;
        }
    }
}

- (void)setFooterModel:(__kindof SWRefreshFooterViewModel *)footerModel {
    if (_footerModel != footerModel) {
        if (_footerModel) {
            _footerModel.scrollView = nil;
            [_footerModel removeObserver:self forKeyPath:@"state"];
        }
        _footerModel = footerModel;
        if (_footerModel) {
            _footerModel.scrollView = [self isFooterVisible]?_scrollView:nil;
            [_footerModel addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionOld context:@"state"];
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
            [self layoutFooterView];
        }
    }
}

- (void)layoutFooterView {
    if (_scrollView) {
        _footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_scrollView insertSubview:_footerView atIndex:0];
        [self updateFooterViewFrame];
        _footerView.hidden = ![self isFooterVisible];
    } else {
        [_footerView removeFromSuperview];
    }
}

- (void)setFooterOffset:(CGFloat)footerOffset {
    if (_footerOffset != footerOffset) {
        _footerOffset = footerOffset;
        [self updateFooterViewFrame];
    }
}

- (void)updateFooterViewFrame {
    if (_footerView && _scrollView) {
        CGRect frame = _footerView.frame;
        CGSize contentSize = _scrollView.contentSize;
        frame.size.width = contentSize.width;
        frame.origin.y = contentSize.height + _footerOffset;
        _footerView.frame = frame;
    }
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString *,id> *)change context:(nullable void *)context {
    if (@"contentSize" == context) {
        if (!CGSizeEqualToSize( [change[NSKeyValueChangeOldKey] CGSizeValue], _scrollView.contentSize )) {
            [self updateFooterViewFrame];
            [self updateFooterVisible];
        }
    } else if (@"state" == context) {
        SWRefreshState o = [change[NSKeyValueChangeOldKey] integerValue];
        SWRefreshState n = _footerModel.state;
        if (_hideWhenNoMore && o != n && (o == SWRefreshStateNoMoreData || n == SWRefreshStateNoMoreData) ) {
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
