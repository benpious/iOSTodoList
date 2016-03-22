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
};

@protocol TDCCollectionViewLayoutDelegate <NSObject>

- (TDCollectionViewLayoutState)stateForCollectionViewLayout:(TDCollectionViewLayout *)layout;
- (NSIndexPath *)indexPathToPinToTopForCollectionViewLayout:(TDCollectionViewLayout *)layout;
- (NSArray<NSIndexPath *> *)cellsAboveTransitionCollectionViewLayout:(TDCollectionViewLayout *)layout;

@end

@interface TDCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic) id<TDCCollectionViewLayoutDelegate> todoLayoutDelegate;

@end
