//
//  TDTodoSectionCollectionViewCell.m
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDTodoSectionCollectionViewCell.h"
#import "TDTodoSectionItemView.h"
#import "CGGeometry+DoApp.h"

@interface TDTodoSectionCollectionViewCell ()

@property (nonatomic) TDTodoSectionItemView *sectionContentView;

@end

@implementation TDTodoSectionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.sectionContentView = [[TDTodoSectionItemView alloc] init];
  }
  return self;
}

#pragma mark - layout

- (void)layoutSubviews {
  [super layoutSubviews];
  CGRect bounds = self.bounds;
  self.sectionContentView.bounds = bounds;
  self.sectionContentView.center = td_CGRectGetCenter(bounds);
}

#pragma mark - setters

- (void)setName:(NSString *)name {
  self.sectionContentView.name = name;
}

- (NSString *)name {
  return self.sectionContentView.name;
}

- (void)setSectionContentView:(TDTodoSectionItemView *)sectionContentView {
  [_sectionContentView removeFromSuperview];
  _sectionContentView = sectionContentView;
  self.contentEffectView.contentView = _sectionContentView;
  [self setNeedsLayout];
}

- (BOOL)isTranslationValid:(CGPoint)translation {
  return translation.x > 0 &&
  translation.x > self.minimumSwipeDistance &&
  translation.y < self.maximumVerticalSwipeDistance;
}

@end
