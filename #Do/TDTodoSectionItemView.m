//
//  TDTodoSectionItemView.m
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDTodoSectionItemView.h"
#import "TDTextField.h"
#import "CGGeometry+DoApp.h"
#import "UIColor+TodoUtilities.h"

@interface TDTodoSectionItemView ()

@property (nonatomic) TDTextField *nameField;

@end

@implementation TDTodoSectionItemView
@synthesize theme = _theme;

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.nameField = [[TDTextField alloc] init];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGRect bounds = self.bounds;
  self.nameField.bounds = bounds;
  self.nameField.center = td_CGRectGetCenter(bounds);
}

- (void)setNameField:(TDTextField *)nameField {
  [_nameField removeFromSuperview];
  _nameField = nameField;
  [self addSubview:_nameField];
}

- (void)setName:(NSString *)name {
  self.nameField.text = name;
}

- (NSString *)name {
  return self.nameField.text;
}

- (void)setTheme:(TDTheme *)theme {
  _theme = theme;
  self.nameField.textColor = theme.textColor;
  self.nameField.tintColor = self.theme.foregroundColor.desaturatedColor;
  self.nameField.font = self.theme.titleFont;
  self.backgroundColor = theme.foregroundColor;
}

- (void)setTitleFieldDelegate:(id<UITextFieldDelegate>)titleFieldDelegate {
  _titleFieldDelegate = titleFieldDelegate;
  self.nameField.delegate = _titleFieldDelegate;
}

- (void)beginEditingContent {
  [self.nameField becomeFirstResponder];
}

@end
