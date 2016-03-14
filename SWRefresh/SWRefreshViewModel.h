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

/** Refresh基类, 不要直接使用 */
@interface SWRefreshViewModel : NSObject

/** 使用assign确保deallocing时, scrollView仍然有效 */
@property (nonatomic, assign) UIScrollView* scrollView;
@property (nonatomic, assign) UIEdgeInsets scrollViewOriginInsets;

/** set scrollView inset without change SWRefreshViewModels scrollViewOriginInsets
 *  subclasses may need to call this method to avoid modify scrollViewOriginInsets
 */
- (void)setScrollViewTempInset:(UIEdgeInsets)inset;
- (BOOL)isSettingTempInset; ///< return YES when calling setScrollViewTempInset;
#pragma mark 回调
/** 正在刷新的回调 */
@property (nonatomic, copy) dispatch_block_t refreshingBlock;
/** 设置回调对象和回调方法 */
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action;
@property (nonatomic, weak) id refreshTarget;
@property (nonatomic, assign) SEL refreshAction;
- (void)executeRefreshingCallback;

#pragma mark 状态
/** 进入刷新状态 */
- (void)beginRefreshing:(BOOL)animated;
#define SWRefreshSourceUserToken nil
/** 进入刷新状态, source可用来区分触发刷新来源 */
- (void)beginRefreshing:(BOOL)animated source:(id)source;
/** 结束刷新状态 */
- (void)endRefreshing:(BOOL)animated;
/** 结束刷新状态并设置结束原因 */
- (void)endRefreshing:(BOOL)animated reason:(id)reason;
/** 结束刷新状态并设置结束状态和原因 */
- (void)endRefreshingWithState:(SWRefreshState)state animated:(BOOL)animated reason:(id)reason;
#define SWRefreshEndRefreshSuccessToken nil
/** 是否正在刷新 */
- (BOOL)isRefreshing;
/** 刷新状态 */
@property (nonatomic) SWRefreshState state;

/** 拉拽的百分比 */
@property (assign, nonatomic) CGFloat pullingPercent;

/** a dictionary use to save userInfo */
@property (nonatomic, strong, readonly) NSMutableDictionary* userInfo;
@property (nonatomic, getter=isAnimating, readonly) BOOL animating;
@property (nonatomic, strong) id beginRefreshingSource;
@property (nonatomic, strong) id endRefreshingReason;
@property (nonatomic) NSTimeInterval endRefreshingAnimationDuration;

#pragma mark 可覆盖方法
- (void)initialize  NS_REQUIRES_SUPER;
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change;
/** default imp check and change scrollViewOriginInsets */
- (void)scrollViewContentInsetDidChange:(NSDictionary *)change;
- (void)changeFromState:(SWRefreshState)oldState to:(SWRefreshState)newState;
- (void)bindScrollView:(UIScrollView*)scrollView NS_REQUIRES_SUPER;
- (void)unbindScrollView:(UIScrollView*)scrollView NS_REQUIRES_SUPER;

@end

@protocol SWRefreshView

@required
@property (nonatomic, strong) SWRefreshViewModel* sourceViewModel;

@optional
/** return default headerViewModelClass. used when need to create one. default use SWRefreshHeaderViewModel */
+ (Class)defaultHeaderViewModelClass; ///<
/** return default footerViewModelClass. used when need to create one. default use SWRefreshFooterViewModel */
+ (Class)defaultFooterViewModelClass; ///< return default footerViewModelClass. used when need to create one.

@end
