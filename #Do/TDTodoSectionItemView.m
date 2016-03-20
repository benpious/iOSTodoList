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

@interface TDTodoSectionItemView ()

@property (nonatomic) TDTextField *nameField;

@end

@implementation TDTodoSectionItemView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.nameField = [[TDTextField alloc] init];
    self.backgroundColor = [UIColor grayColor];
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

@end
