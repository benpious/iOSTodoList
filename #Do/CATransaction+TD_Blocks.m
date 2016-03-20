//
//  CATransaction+TD_Blocks.m
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "CATransaction+TD_Blocks.h"

@implementation CATransaction (TD_Blocks)

+ (void)transactionWithDuration:(CFTimeInterval)duration
                 timingFunction:(CAMediaTimingFunction *)function
                     animations:(void(^)())animations {
  void(^lifted)() = ^{
    [CATransaction setAnimationTimingFunction:function];
    animations();
  };
  [self transactionWithDuration:duration
                     animations:lifted];
}

+ (void)transactionWithDuration:(CFTimeInterval)duration
                     animations:(void(^)())animations {
  [CATransaction begin];
  [CATransaction setAnimationDuration:duration];
  animations();
  [CATransaction commit];
}

@end
