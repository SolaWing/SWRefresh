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
    return [self endRefreshingWithState:SWRefreshStateNoMoreData animated:animated
                                 reason:SWRefreshEndRefreshSuccessToken];
}

- (void)resetNoMoreData {
    if (self.state == SWRefreshStateNoMoreData) {
        self.state = SWRefreshStateIdle;
    }
}


@end
