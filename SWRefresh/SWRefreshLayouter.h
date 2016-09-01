//
//  SWRefreshLayouter.h
//  SWRefresh
//
//  Created by SolaWing on 16/8/30.
//  Copyright © 2016年 SW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWRefreshView.h"

#pragma mark - Protocol
/** 该类主要控制如何在ScrollView中放置RefreshView */
@protocol SWRefreshLayouter <NSObject>

@required
- (__kindof UIView<SWRefreshView>*)refreshView;
@property (nonatomic, assign) UIScrollView* scrollView;

@end

/** 该类直接把refreshView加作ScrollView的subview */
@interface SWRefreshHeaderLayouter : NSObject <SWRefreshLayouter>

@property (nonatomic, strong) __kindof UIView<SWRefreshView>* refreshView;
@property (nonatomic, assign) UIScrollView* scrollView;
@property (nonatomic) CGFloat offset; ///< insetTop for headerView, positive offset make headerView move to top

@end

/** 该类直接把refreshView加作ScrollView的subview */
@interface SWRefreshFooterLayouter : NSObject <SWRefreshLayouter>

@property (nonatomic, strong) __kindof UIView<SWRefreshView>* refreshView;
@property (nonatomic, assign) UIScrollView* scrollView;
@property (nonatomic) CGFloat offset; ///< insetBottom for footerView, positive offset make footerView move to bottom

@end
