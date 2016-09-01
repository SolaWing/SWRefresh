//
//  SWRefreshViewController.h
//  SWRefresh
//
//  Created by SolaWing on 16/8/25.
//  Copyright © 2016年 SW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SWRefreshViewModel.h"
// #import "SWRefreshLayouter.h"
#import "SWRefreshView.h"

/** 该类是对ScrollView的扩展, 用于控制ScrollView的刷新行为并更新状态 */
@interface SWRefreshController : NSObject

/** 使用assign确保deallocing时, scrollView仍然有效 */
@property (nonatomic, assign, nullable) UIScrollView* scrollView;
@property (nonatomic, assign) UIEdgeInsets scrollViewOriginInsets;
@property (nonatomic, strong, nullable) id<SWRefreshViewModel> model;

@property (nonatomic, strong) UIView<SWRefreshView>* view;

#pragma mark 可覆盖方法
- (void)initialize  NS_REQUIRES_SUPER;
- (void)scrollViewContentOffsetDidChange:(nonnull NSDictionary *)change;
/** default imp check and change scrollViewOriginInsets */
- (void)scrollViewContentInsetDidChange:(nonnull NSDictionary *)change;
- (void)changeFromState:(SWRefreshState)oldState to:(SWRefreshState)newState;
- (void)bindScrollView:(nonnull UIScrollView*)scrollView NS_REQUIRES_SUPER;
- (void)unbindScrollView:(nonnull UIScrollView*)scrollView NS_REQUIRES_SUPER;

#pragma mark 子类或相关类调用方法
/** set scrollView inset without change scrollViewOriginInsets */
- (void)setScrollViewTempInset:(UIEdgeInsets)inset;

/** return YES when calling setScrollViewTempInset; */
- (BOOL)isSettingTempInset;

@end
