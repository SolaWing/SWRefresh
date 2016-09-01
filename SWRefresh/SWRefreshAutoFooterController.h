//
//  SWRefreshAutoFooterController.h
//  SWRefresh
//
//  Created by SolaWing on 16/1/3.
//  Copyright © 2016年 SW. All rights reserved.
//

#import "SWRefreshFooterController.h"

/** 占位通过点击或者自动刷新的Controller, 通过 refreshThreshold 可以控制触发刷新的边界 */
@interface SWRefreshAutoFooterController : SWRefreshFooterController

/** 是否超过临界点后自动刷新 */
@property (nonatomic, getter=isRefreshAutomatically) BOOL refreshAutomatically;
/** ScrollView底部需要预留出的空间 */
@property (nonatomic) CGFloat bottomInset;
/** the length use to calculate pullingPercent
 * 0 means pullingPercent only have 0 and 1 two values */
@property (nonatomic) CGFloat pullingLength;

@end
