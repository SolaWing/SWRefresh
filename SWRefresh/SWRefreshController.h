//
//  SWRefreshController.h
//  SWRefresh
//
//  Created by SolaWing on 16/3/14.
//  Copyright © 2016年 SW. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SWRefreshView.h"
#import "SWRefreshHeaderViewModel.h"
#import "SWRefreshFooterViewModel.h"

#pragma mark - Protocol

/** 该类用于控制要使用哪种View和ViewModel, 并管理View在scrollView中如何放置
 * 该类被相应的ScrollView拥有 */
@protocol SWRefreshHeaderController <NSObject>

@required
- (__kindof UIView<SWRefreshView>*)headerView;
- (__kindof SWRefreshHeaderViewModel*)headerModel;
/** this object owned by the scrollView, and the scrollView set this property
 * you may need to chain this property to ViewModel */
@property (nonatomic, assign) UIScrollView* scrollView;

@optional
- (void)setHeaderModel:(__kindof SWRefreshHeaderViewModel *)headerModel;
- (void)setHeaderView:(__kindof UIView<SWRefreshView> *)headerView;

@end

@protocol SWRefreshFooterController <NSObject>

@required
- (__kindof UIView<SWRefreshView>*)footerView;
- (__kindof SWRefreshFooterViewModel*)footerModel;
/** this object owned by the scrollView, and the scrollView set this property
 * you may need to chain this property to ViewModel */
@property (nonatomic, assign) UIScrollView* scrollView;

@optional
- (void)setFooterModel:(__kindof SWRefreshFooterViewModel *)footerModel;
- (void)setFooterView:(__kindof UIView<SWRefreshView> *)footerView;

@property (nonatomic) bool hideWhenNoMore;

@end


#pragma mark - Class

@interface SWRefreshHeaderController : NSObject <SWRefreshHeaderController>

@property (nonatomic, assign) UIScrollView* scrollView;
@property (nonatomic, strong) __kindof UIView<SWRefreshView>* headerView;
@property (nonatomic, strong) __kindof SWRefreshHeaderViewModel* headerModel;
@property (nonatomic) CGFloat insetTop;     ///< insetTop for headerView

@end

@interface SWRefreshFooterController : NSObject <SWRefreshFooterController>

@property (nonatomic, assign) UIScrollView* scrollView;
@property (nonatomic, strong) __kindof UIView<SWRefreshView>* footerView;
@property (nonatomic, strong) __kindof SWRefreshFooterViewModel* footerModel;

@property (nonatomic) CGFloat insetBottom;  ///< insetBottom for footerView
/** when content height below this threshold, footer will hide and disable. default 200 */
@property (nonatomic, assign) CGFloat footerVisibleThreshold;
/** when nomore state, hide footer */
@property (nonatomic) bool hideWhenNoMore;

@end
