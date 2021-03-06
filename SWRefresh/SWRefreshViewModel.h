//
//  SWRefreshViewModel.h
//  SWRefresh
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SWRefreshState) {
    /** 普通闲置状态 */
    SWRefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    SWRefreshStatePulling,
    /** 正在刷新中的状态 */
    SWRefreshStateRefreshing,
    /** 所有数据加载完毕，没有更多的数据了 */
    SWRefreshStateNoMoreData

};

@class SWRefreshViewModel;
typedef void(^SWRefreshingBlock)(__kindof SWRefreshViewModel* _Nonnull viewModel);

/** Refresh基类, 不要直接使用.
 * 该类用来管理刷新状态和ScrollView相关刷新状态
 * 并做为相应View的数据源 */
@interface SWRefreshViewModel : NSObject

/** 使用assign确保deallocing时, scrollView仍然有效 */
@property (nonatomic, assign, nullable) UIScrollView* scrollView;
@property (nonatomic, weak, nullable, readonly) UIScrollView* weakScrollView;
@property (nonatomic, assign) UIEdgeInsets scrollViewOriginInsets;

#pragma mark 回调
/** 正在刷新的回调 */
@property (nonatomic, copy, nonnull) SWRefreshingBlock refreshingBlock;
/** 设置回调对象和回调方法 */
- (void)setRefreshingTarget:(nullable id)target refreshingAction:(nullable SEL)action;
@property (nonatomic, weak) id refreshTarget;
@property (nonatomic, assign, nullable) SEL refreshAction;
- (void)executeRefreshingCallback;

#pragma mark 状态

/** 进入刷新状态, 默认来源 SWRefreshSourceUserToken */
- (void)beginRefreshing:(BOOL)animated;
#define SWRefreshSourceUserToken nil
/** 进入刷新状态, source可用来区分触发刷新来源, 该值可以通过beginRefreshingSource得到 */
- (void)beginRefreshing:(BOOL)animated source:(nullable id)source;

/** 结束刷新状态, 默认原因 SWRefreshEndRefreshSuccessToken. */
- (void)endRefreshing:(BOOL)animated;
#define SWRefreshEndRefreshSuccessToken nil
/** 结束刷新状态并设置结束原因, reason可通过endRefreshingReason得到 */
- (void)endRefreshing:(BOOL)animated reason:(nullable id)reason;
/** 结束刷新状态并设置结束状态和原因 */
- (void)endRefreshingWithState:(SWRefreshState)state animated:(BOOL)animated reason:(nullable id)reason;

/** 是否正在刷新 */
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
/** 刷新状态 */
@property (nonatomic) SWRefreshState state;

/** 拉拽的百分比, 可能会大于1 */
@property (assign, nonatomic) CGFloat pullingPercent;


/** a dictionary use to save userInfo */
@property (nonatomic, strong, readonly, nonnull) NSMutableDictionary* userInfo;
@property (nonatomic, getter=isAnimating, readonly) BOOL animating;
@property (nonatomic, strong, nullable) id beginRefreshingSource;
@property (nonatomic, strong, nullable) id endRefreshingReason;
/** customizable duration of animation */
@property (nonatomic) NSTimeInterval beginRefreshingAnimationDuration;
@property (nonatomic) NSTimeInterval endRefreshingAnimationDuration;


#pragma mark 可覆盖方法
- (void)initialize  NS_REQUIRES_SUPER;
- (void)scrollViewContentOffsetDidChange:(nonnull NSDictionary *)change;
/** default imp check and change scrollViewOriginInsets */
- (void)scrollViewContentInsetDidChange:(nonnull NSDictionary *)change;
- (void)changeFromState:(SWRefreshState)oldState to:(SWRefreshState)newState;
- (void)bindScrollView:(nonnull UIScrollView*)scrollView NS_REQUIRES_SUPER;
- (void)unbindScrollView:(nonnull UIScrollView*)scrollView NS_REQUIRES_SUPER;

#pragma mark 子类或相关类调用方法
/** set scrollView inset without change SWRefreshViewModels scrollViewOriginInsets
 *  subclasses may need to call this method to avoid modify scrollViewOriginInsets
 */
- (void)setScrollViewTempInset:(UIEdgeInsets)inset;
- (BOOL)isSettingTempInset; ///< return YES when calling setScrollViewTempInset;

@end

@protocol SWRefreshView

@required
@property (nonatomic, strong, nullable) SWRefreshViewModel* sourceViewModel;

@optional
/** return default headerViewModelClass. used when need to create one. */
+ (nonnull Class)defaultHeaderViewModelClass;
/** return default footerViewModelClass. used when need to create one. */
+ (nonnull Class)defaultFooterViewModelClass;

/** return default id<SWRefreshHeaderController> class. used when need to create one. */
+ (nonnull Class)defaultHeaderControllerClass;
/** return default id<SWRefreshFooterController> class. used when need to create one. */
+ (nonnull Class)defaultFooterControllerClass;

@end
