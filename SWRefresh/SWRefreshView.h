//
//  SWRefreshView.h
//  SWRefresh
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRefreshViewModel.h"

@interface SWRefreshView : UIView <SWRefreshView>

+ (Class)defaultHeaderViewModelClass;
+ (Class)defaultFooterViewModelClass;

/** one shot for create view and ViewModel and bind them */
+ (instancetype)headerWithRefreshingBlock:(dispatch_block_t)block;
+ (instancetype)headerWithRefreshingTarget:(id)target action:(SEL)action;
+ (instancetype)footerWithRefreshingBlock:(dispatch_block_t)block;
+ (instancetype)footerWithRefreshingTarget:(id)target action:(SEL)action;

@property (nonatomic, strong) SWRefreshViewModel* sourceViewModel;

#pragma mark   Override method
- (void)changePullingPercent:(CGFloat)pullingPercent;
- (void)changeFromState:(SWRefreshState)oldState to:(SWRefreshState)newState;

@end
