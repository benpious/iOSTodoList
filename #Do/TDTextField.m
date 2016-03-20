//
//  TDTextField.m
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDTextField.h"

@implementation TDTextField

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.textAlignment = NSTextAlignmentCenter;
  }
  return self;
}

- (BOOL)pointInside:(CGPoint)point
          withEvent:(UIEvent *)event {
  BOOL result = [super pointInside:point
                         withEvent:event];
  if (result) {
    CGSize textSize = [self.text sizeWithAttributes:@{NSFontAttributeName: self.font}];
    CGSize size = self.bounds.size;
    CGFloat x;
    switch (self.textAlignment) {
      case NSTextAlignmentCenter:
        x = (size.width - textSize.width) / 2;
        break;
      case NSTextAlignmentNatural: /* Note: will be incorrect for Left to right languages */
      case NSTextAlignmentLeft:
        x = 0;
        break;
      case NSTextAlignmentRight:
        x = size.width - textSize.width;
        break;
      default:
        /**
         Note: this will fail for attributed strings and certain other configurations of text field
         */
        @throw [NSException exceptionWithName:@"invalid text alignment"
                                       reason:@"Hit testing for this text alignment isn't implemented yet"
                                     userInfo:nil];
        break;
    }
    CGRect textRect = CGRectMake(x, (size.height - textSize.height) / 2, textSize.width, textSize.height);
    return CGRectContainsPoint(textRect, point);
  }
  else {
    return NO;
  }
}

@end
