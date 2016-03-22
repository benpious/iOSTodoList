//
//  TDCollectionViewLayout.m
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDCollectionViewLayout.h"

NSString *const kPullDownHeaderElementKind = @"PullDownHeaderElementKind";

@implementation TDCollectionViewLayout

#pragma mark - cell layout

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:indexPath];
  TDCollectionViewLayoutState state = [self.todoLayoutDelegate stateForCollectionViewLayout:self];
  if (state == TDTodoCollectionViewLayoutStatePickingSection) {
    attributes.frame = CGRectMake(attributes.frame.origin.x,
                                  self.collectionView.bounds.size.height,
                                  attributes.frame.size.width,
                                  attributes.frame.size.height);
    attributes.alpha = 1;
    attributes.zIndex = MAX(1, attributes.zIndex);
  }
  return attributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
  UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
  TDCollectionViewLayoutState state = [self.todoLayoutDelegate stateForCollectionViewLayout:self];
  if (state == TDTodoCollectionViewLayoutStatePickingSection) {
    attributes.frame = CGRectMake(attributes.frame.origin.x,
                                  0 - attributes.frame.size.height,
                                  attributes.frame.size.width,
                                  attributes.frame.size.height);
    attributes.alpha = 1;
    attributes.zIndex = MAX(1, attributes.zIndex);
  }
  return attributes;
}

#pragma mark - invalidation

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  if (newBounds.origin.y < 0) {
    return YES;
  }
  else {
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
  }
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds {
  UICollectionViewLayoutInvalidationContext *context = [super invalidationContextForBoundsChange:newBounds];
  if (newBounds.origin.y < 0) {
    [context invalidateSupplementaryElementsOfKind:kPullDownHeaderElementKind
                                      atIndexPaths:@[self.pullDownPath]];
    return context;
  }
  else {
    return context;
  }
}

#pragma mark - adding a new todo item

//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//  UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
//  if ([indexPath isEqual:[self.todoLayoutDelegate indexPathToPinToTopForCollectionViewLayout:self]]) {
//    CGRect frame = attributes.frame;
//    frame.origin.y = 0;
//    attributes.frame = frame;
//    attributes.zIndex = NSIntegerMax;
//  }
//  return attributes;
//}

#pragma mark - pull down header

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                                                     atIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind
                                                                                       atIndexPath:indexPath];
  if ([elementKind isEqualToString:kPullDownHeaderElementKind] &&
      [indexPath isEqual:self.pullDownPath]) {
    CGRect bounds = self.collectionView.bounds;
    if (!attributes) {
      attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind
                                                                                  withIndexPath:indexPath];
      attributes.frame = CGRectMake(bounds.origin.x,
                                    bounds.origin.y,
                                    self.itemSize.width,
                                    self.itemSize.height);
    }
    CGRect frame = attributes.frame;
    attributes.frame = CGRectMake(frame.origin.x,
                                  self.collectionView.contentOffset.y,
                                  frame.size.width,
                                  frame.size.height);
    attributes.zIndex = 0;
    attributes.transform = CGAffineTransformMakeTranslation(0, self.itemSize.height + self.collectionView.contentOffset.y);
    return attributes;
  }
  else {
    return attributes;
  }
}

- (NSIndexPath *)pullDownPath {
  return [NSIndexPath indexPathForItem:0
                             inSection:0];
}

@end
