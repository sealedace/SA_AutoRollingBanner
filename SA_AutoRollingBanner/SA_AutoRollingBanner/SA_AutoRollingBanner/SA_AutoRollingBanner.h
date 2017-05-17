//
//  SA_AutoRollingBanner.h
//  SA_AutoRollingBanner
//
//  Created by gaoqiang xu on 17/05/2017.
//  Copyright © 2017 SealedCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_AutoRollingBannerDataSource.h"

@interface SA_AutoRollingBanner : UIView
@property (weak, nonatomic, nullable) IBOutlet id <SA_AutoRollingBannerDataSource> dataSource;
@property (nonatomic) NSTimeInterval rollingInterval;
@property (nonatomic) NSTimeInterval rollingAnimationDuration;

- (__kindof UIView * _Nullable)dequeueReusableView;

- (void)reloadData;

- (void)startRolling;

- (void)stopRolling;

@end
