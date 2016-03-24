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
@property (nonatomic) UIView *selectionIndicatorView;

@end

@implementation TDPullDownOptionsView
@synthesize theme = _theme;

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self configureForSectionList];
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
      self.selection = self.options[i].integerValue;
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
  NSUInteger idx  = [self.options indexOfObject:@(_selection)];
  if (_selection &&
      idx != NSNotFound) {
    self.optionViews[idx].backgroundColor = [UIColor clearColor];
  }
  _selection = selection;
  self.optionViews[[self.options indexOfObject:@(_selection)]].backgroundColor = [UIColor redColor];
}

#pragma mark - options display management

- (void)configureForSectionList {
  self.options = @[@(TDPullDownSelectionAddNew), @(TDPullDownSelectionGoToOptions)];
}

- (void)configureForSection {
  self.options = @[@(TDPullDownSelectionAddNew), @(TDPullDownSelectionGoBack)];
}

- (void)setOptions:(NSArray<NSNumber *> *)options {
  _options = options;
  self.optionViews = [[options fly_map:^id(__kindof NSNumber *o) {
    return [self labelForPullDownOption:o.integerValue];
  }] fly_map:^id(__kindof id o) {
    UILabel *label = [[UILabel alloc] init];
    label.text = o;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
  }];

}

- (NSString *)labelForPullDownOption:(TDPullDownSelection)option {
  return @{@(TDPullDownSelectionAddNew): @"+",
           @(TDPullDownSelectionGoBack): @"<",
           @(TDPullDownSelectionGoToOptions): @"@"}[@(option)];
}


@end
