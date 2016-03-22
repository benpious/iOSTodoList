//
//  TDPullDownOptionsView.h
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDPullDownResponder.h"

@interface TDPullDownOptionsView : UICollectionReusableView

@property (nonatomic) TDPullDownSelection selection;
- (void)userDragAtPoint:(CGPoint)point;

@end
