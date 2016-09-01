//
//  SWRefreshViewModel.h
//  SWRefresh
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(UInt32, SWRefreshState) {
    /** 普通闲置状态 */
    SWRefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    SWRefreshStatePulling,
    /** 正在刷新中的状态 */
    SWRefreshStateRefreshing,
    /** 所有数据加载完毕，没有更多的数据了 */
    SWRefreshStateNoMoreData
};

@protocol SWRefreshViewModel <NSObject>

@required

/** 刷新状态 */
@property (nonatomic) SWRefreshState state;
/** 拉拽的百分比, 可能会大于1 */
@property (nonatomic) CGFloat pullingPercent;
/** 是否正在刷新 */
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
/** 是否有动画 */
@property (nonatomic) BOOL hasAnimation;

#define SWRefreshSourceUserToken nil
/** 进入刷新状态, source可用来区分触发刷新来源, 该值可以通过beginRefreshingSource得到 */
- (void)beginRefreshing:(nullable id)source animated:(BOOL)animated;

#define SWRefreshEndRefreshSuccessToken nil
/** 结束刷新状态并设置结束状态和原因 */
- (void)endRefreshing:(nullable id)reason state:(SWRefreshState)state animated:(BOOL)animated;

/** 重置为初始状态 */
- (void)reset;

- (nullable id)beginRefreshingSource;
- (nullable id)endRefreshingReason;


@optional
- (void)beginRefreshing;
/** 结束刷新状态, 默认原因 SWRefreshEndRefreshSuccessToken */
- (void)endRefreshing;
/** 结束刷新状态为NoMore, 默认原因 SWRefreshEndRefreshSuccessToken */
- (void)endRefreshingWithNoMoreData;

@end



@class SWRefreshViewModel;
typedef void(^SWRefreshingBlock)(__kindof SWRefreshViewModel* _Nonnull viewModel);


/** 封装 SWRefreshViewModel, 提供callback */
@interface SWRefreshViewModel : NSObject <SWRefreshViewModel>

#pragma mark 回调

/** 正在刷新的回调 */
@property (nonatomic, copy, nonnull) SWRefreshingBlock refreshingBlock;

/** 设置回调对象和回调方法 */
- (void)setRefreshingTarget:(nullable id)target refreshingAction:(nullable SEL)action;
@property (nonatomic, weak) id refreshTarget;
@property (nonatomic, assign, nullable) SEL refreshAction;

/** 直接执行设置的回调, 回调是在主线程执行 */
- (void)executeRefreshingCallback;

#pragma mark 状态

@property (nonatomic) SWRefreshState state;
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
@property (nonatomic) BOOL hasAnimation;
@property (nonatomic) CGFloat pullingPercent;

/** 进入刷新状态, 默认来源 SWRefreshSourceUserToken */
- (void)beginRefreshing;
- (void)beginRefreshing:(nullable id)source animated:(BOOL)animated;

/** 结束刷新状态, 默认原因 SWRefreshEndRefreshSuccessToken */
- (void)endRefreshing;
/** 结束刷新状态, 默认原因 SWRefreshEndRefreshSuccessToken, 结束状态NoMore */
- (void)endRefreshingWithNoMoreData;
/** 结束刷新状态并设置结束状态和原因 */
- (void)endRefreshing:(nullable id)reason state:(SWRefreshState)state animated:(BOOL)animated;

- (void)reset;

@property (nonatomic, strong) NSMutableDictionary* userInfo;
- (nullable id)beginRefreshingSource;
- (nullable id)endRefreshingReason;

@end

