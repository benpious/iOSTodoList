//
//  UIColor+TodoUtilities.m
//  #Do
//
//  Created by Ben Pious on 3/23/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "UIColor+TodoUtilities.h"

@implementation UIColor (TodoUtilities)
/**
 @note only works on colors in the RGB space presently
 */
- (UIColor *)colorAfterEnumeratingComponentsWithBlock:(CGFloat (^)(CGFloat component, NSUInteger idx))block {
  CGFloat components[4];
  [self getRed:components
         green:components + 1
          blue:components + 2
         alpha:components + 3];
  for (NSUInteger i = 0; i < 4; i++) {
    components[i] = block(components[i], i);
  }
  return [UIColor colorWithRed:components[0]
                         green:components[1]
                          blue:components[2]
                         alpha:components[3]];
}

- (UIColor *)desaturatedColor {
  return [self desaturatedColorWithPercent:0.4f];
}

- (UIColor *)desaturatedColorWithPercent:(CGFloat)percent {
  return [self colorAfterEnumeratingComponentsWithBlock:^CGFloat(CGFloat component,
                                                                 NSUInteger __unused idx) {
    return component * percent;
  }];
}

@end
