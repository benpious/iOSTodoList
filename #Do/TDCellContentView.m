//
//  TDCellContentView.m
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDCellContentView.h"
#import "CGGeometry+DoApp.h"

@interface TDCellContentView ()

@end

@implementation TDCellContentView

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
  [UIView animateWithDuration:0.3
                   animations:^{
                     self.contentView.transform = self.transformForContentView;
                   }];
}

- (void)setContentView:(UIView *)contentView {
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

@end
