//
//  ViewController.m
//  SA_AutoRollingBanner
//
//  Created by gaoqiang xu on 17/05/2017.
//  Copyright © 2017 SealedCompany. All rights reserved.
//

#import "ViewController.h"
#import "SA_AutoRollingBanner.h"

@interface ViewController ()
<SA_AutoRollingBannerDataSource>
@property (weak, nonatomic) IBOutlet SA_AutoRollingBanner *bannerView;

@property (strong, nonatomic) NSArray <NSString *>*strings;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.strings = @[@"What's", @"new", @", buddy ?"];
    
    [self.bannerView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.bannerView startRolling];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.bannerView stopRolling];
}

#pragma mark - SA_AutoRollingBannerDataSource
- (NSUInteger)sa_numberOfItemsForBanner:(SA_AutoRollingBanner * _Nonnull)banner {
    return self.strings.count;
}

- (__kindof UIView * _Nonnull)sa_viewForBanner:(SA_AutoRollingBanner * _Nonnull)banner atIndex:(NSUInteger)index {
    UILabel *label = [banner dequeueReusableView];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:banner.bounds];
        label.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.f
                                                green:arc4random()%255/255.f
                                                 blue:arc4random()%255/255.f
                                                alpha:1];
        label.textColor = [UIColor blueColor];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    NSString *string = self.strings[index];
    label.text = string;
    
    return label;
}

@end
