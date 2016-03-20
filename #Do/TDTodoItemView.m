//
//  TDTodoItemView.m
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDTodoItemView.h"
#import "TDTextField.h"
#import "CGGeometry+DoApp.h"

@interface TDTodoItemView ()

@property (nonatomic) TDTextField *titleField;
@property (nonatomic) UITextView *descriptionTextView;

@end

@implementation TDTodoItemView
@synthesize isExpanded = _isExpanded, isDone = _isDone, theme = _theme;

#pragma mark - layout

- (instancetype)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.titleField = [[TDTextField alloc] init];
    self.descriptionTextView = [[UITextView alloc] init];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGRect bounds = self.bounds;
  self.titleField.bounds = bounds;
  self.titleField.center = td_CGRectGetCenter(bounds);
}

#pragma mark - getters and setters

- (void)setTitleField:(TDTextField *)titleField {
  [_titleField removeFromSuperview];
  _titleField = titleField;
  [self addSubview:_titleField];
}

- (void)setDescriptionTextView:(UITextView *)descriptionTextView {
  [_descriptionTextView removeFromSuperview];
  _descriptionTextView = descriptionTextView;
  [self addSubview:_descriptionTextView];
}

- (void)setDescriptionText:(NSAttributedString *)descriptionText {
  self.descriptionTextView.attributedText = descriptionText;
}

- (NSAttributedString *)descriptionText {
  return self.descriptionTextView.attributedText;
}

- (void)setTitle:(NSString *)title {
  self.titleField.text = title;
}

- (NSString *)title {
  return self.titleField.text;
}

- (void)setTheme:(TDTheme *)theme {
  _theme = theme;
  self.titleField.textColor = theme.textColor;
  self.backgroundColor = theme.foregroundColor;
}

@end
