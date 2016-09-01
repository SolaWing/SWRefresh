//
//  SWRefreshView.h
//  SWRefresh
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRefreshViewModel.h"

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

@protocol SWRefreshHeaderController;
@protocol SWRefreshFooterController;

@interface SWRefreshView : UIView <SWRefreshView>{
    SWRefreshViewModel* _sourceViewModel;
}

+ (Class)defaultHeaderViewModelClass; ///< default use SWRefreshHeaderViewModel
+ (Class)defaultFooterViewModelClass; ///< default use SWRefreshFooterViewModel
+ (Class)defaultHeaderControllerClass; ///< default use SWRefreshHeaderController
+ (Class)defaultFooterControllerClass; ///< default use SWRefreshFooterController

/** one shot for create controller, view and ViewModel and bind them */
+ (id<SWRefreshHeaderController>)headerWithRefreshingBlock:(SWRefreshingBlock)block;
+ (id<SWRefreshHeaderController>)headerWithRefreshingTarget:(id)target action:(SEL)action;
+ (id<SWRefreshFooterController>)footerWithRefreshingBlock:(SWRefreshingBlock)block;
+ (id<SWRefreshFooterController>)footerWithRefreshingTarget:(id)target action:(SEL)action;

/** one shot for create a view and respond ViewModel */
+ (instancetype)newHeaderRefreshingBlock:(SWRefreshingBlock)block;
+ (instancetype)newHeaderRefreshingTarget:(id)target action:(SEL)action;
+ (instancetype)newFooterRefreshingBlock:(SWRefreshingBlock)block;
+ (instancetype)newFooterRefreshingTarget:(id)target action:(SEL)action;

@property (nonatomic, strong) SWRefreshViewModel* sourceViewModel;

#pragma mark   Overridable method
- (void)changePullingPercent:(CGFloat)pullingPercent;
- (void)changeFromState:(SWRefreshState)oldState to:(SWRefreshState)newState;

- (void)bindSourceViewModel:(SWRefreshViewModel*)sourceViewModel NS_REQUIRES_SUPER;
- (void)unbindSourceViewModel:(SWRefreshViewModel*)sourceViewModel NS_REQUIRES_SUPER;

@end
