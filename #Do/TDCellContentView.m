//
//  TDCellContentView.m
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDCellContentView.h"
#import "CGGeometry+DoApp.h"
#import "CATransaction+TD_Blocks.h"

@interface TDCellContentView ()

@end

@implementation TDCellContentView
@synthesize theme = _theme;

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGRect bounds = self.bounds;
  self.contentView.bounds = bounds;
  self.contentView.center = td_CGRectGetCenter(bounds);
}

- (void)setIsContentPressed:(BOOL)isContentPressed {
  _isContentPressed = isContentPressed;
  [CATransaction transactionWithDuration:0.3
                              animations:^{
                                /* TODO: these don't seem to be animating -- maybe we need an explicit animation... */
                                self.contentView.layer.shadowOffset = CGSizeZero;
                                self.contentView.layer.shadowRadius = self.contentView.bounds.size.width * self.shadowAdditionalArea;
                                self.contentView.layer.shadowColor = self.shadowColorForContentView;
                                self.contentView.layer.shadowOpacity = self.shadowOpacityForContentView;
                              }];
  [UIView animateWithDuration:0.3
                   animations:^{
                     self.contentView.transform = self.transformForContentView;
                   }];
}

- (void)setContentView:(UIView<TDThemeable> *)contentView {
  [_contentView removeFromSuperview];
  _contentView = contentView;
  [self addSubview:_contentView];
}

- (CGAffineTransform)pressedTransform {
  CGFloat scale = 0.8;
  return CGAffineTransformMakeScale(scale, scale);
}

- (CGAffineTransform)normalTransform {
  return CGAffineTransformIdentity;
}

- (CGAffineTransform)transformForContentView {
  return self.isContentPressed ? self.pressedTransform : self.normalTransform;
}

- (CGFloat)shadowOpacityForContentView {
  return self.isContentPressed ? 1 : 0;
}

- (CGColorRef)shadowColorForContentView {
  return (self.isContentPressed ? [UIColor blackColor] : [UIColor clearColor]).CGColor;
}

- (CGFloat)shadowAdditionalArea {
  return 0.1f;
}

- (CGPathRef)shadowPathForContentView {
  CGFloat scale = 1 + self.shadowAdditionalArea * 2;
  CGAffineTransform t = CGAffineTransformMakeScale(scale, scale);
  return self.isContentPressed ? CFAutorelease(CGPathCreateWithRect(self.contentView.bounds, &t)) : NULL;
}

- (void)setTheme:(TDTheme *)theme {
  _theme = theme;
  self.contentView.theme = theme;
}

@end
