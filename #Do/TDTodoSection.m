//
//  TDTodoSection.m
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDTodoSection.h"

@implementation TDTodoSection

- (instancetype)initWithTitle:(NSString *)title
                        items:(NSArray<TDTodoItem *> *)items {
  if (self = [super init]) {
    self.title = title;
    self.todoItems = items;
  }
  return self;
}

@end
