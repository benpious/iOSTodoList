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
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGSize size = self.bounds.size;
  CGFloat proportion = 0.2f;
  self.iconLabel.bounds = CGRectMake(0, 0, size.width * proportion, size.height);
  self.iconLabel.center = CGPointMake(self.iconIsOnLeft ? self.iconLabel.bounds.size.width : size.width - self.iconLabel.bounds.size.width,
                                      size.height / 2);
}

+ (id)swipeBackgroundToMarkState:(TDItemMarkState)markState {
  return [[@{@(TDItemMarkStateNotDone): [TDSwipeNotDoneView class],
             @(TDItemMarkStateDone): [TDSwipeDoneView class],
             @(TDItemMarkStateDeleted): [TDSwipeDeletedView class]}[@(markState)] alloc] init];
}

- (void)setIconIsOnLeft:(BOOL)iconIsOnLeft {
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

- (void)panDetectedWithStartPoint:(CGPoint)start
                     currentPoint:(CGPoint)current {
  
}

@end

#pragma mark - done implementation

@implementation TDSwipeDoneView

- (void)setTheme:(TDTheme *)theme {
  [super setTheme:theme];
  self.backgroundColor = self.theme.doneColor;
}

+ (NSString *)defaultIconText {
  return @"Done";
}

@end

@implementation TDSwipeNotDoneView

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
