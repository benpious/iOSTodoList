//
//  TDTodoSectionList.m
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDTodoSectionList.h"

@implementation TDTodoSectionList

- (instancetype)initWithList:(NSArray<TDTodoSection *> *)list {
  if (self = [super init]) {
    self.list = list;
  }
  return self;
}

@end
