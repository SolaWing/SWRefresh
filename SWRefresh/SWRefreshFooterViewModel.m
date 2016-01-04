//
//  SWRefreshFooterViewModel.m
//  SWRefresh
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import "SWRefreshFooterViewModel.h"

@implementation SWRefreshFooterViewModel

- (void)endRefreshingWithNoMoreData:(BOOL)animated {
    __unsafe_unretained dispatch_block_t block = ^{
        self.state = SWRefreshStateNoMoreData;
        self.pullingPercent = 0.0;
    };

    if (animated) {
        // when call -[UICollectionView reload] before endRefreshing,
        // reload will also animated and cause flicker.
        // so delay it
        if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
            dispatch_block_t strongBlock = [block copy];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01* NSEC_PER_SEC),
                dispatch_get_main_queue(), ^
            {
                [UIView animateWithDuration:0.25 delay:0
                                    options:UIViewAnimationOptionBeginFromCurrentState
                                 animations:strongBlock completion:nil];
            });
        } else {
            [UIView animateWithDuration:0.25 delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:block completion:nil];
        }
    } else {
        block();
    }
}

- (void)resetNoMoreData {
    if (self.state == SWRefreshStateNoMoreData) {
        self.state = SWRefreshStateIdle;
    }
}


@end
