//
//  TDPullDownOptionsView.m
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDPullDownOptionsView.h"
#import "CGGeometry+DoApp.h"
#import <FleksyUtilities/FleksyUtilities.h>

@interface TDPullDownOptionsView ()

@property (nonatomic) NSArray<UIView *> *optionViews;

@end

@implementation TDPullDownOptionsView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    NSArray *labels = @[@"+", @"<", @"@"];
    self.optionViews = [labels fly_map:^id(__kindof id o) {
      UILabel *label = [[UILabel alloc] init];
      label.text = o;
      label.textAlignment = NSTextAlignmentCenter;
      return label;
    }];
  }
  return self;
}

#pragma mark - layout

- (void)layoutSubviews {
  [super layoutSubviews];
  CGSize size = self.bounds.size;
  CGFloat width = size.width / self.optionViews.count;
  for (NSUInteger i = 0; i < self.optionViews.count; i++) {
    UIView *v = self.optionViews[i];
    v.bounds = CGRectMake(0, 0, width, size.height);
    v.center = CGPointMake(i * width + width / 2, size.height / 2);
  }
}

#pragma mark - user actions

- (void)userDragAtPoint:(CGPoint)point {
  for (NSUInteger i = 0; i < self.optionViews.count; i++) {
    UIView *v = self.optionViews[i];
    if (point.x > v.frame.origin.x &&
        point.x < CGRectGetMaxX(v.frame)) {
      self.selection = i + 1;
      break;
    }
  }
}

#pragma mark - setters

- (void)setOptionViews:(NSArray *)optionViews {
  [_optionViews.apply removeFromSuperview];
  _optionViews = optionViews;
  for (UIView *v in _optionViews) {
    [self addSubview:v];
  }
}

- (void)setSelection:(TDPullDownSelection)selection {
  if (_selection) {
    self.optionViews[_selection - 1].backgroundColor = [UIColor clearColor];
  }
  _selection = selection;
  self.optionViews[_selection - 1].backgroundColor = [UIColor redColor];
}

@end
