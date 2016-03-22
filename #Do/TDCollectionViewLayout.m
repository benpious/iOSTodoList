//
//  TDCollectionViewLayout.m
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDCollectionViewLayout.h"
#import <FleksyUtilities/NSArray+FleksyUtilities.h>

NSString *const kPullDownHeaderElementKind = @"PullDownHeaderElementKind";

@implementation TDCollectionViewLayout

#pragma mark - cell layout

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:indexPath];
  TDCollectionViewLayoutState state = [self.todoLayoutDelegate stateForCollectionViewLayout:self];
  CGRect frame = attributes.frame;
  if (state == TDTodoCollectionViewLayoutStatePickingSection) {
    NSArray<NSIndexPath *> *paths = [self.todoLayoutDelegate indexPathsAboveTransitionCollectionViewLayout:self];
    frame.origin.y = [paths fly_exists:^BOOL(__kindof NSIndexPath *p) {
      return [p compare:indexPath] == NSOrderedSame;
    }] ? -attributes.frame.size.height : self.collectionView.bounds.size.height;
    attributes.frame = frame;
  }
  else {
    attributes.alpha = 1;
    frame.origin.x = -frame.size.width;
    attributes.frame = frame;
  }
  attributes.alpha = 1;
  attributes.zIndex = MAX(1, attributes.zIndex);
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
  }
  attributes.zIndex = MAX(1, attributes.zIndex);
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

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
  if ([indexPath isEqual:[self.todoLayoutDelegate indexPathToPinToTopForCollectionViewLayout:self]]) {
    CGRect frame = attributes.frame;
    frame.origin.y = 0;
    attributes.frame = frame;
  }
  attributes.zIndex = MAX(1, attributes.zIndex);
  return attributes;
}

#pragma mark - pull down header

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind
                                                                                        atIndexPath:(NSIndexPath *)elementIndexPath {
  UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind
                                                                                       atIndexPath:elementIndexPath];
  if ([elementKind isEqualToString:kPullDownHeaderElementKind] &&
      [elementIndexPath compare:self.pullDownPath] == NSOrderedSame) {
    attributes.zIndex = 0;
    attributes.transform = CGAffineTransformIdentity;
    attributes.transform3D = CATransform3DIdentity;    return attributes;
  }
  else {
    return attributes;
  }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                                                     atIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind
                                                                                       atIndexPath:indexPath];
  if ([elementKind isEqualToString:kPullDownHeaderElementKind] &&
      [indexPath compare:self.pullDownPath] == NSOrderedSame) {
    CGRect bounds = self.collectionView.bounds;
    if (!attributes) {
      attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind
                                                                                  withIndexPath:indexPath];
      attributes.frame = CGRectMake(bounds.origin.x,
                                    bounds.origin.y,
                                    self.itemSize.width,
                                    self.itemSize.height);
    }
    attributes.zIndex = 0;
    CGRect frame = attributes.frame;
    attributes.frame = CGRectMake(frame.origin.x,
                                  self.itemSize.height + self.collectionView.contentOffset.y * 2,
                                  frame.size.width,
                                  frame.size.height);
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
