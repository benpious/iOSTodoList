//
//  TDSwipeBackgroundView.h
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDItemMarkState.h"
#import "TDTheme.h"

@interface TDSwipeBackgroundView : UIView <TDThemeable>

@property (nonatomic) NSString *icon;
+ (id)swipeBackgroundToMarkState:(TDItemMarkState)markState;
- (void)userSwipedWithLocation:(CGPoint)location
                   translation:(CGPoint)translation
             percentCompletion:(CGFloat)percent;

@end
