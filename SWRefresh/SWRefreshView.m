//
//  SWRefreshView.m
//  SWRefresh
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import "SWRefreshView.h"

@implementation SWRefreshView

- (void)dealloc {
    self.sourceViewModel = nil;
}

- (void)setSourceViewModel:(SWRefreshViewModel *)sourceViewModel {
    if (_sourceViewModel != sourceViewModel) {
        if (_sourceViewModel) {
            [_sourceViewModel removeObserver:self forKeyPath:@"state"];
            [_sourceViewModel removeObserver:self forKeyPath:@"pullingPercent"];
        }
        _sourceViewModel = sourceViewModel;
        if (_sourceViewModel) {
            [_sourceViewModel addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:@"state"];
            [_sourceViewModel addObserver:self forKeyPath:@"pullingPercent" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:@"pullingPercent"];
        }
    }
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString *,id> *)change context:(nullable void *)context {
    if (context == @"state") {
        SWRefreshState old = [change[NSKeyValueChangeOldKey] integerValue];
        SWRefreshState new = [change[NSKeyValueChangeNewKey] integerValue];
        if (old != new) { [self changeFromState:old to:new]; }
    } else if (context == @"pullingPercent") {
        CGFloat pullingPercent = [change[NSKeyValueChangeNewKey] floatValue];
        [self changePullingPercent:pullingPercent];
    }
}

- (void)changePullingPercent:(CGFloat)pullingPercent {}
- (void)changeFromState:(SWRefreshState)oldState to:(SWRefreshState)newState {}

@end
