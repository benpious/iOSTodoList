//
//  TDTodoItemCollectionViewCell.m
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDTodoItemCollectionViewCell.h"
#import "TDTodoItemView.h"
#import "CGGeometry+DoApp.h"

@interface TDTodoItemCollectionViewCell () <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic) TDTodoItemView *todoContentView;

@end

@implementation TDTodoItemCollectionViewCell
@synthesize isExpanded = _isExpanded, isDone = _isDone;

#pragma mark - layout

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.todoContentView = [[TDTodoItemView alloc] init];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGRect bounds = self.bounds;
  CGPoint center = td_CGRectGetCenter(bounds);
  self.todoContentView.bounds = bounds;
  self.todoContentView.center = center;
}

#pragma mark - collection view cell

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
  UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
  return attributes;
}

#pragma mark - setters

- (void)setTitle:(NSString *)title {
  self.todoContentView.title = title;
}

- (NSString *)title {
  return self.todoContentView.title;
}

- (void)setDescriptionText:(NSAttributedString *)descriptionText {
  self.todoContentView.descriptionText = descriptionText;
}

- (NSAttributedString *)descriptionText {
  return self.todoContentView.descriptionText;
}

- (void)setIsDone:(BOOL)isDone {
  _isDone = isDone;
  self.todoContentView.isDone = isDone;
}

- (void)setIsExpanded:(BOOL)isExpanded {
  _isExpanded = isExpanded;
  self.todoContentView.isExpanded = _isExpanded;
  [self setNeedsLayout];
}

- (void)setTodoContentView:(TDTodoItemView *)todoContentView {
  [_todoContentView removeFromSuperview];
  _todoContentView = todoContentView;
  [self addSubview:_todoContentView];
}

- (void)setSwipeOffset:(CGFloat)swipeOffset {
  [super setSwipeOffset:swipeOffset];
  self.todoContentView.transform = CGAffineTransformMakeTranslation(swipeOffset, 0);
}

- (BOOL)allowsSwiping {
  return !self.isExpanded;
}

@end
