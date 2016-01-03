//
//  SWRefresh.h
//  SWRefresh
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWRefreshHeaderViewModel.h"
#import "SWRefreshBackFooterViewModel.h"
#import "SWRefreshAutoFooterViewModel.h"
#import "SWRefreshView.h"

@interface SWRefresh : NSObject

/** 使用assign, 确保deallocing时不会置空 */
@property (nonatomic, assign) UIScrollView* scrollView;

@property (nonatomic, strong) SWRefreshHeaderViewModel* header;
@property (nonatomic, strong) SWRefreshFooterViewModel* footer;

@property (nonatomic, strong) UIView<SWRefreshView>* headerView;
@property (nonatomic, strong) UIView<SWRefreshView>* footerView;

@end
