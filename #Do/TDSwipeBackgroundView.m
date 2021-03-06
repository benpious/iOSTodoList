//
//  TDSwipeBackgroundView.m
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDSwipeBackgroundView.h"

#pragma mark - subclass interfaces

@interface TDSwipeDoneView : TDSwipeBackgroundView

@end

@interface TDSwipeNotDoneView : TDSwipeBackgroundView

@end

@interface TDSwipeDeletedView : TDSwipeBackgroundView

@end

#pragma mark - main implementation

@interface TDSwipeBackgroundView ()

@property (nonatomic) UILabel *iconLabel;
@property (nonatomic) BOOL iconIsOnLeft;

@end

@implementation TDSwipeBackgroundView
@synthesize theme = _theme;

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.iconLabel = [[UILabel alloc] init];
    self.icon = self.class.defaultIconText;
    self.iconIsOnLeft = NO;
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGSize size = self.bounds.size;
  CGFloat proportion = 0.2f;
  CGFloat padding = 10;
  self.iconLabel.bounds = CGRectMake(0, 0, size.width * proportion, size.height);
  self.iconLabel.center = CGPointMake(self.iconIsOnLeft ? self.iconLabel.bounds.size.width / 2 + padding : size.width - (self.iconLabel.bounds.size.width / 2 + padding),
                                      size.height / 2);
}

+ (id)swipeBackgroundToMarkState:(TDItemMarkState)markState {
  return [[@{@(TDItemMarkStateNotDone): [TDSwipeNotDoneView class],
             @(TDItemMarkStateDone): [TDSwipeDoneView class],
             @(TDItemMarkStateDeleted): [TDSwipeDeletedView class]}[@(markState)] alloc] init];
}

- (void)setIconIsOnLeft:(BOOL)iconIsOnLeft {
  self.iconLabel.textAlignment = iconIsOnLeft ? NSTextAlignmentLeft : NSTextAlignmentRight;
  _iconIsOnLeft = iconIsOnLeft;
  [self setNeedsLayout];
}

- (void)setIcon:(NSString *)icon {
  self.iconLabel.text = icon;
}

- (void)setTheme:(TDTheme *)theme {
  _theme = theme;
  self.iconLabel.textColor = theme.textColor;
}

- (NSString *)icon {
  return self.iconLabel.text;
}

- (void)setIconLabel:(UILabel *)iconLabel {
  [_iconLabel removeFromSuperview];
  _iconLabel = iconLabel;
  [self addSubview:_iconLabel];
}

+ (NSString *)defaultIconText {
  return @"";
}

- (void)userSwipedWithLocation:(CGPoint)__unused location
                   translation:(CGPoint)__unused translation
             percentCompletion:(CGFloat)percent {
  self.iconLabel.alpha = percent;
}

@end

#pragma mark - done implementation

@implementation TDSwipeDoneView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.iconIsOnLeft = YES;
  }
  return self;
}

- (void)setTheme:(TDTheme *)theme {
  [super setTheme:theme];
  self.backgroundColor = self.theme.doneColor;
}

+ (NSString *)defaultIconText {
  return @"Done";
}

@end

@implementation TDSwipeNotDoneView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.iconIsOnLeft = YES;
  }
  return self;
}

- (void)setTheme:(TDTheme *)theme {
  [super setTheme:theme];
  self.backgroundColor = self.theme.backgroundColor;
}

+ (NSString *)defaultIconText {
  return @"Not Done";
}

@end

@implementation TDSwipeDeletedView

- (void)setTheme:(TDTheme *)theme {
  [super setTheme:theme];
  self.backgroundColor = self.theme.deleteColor;
}

+ (NSString *)defaultIconText {
  return @"Delete";
}

@end
