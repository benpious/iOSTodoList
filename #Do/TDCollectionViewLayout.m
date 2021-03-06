//
//  TDCollectionViewLayout.m
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDCollectionViewLayout.h"
#import "TDInteractiveTransitionLayoutAttributes.h"
#import <FleksyUtilities/NSArray+FleksyUtilities.h>

NSString *const kPullDownHeaderElementKind = @"PullDownHeaderElementKind";

static CATransform3D td_perspectiveTransform();

@implementation TDCollectionViewLayout

#pragma mark - cell layout

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:indexPath];
  TDCollectionViewLayoutState state = [self.todoLayoutDelegate stateForCollectionViewLayout:self];
  CGRect frame = attributes.frame;
  if (state == TDTodoCollectionViewLayoutStatePickingSection) {
    NSArray<NSIndexPath *> *paths = [self.todoLayoutDelegate indexPathsAboveTransitionCollectionViewLayout:self];
    CGFloat yTranslation = ([paths fly_exists:^BOOL(__kindof NSIndexPath *p) {
      return [p compare:indexPath] == NSOrderedSame;
    }] ? 1 : -1) * self.collectionView.bounds.size.height;
    CATransform3D t = CATransform3DMakeTranslation(0, yTranslation, -500);
    t = CATransform3DConcat(t, td_perspectiveTransform());
    attributes.transform3D = t;
    attributes.zIndex = MAX(1, attributes.zIndex) + 5; /* Adding an arbirary number to make sure that we're always bigger than the zIndexes of the cells below us. TODO: This will need to be revisted later. */
  }
  else if ([self.todoLayoutDelegate indexPathsToDeleteWithSwipeAnimationForCollectionViewLayout:self]) {
    frame.origin.x = -frame.size.width;
    attributes.frame = frame;
    attributes.zIndex = 0;
  }
  attributes.alpha = 1; /* Weirdly, at the end of interactive reordering operations the cell to place has zero alpha, so we have to deal with this */
  return attributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
  UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
  TDCollectionViewLayoutState state = [self.todoLayoutDelegate stateForCollectionViewLayout:self];
  if (state == TDTodoCollectionViewLayoutStatePickingSection) {
    NSIndexPath *path = [self.todoLayoutDelegate indexPathOfTransitionForCollectionViewLayout:self];
    UICollectionViewLayoutAttributes *startingAttributes = [self layoutAttributesForItemAtIndexPath:path];
    attributes.zIndex = MAX(1, startingAttributes.zIndex - 1);
    attributes.frame = startingAttributes.frame;
    attributes.alpha = 1;
    attributes.transform3D = CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 500), td_perspectiveTransform());
  }
  else {
    attributes.zIndex = MAX(1, attributes.zIndex);
  }
  return attributes;
}

#pragma mark - interactive transition

- (UICollectionViewLayoutAttributes *)layoutAttributesForInteractivelyMovingItemAtIndexPath:(NSIndexPath *)indexPath
                                                                         withTargetPosition:(CGPoint)position {
  UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForInteractivelyMovingItemAtIndexPath:indexPath
                                                                                           withTargetPosition:position];

  return [TDInteractiveTransitionLayoutAttributes createWithLayoutAttributes:attributes];
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
    return attributes;
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
    CGRect frame = attributes.frame;
    attributes.alpha = MAX(0, MIN(1, ((self.itemSize.height - self.collectionView.contentOffset.y) / self.collectionView.bounds.size.height)));
    attributes.frame = CGRectMake(frame.origin.x,
                                  self.itemSize.height + self.collectionView.contentOffset.y * 2,
                                  frame.size.width,
                                  frame.size.height);
    attributes.zIndex = 0;
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

static CATransform3D td_perspectiveTransform() {
  CATransform3D t = CATransform3DIdentity;
  t.m34 = 1.0f / 800;
  return t;
}
