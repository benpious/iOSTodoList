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
@property (nonatomic) NSArray <NSNumber *> *options;
- (void)userDragAtPoint:(CGPoint)point;
#pragma mark - configuration for individual sections
- (void)configureForSectionList;
- (void)configureForSection;

@end
