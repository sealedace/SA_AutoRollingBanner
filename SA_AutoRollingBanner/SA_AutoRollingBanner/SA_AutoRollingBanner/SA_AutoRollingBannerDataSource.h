//
//  SA_AutoRollingBannerDataSource.h
//  SA_AutoRollingBanner
//
//  Created by gaoqiang xu on 17/05/2017.
//  Copyright © 2017 SealedCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SA_AutoRollingBanner;

@protocol SA_AutoRollingBannerDataSource <NSObject>
@required
- (NSUInteger)sa_numberOfItemsForBanner:(SA_AutoRollingBanner * _Nonnull)banner;
- (__kindof UIView * _Nonnull)sa_viewForBanner:(SA_AutoRollingBanner * _Nonnull)banner atIndex:(NSUInteger)index;

@optional

@end

