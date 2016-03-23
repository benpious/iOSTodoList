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
/**
 @param cell the sender
 @param state the state of the gesture recognizer that recognized the gesture
 @param position the position in cell's coordinate system
 */
- (void)userLongPressedOnCell:(TDSwipeableCollectionViewCell *)cell
              recognizerState:(UIGestureRecognizerState)state
                   toPosition:(CGPoint)position;

@end

@interface TDSwipeableCollectionViewCell : UICollectionViewCell <TDThemeable>

#pragma mark - public
@property (nonatomic, weak) id<TDSwipeableCollectionViewCellDelegate> swipeActionDelegate;
@property (nonatomic) TDCellContentView *contentEffectView;
#pragma mark - for subclasses
- (TDItemMarkState)markStateForTranslation:(CGFloat)translation;
- (BOOL)isTranslationValid:(CGPoint)translation;
- (void)beginEditingContent;
@property (nonatomic, readonly) BOOL hasRecognizedSwipe;
@property (nonatomic, readonly) CGFloat minimumSwipeDistance;
@property (nonatomic, readonly) CGFloat maximumVerticalSwipeDistance;
@property (nonatomic) CGFloat swipeOffset;
@property (nonatomic, readonly) BOOL allowsSwiping;
@property (nonatomic) NSIndexPath *indexPath;

@end
