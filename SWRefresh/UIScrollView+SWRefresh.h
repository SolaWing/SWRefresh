//
//  UIScrollView+SWRefresh.h
//  SWRefresh
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRefreshController.h"

@interface UIScrollView (SWRefresh)

@property (nonatomic, strong) id<SWRefreshHeaderController> refreshHeader;
@property (nonatomic, strong) id<SWRefreshFooterController> refreshFooter;

@property (nonatomic, strong, readonly) __kindof SWRefreshHeaderViewModel* refreshHeaderModel;
@property (nonatomic, strong, readonly) __kindof SWRefreshFooterViewModel* refreshFooterModel;
@property (nonatomic, strong, readonly) __kindof UIView<SWRefreshView>* refreshHeaderView;
@property (nonatomic, strong, readonly) __kindof UIView<SWRefreshView>* refreshFooterView;

@end
