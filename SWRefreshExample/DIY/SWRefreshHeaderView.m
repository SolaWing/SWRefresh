//
//  SWRefreshHeaderView.m
//  SWRefresh
//
//  Created by SolaWing on 16/1/1.
//  Copyright © 2016年 SW. All rights reserved.
//

#import "SWRefreshHeaderView.h"

@interface SWRefreshHeaderView ()

@property (nonatomic, strong) UILabel* stateLabel;

@end

@implementation SWRefreshHeaderView

- (nonnull instancetype)initWithFrame:(CGRect)frame {
    frame.size.height = 54;
    if (self = [super initWithFrame:frame]) {
        _stateLabel = [UILabel new];
        _stateLabel.font = [UIFont boldSystemFontOfSize:14];
        _stateLabel.backgroundColor = [UIColor clearColor];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_stateLabel];

        _stateLabel.text = @"下拉刷新";
        [_stateLabel sizeToFit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect bounds = self.bounds;
    _stateLabel.center = CGPointMake(bounds.size.width/2, bounds.size.height/2);
}

- (void)changePullingPercent:(CGFloat)pullingPercent {
    self.alpha = pullingPercent;
}

- (void)changeFromState:(SWRefreshState)oldState to:(SWRefreshState)newState {
    switch( newState ){
        case SWRefreshStateIdle: {
            _stateLabel.text = @"下拉刷新";
            _stateLabel.textColor = [UIColor darkGrayColor];
            break;
        }
        case SWRefreshStatePulling: {
            _stateLabel.text = @"释放刷新";
            _stateLabel.textColor = [UIColor redColor];
            break;
        }
        case SWRefreshStateRefreshing: {
            _stateLabel.text = @"正在刷新";
            _stateLabel.textColor = [UIColor blueColor];
            break;
        }
        default: {
            break;
        }
    }
}

@end
