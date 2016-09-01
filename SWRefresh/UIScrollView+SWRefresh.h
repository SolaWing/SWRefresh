//
//  UIScrollView+SWRefresh.h
//  SWRefresh
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRefreshHeaderController.h"
#import "SWRefreshFooterController.h"

@interface UIScrollView (SWRefresh)

@property (nonatomic, strong) __kindof SWRefreshHeaderController* refreshHeader;
@property (nonatomic, strong) __kindof SWRefreshFooterController* refreshFooter;

@property (nonatomic, strong, readonly) __kindof id<SWRefreshViewModel> refreshHeaderModel;
@property (nonatomic, strong, readonly) __kindof id<SWRefreshViewModel> refreshFooterModel;
@property (nonatomic, strong, readonly) __kindof UIView<SWRefreshView>* refreshHeaderView;
@property (nonatomic, strong, readonly) __kindof UIView<SWRefreshView>* refreshFooterView;

@end
