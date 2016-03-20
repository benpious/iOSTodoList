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
#import "TDTheme.h"

@class TDSwipeableCollectionViewCell;

@protocol TDSwipeableCollectionViewCellDelegate <NSObject>

- (void)userSwipedOnCell:(TDSwipeableCollectionViewCell *)cell
              withAction:(TDItemMarkState)action;

@end

@interface TDSwipeableCollectionViewCell : UICollectionViewCell <TDThemeable>

#pragma mark - intended for subclasses
@property (nonatomic, weak) id<TDSwipeableCollectionViewCellDelegate> swipeActionDelegate;
@property (nonatomic) TDCellContentView *contentEffectView;
#pragma mark - for subclasses
- (TDItemMarkState)markStateForTranslation:(CGFloat)translation;
- (BOOL)isTranslationValid:(CGPoint)translation;
@property (nonatomic, readonly) BOOL hasRecognizedSwipe;
@property (nonatomic, readonly) CGFloat minimumSwipeDistance;
@property (nonatomic, readonly) CGFloat maximumVerticalSwipeDistance;
@property (nonatomic) CGFloat swipeOffset;
@property (nonatomic, readonly) BOOL allowsSwiping;

@end
