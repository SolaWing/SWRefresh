//
//  SWRefreshFooterViewModel.h
//  SWRefresh
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import "SWRefreshViewModel.h"

@interface SWRefreshFooterViewModel : SWRefreshViewModel

@property (nonatomic, assign) CGFloat refreshThreshold; ///< amout scrollView need to beyond

/** 结束刷新状态 */
- (void)endRefreshingWithNoMoreData:(BOOL)animated;
- (void)resetNoMoreData;

@end
