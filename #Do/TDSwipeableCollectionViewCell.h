//
//  TDSwipeableCollectionViewCell.h
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDItemMarkState.h"
#import "TDCellContentView.h"

@class TDSwipeableCollectionViewCell;

@protocol TDSwipeableCollectionViewCellDelegate <NSObject>

- (void)userSwipedOnCell:(TDSwipeableCollectionViewCell *)cell
              withAction:(TDItemMarkState)action;

@end

@interface TDSwipeableCollectionViewCell : UICollectionViewCell

@property (nonatomic, readonly) BOOL allowsSwiping;
@property (nonatomic) CGFloat swipeOffset;
@property (nonatomic, weak) id<TDSwipeableCollectionViewCellDelegate> swipeActionDelegate;
@property (nonatomic) TDCellContentView *contentEffectView;

- (TDItemMarkState)markStateForTranslation:(CGFloat)translation;

@end
