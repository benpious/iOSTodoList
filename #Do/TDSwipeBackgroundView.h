//
//  TDSwipeBackgroundView.h
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDItemMarkState.h"

@interface TDSwipeBackgroundView : UIView

@property (nonatomic) NSString *icon;
+ (id)swipeBackgroundToMarkState:(TDItemMarkState)markState;
- (void)panDetectedWithStartPoint:(CGPoint)start
                     currentPoint:(CGPoint)current;

@end
