//
//  TDTodoItem.m
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDTodoItem.h"

@implementation TDTodoItem

#pragma mark - initializers

- (instancetype)initWithTitle:(NSString *)title {
  if (self = [super init]) {
    self.title = title;
  }
  return self;
}
- (instancetype)initWithTitle:(NSString *)title
              descriptionText:(NSAttributedString *)descriptionText {
  if (self = [self initWithTitle:title]) {
    self.descriptionText = descriptionText;
  }
  return self;
}

- (instancetype)initWithTitle:(NSString *)title
              descriptionText:(NSAttributedString *)descriptionText
                       isDone:(BOOL)isDone {
  if (self = [self initWithTitle:title
                 descriptionText:descriptionText]) {
    self.isDone = isDone;
  }
  return self;
}

@end
