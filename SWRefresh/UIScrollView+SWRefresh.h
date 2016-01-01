//
//  UIScrollView+SWRefresh.h
//  SWRefresh
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRefresh.h"

@interface UIScrollView (SWRefresh)

@property (nonatomic, strong, readonly) SWRefresh* refreshControl;

@property (nonatomic, strong) __kindof SWRefreshHeaderViewModel* refreshHeader;
@property (nonatomic, strong) __kindof SWRefreshFooterViewModel* refreshFooter;

/** 设置时会使用view绑定的ViewModel */
@property (nonatomic, strong) __kindof UIView<SWRefreshView>* refreshHeaderView;
@property (nonatomic, strong) __kindof UIView<SWRefreshView>* refreshFooterView;

/** default class. used by refreshHeader and refreshFooter
 * for view class, must adopt SWRefreshView protocol.
 * for view model, must be SWRefreshHeaderViewModel or SWRefreshFooterViewModel subclass */
+ (void)registerDefaultHeaderView:(Class)headerViewClass andModel:(Class)modelViewClass;
+ (void)registerDefaultFooterView:(Class)footerViewClass andModel:(Class)modelViewClass;

/** 使用默认注册的View, ViewModel */
- (void)refreshHeader:(dispatch_block_t)callback;
- (void)refreshFooter:(dispatch_block_t)callback;
- (void)refreshHeaderTarget:(id)target action:(SEL)action;
- (void)refreshFooterTarget:(id)target action:(SEL)action;


@end
