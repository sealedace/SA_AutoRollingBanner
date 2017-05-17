//
//  SA_AutoRollingBanner.m
//  SA_AutoRollingBanner
//
//  Created by gaoqiang xu on 17/05/2017.
//  Copyright © 2017 SealedCompany. All rights reserved.
//

#import "SA_AutoRollingBanner.h"

@interface SA_AutoRollingBanner ()
<CAAnimationDelegate>
@property (nonatomic) NSUInteger numberOfItems;
@property (strong, nonatomic) NSMutableArray <__kindof UIView *> *reusableViews;
@property (strong, nonatomic) UIView *transitionView;
@property (nonatomic) NSUInteger currentIndex;
@property (unsafe_unretained, nonatomic) UIView *nextView;

@end

@implementation SA_AutoRollingBanner

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self _initialization];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self _initialization];
    
    return self;
}

- (void)didMoveToSuperview {
    if (!self.superview) {
        [self stopRolling];
        return;
    }
    
    if (self.numberOfItems == 0 && self.dataSource) {
        [self reloadData];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIView *view = [self currentView];
    if (view && view.superview == self) {
        view.frame = self.bounds;
    }
}

#pragma mark - Getters
- (NSMutableArray *)reusableViews {
    if (!_reusableViews) {
        _reusableViews = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _reusableViews;
}

- (UIView *)transitionView {
    if (!_transitionView) {
        _transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 2*CGRectGetHeight(self.bounds))];
        _transitionView.backgroundColor = [UIColor clearColor];
    }
    return _transitionView;
}

- (UIView *)currentView {
    __block UIView *view = nil;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.reusableViews containsObject:obj]) {
            view = obj;
            *stop = YES;
            return;
        }
    }];
    
    return view;
}

- (NSUInteger)nextIndex {
    NSUInteger i = self.currentIndex + 1;
    if (i >= self.numberOfItems) {
        i = 0;
    }
    return i;
}

#pragma mark - Private
- (void)_initialization {
    self.rollingAnimationDuration = 0.3f;
    self.rollingInterval = 3.f;
    self.clipsToBounds = YES;
}

- (void)_animate {
    // Remove all subviews
    [self.transitionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // set transition view position
    self.transitionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 2*CGRectGetHeight(self.bounds));
    [self addSubview:self.transitionView];
    self.transitionView.hidden = NO;
    
    // get views for animation
    UIView *topView = [self currentView];
    UIView *bottomView = [self getViewFromDataSourceAtIndex:[self nextIndex]];
    self.nextView = bottomView;
    
    // set frame
    topView.frame = self.bounds;
    bottomView.frame = CGRectMake(0, CGRectGetHeight(self.transitionView.frame)-CGRectGetHeight(topView.frame), CGRectGetWidth(topView.frame), CGRectGetHeight(topView.frame));
    
    // add views on the transition view
    [self.transitionView addSubview:topView];
    [self.transitionView addSubview:bottomView];
    
    // animate transition view
    CGPoint beginPosition = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetHeight(self.transitionView.frame)/2);
    CGPoint endPosition = CGPointMake(beginPosition.x, CGRectGetHeight(self.bounds)-CGRectGetHeight(self.transitionView.frame)/2);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = self.rollingAnimationDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSValue valueWithCGPoint:beginPosition];
    animation.toValue = [NSValue valueWithCGPoint:endPosition];
    animation.delegate = self;
    
    [self.transitionView.layer addAnimation:animation forKey:@"positionAnimation"];
    self.transitionView.layer.position = endPosition;
    
    [self performSelector:@selector(_animate) withObject:nil afterDelay:self.rollingInterval+self.rollingAnimationDuration];
}

- (__kindof UIView * _Nonnull)getViewFromDataSourceAtIndex:(NSUInteger)index {
    UIView *view = [self.dataSource sa_viewForBanner:self atIndex:index];
    if (![self.reusableViews containsObject:view]) {
        [self.reusableViews addObject:view];
    }
    
    return view;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.currentIndex = [self nextIndex];
    
    self.nextView.frame = self.bounds;
    [self addSubview:self.nextView];
    
    self.transitionView.hidden = YES;
    [self.transitionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - Public
- (__kindof UIView * _Nullable)dequeueReusableView {
    __block UIView *view = nil;
    [self.reusableViews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.superview) {
            view = obj;
            *stop = YES;
            return;
        }
    }];
    return view;
}

- (void)reloadData {
    if (!self.dataSource) {
        return;
    }
    
    self.currentIndex = 0;
    
    self.transitionView.hidden = YES;
    
    [self.reusableViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.numberOfItems = [self.dataSource sa_numberOfItemsForBanner:self];
    
    if (self.numberOfItems == 0) {
        return;
    }
    
    UIView *currentView = [self getViewFromDataSourceAtIndex:self.currentIndex];
    
    [self addSubview:currentView];
}

- (void)startRolling {
    [self stopRolling];
    
    [self performSelector:@selector(_animate) withObject:nil afterDelay:self.rollingInterval];
}

- (void)stopRolling {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_animate) object:nil];
}

@end
