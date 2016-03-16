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
/** must implement if used as SWRefreshView default controller class! */
+ (instancetype)newWithHeaderView:(UIView<SWRefreshView>*)headerView model:(SWRefreshHeaderViewModel*)model;

- (void)setHeaderModel:(__kindof SWRefreshHeaderViewModel *)headerModel;
- (void)setHeaderView:(__kindof UIView<SWRefreshView> *)headerView;
/** offset for pos headerView */
@property (nonatomic) CGFloat headerOffset;


@end

@protocol SWRefreshFooterController <NSObject>

@required
- (__kindof UIView<SWRefreshView>*)footerView;
- (__kindof SWRefreshFooterViewModel*)footerModel;
/** this object owned by the scrollView, and the scrollView set this property
 * you may need to chain this property to ViewModel */
@property (nonatomic, assign) UIScrollView* scrollView;

@optional
/** must implement if used as SWRefreshView default controller class! */
+ (instancetype)newWithFooterView:(UIView<SWRefreshView>*)footerView model:(SWRefreshFooterViewModel*)model;

- (void)setFooterModel:(__kindof SWRefreshFooterViewModel *)footerModel;
- (void)setFooterView:(__kindof UIView<SWRefreshView> *)footerView;

/** offset for pos footerView */
@property (nonatomic) CGFloat footerOffset;
@property (nonatomic) CGFloat footerVisibleThreshold;
@property (nonatomic) bool hideWhenNoMore;

@end


#pragma mark - Class

@interface SWRefreshHeaderController : NSObject <SWRefreshHeaderController>

+ (instancetype)newWithHeaderView:(UIView<SWRefreshView>*)headerView model:(SWRefreshHeaderViewModel*)model;

@property (nonatomic, assign) UIScrollView* scrollView;
@property (nonatomic, strong) __kindof UIView<SWRefreshView>* headerView;
@property (nonatomic, strong) __kindof SWRefreshHeaderViewModel* headerModel;
@property (nonatomic) CGFloat headerOffset;     ///< insetTop for headerView, positive offset make headerView move to top

@end

@interface SWRefreshFooterController : NSObject <SWRefreshFooterController>

+ (instancetype)newWithFooterView:(UIView<SWRefreshView>*)footerView model:(SWRefreshFooterViewModel*)model;

@property (nonatomic, assign) UIScrollView* scrollView;
@property (nonatomic, strong) __kindof UIView<SWRefreshView>* footerView;
@property (nonatomic, strong) __kindof SWRefreshFooterViewModel* footerModel;

@property (nonatomic) CGFloat footerOffset;  ///< insetBottom for footerView, positive offset make footerView move to bottom
/** when content height below this threshold, footer will hide and disable. default 200 */
@property (nonatomic, assign) CGFloat footerVisibleThreshold;
/** when nomore state, hide footer */
@property (nonatomic) bool hideWhenNoMore;

@end
