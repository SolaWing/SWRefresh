//
//  SWRefreshAutoFooterViewModel.h
//  SWRefresh
//
//  Created by SolaWing on 16/1/3.
//  Copyright © 2016年 SW. All rights reserved.
//

#import "SWRefreshFooterViewModel.h"

/** 占位通过点击或者自动刷新的ViewModel, 通过 refreshThreshold 可以控制触发刷新的边界 */
@interface SWRefreshAutoFooterViewModel : SWRefreshFooterViewModel

/** 是否超过临界点后自动刷新 */
@property (nonatomic, assign, getter=isRefreshAutomatically) BOOL refreshAutomatically;
/** ScrollView底部需要预留出的空间 */
@property (nonatomic, assign) CGFloat bottomInset;



@end
