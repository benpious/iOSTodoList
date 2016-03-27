//
//  TDCollectionViewLayout.h
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kPullDownHeaderElementKind;

@class TDCollectionViewLayout;

typedef NS_ENUM(NSUInteger, TDCollectionViewLayoutState) {
  TDCollectionViewLayoutStateNormal,
  TDTodoCollectionViewLayoutStatePickingSection,
  TDTodoCollectionViewLayoutStateAddingNewItem,
};

@protocol TDCCollectionViewLayoutDelegate <NSObject>

- (TDCollectionViewLayoutState)stateForCollectionViewLayout:(TDCollectionViewLayout *)layout;
- (NSIndexPath *)indexPathToPinToTopForCollectionViewLayout:(TDCollectionViewLayout *)layout;
- (NSIndexPath *)indexPathOfTransitionForCollectionViewLayout:(TDCollectionViewLayout *)layout;
- (NSArray<NSIndexPath *> *)indexPathsAboveTransitionCollectionViewLayout:(TDCollectionViewLayout *)layout;
- (NSArray<NSIndexPath *> *)indexPathsBelowTransitionCollectionViewLayout:(TDCollectionViewLayout *)layout;
- (NSArray<NSIndexPath *> *)indexPathsToDeleteWithSwipeAnimationForCollectionViewLayout:(TDCollectionViewLayout *)layout;

@end

@interface TDCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic) id<TDCCollectionViewLayoutDelegate> todoLayoutDelegate;

@end
