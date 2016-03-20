//
//  CATransaction+TD_Blocks.h
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CATransaction (TD_Blocks)

+ (void)transactionWithDuration:(CFTimeInterval)duration
                 timingFunction:(CAMediaTimingFunction *)function
                     animations:(void(^)())animations;
+ (void)transactionWithDuration:(CFTimeInterval)duration
                     animations:(void(^)())animations;

@end
