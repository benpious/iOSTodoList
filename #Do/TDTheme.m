//
//  TDTheme.m
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDTheme.h"

@implementation TDTheme

- (instancetype)init {
  if (self = [super init]) {
    self.titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
  }
  return self;
}

- (UIColor *)notDoneColor {
  return self.backgroundColor;
}

@end
