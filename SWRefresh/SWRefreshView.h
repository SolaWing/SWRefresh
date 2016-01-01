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

@property (nonatomic, strong) SWRefreshViewModel* sourceViewModel;

#pragma mark   Override method
- (void)changePullingPercent:(CGFloat)pullingPercent;
- (void)changeFromState:(SWRefreshState)oldState to:(SWRefreshState)newState;

@end
