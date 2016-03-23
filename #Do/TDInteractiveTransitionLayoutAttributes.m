//
//  TDInteractiveTransitionLayoutAttributes.m
//  #Do
//
//  Created by Ben Pious on 3/23/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDInteractiveTransitionLayoutAttributes.h"

@implementation TDInteractiveTransitionLayoutAttributes

+ (id)createWithLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes {
  TDInteractiveTransitionLayoutAttributes *interactiveAttributes = nil;
  switch (attributes.representedElementCategory) {
    case UICollectionElementCategoryCell:
      interactiveAttributes = [TDInteractiveTransitionLayoutAttributes layoutAttributesForCellWithIndexPath:attributes.indexPath];
      break;
    case UICollectionElementCategorySupplementaryView:
      interactiveAttributes = [TDInteractiveTransitionLayoutAttributes layoutAttributesForSupplementaryViewOfKind:attributes.representedElementKind
                                                                                                    withIndexPath:attributes.indexPath];
    case UICollectionElementCategoryDecorationView:
      interactiveAttributes = [TDInteractiveTransitionLayoutAttributes layoutAttributesForDecorationViewOfKind:attributes.representedElementKind
                                                                                                 withIndexPath:attributes.indexPath];
      break;
  }
  interactiveAttributes.hidden = attributes.hidden;
  interactiveAttributes.alpha = attributes.alpha;
  interactiveAttributes.zIndex = attributes.zIndex;
  interactiveAttributes.center = attributes.center;
  interactiveAttributes.bounds = attributes.bounds;
  interactiveAttributes.transform = attributes.transform;
  interactiveAttributes.transform3D = attributes.transform3D;
  interactiveAttributes.frame = attributes.frame;
  interactiveAttributes.shadowOpacity = 0.5;
  interactiveAttributes.shadowColor = [UIColor blackColor];
  CGRect bounds = interactiveAttributes.bounds;
  CGFloat scale = 0.1f;
  interactiveAttributes.shadowOffset = CGSizeMake(-bounds.size.width * scale / 2, - bounds.size.height * scale / 2);
  CGAffineTransform t = CGAffineTransformMakeScale(1 + scale, 1 + scale);
  interactiveAttributes.shadowPath = [UIBezierPath bezierPathWithRect:CGRectApplyAffineTransform(bounds, t)];
  interactiveAttributes.shadowBlurRadius = scale * bounds.size.width;
  return interactiveAttributes;
}

- (id)copyWithZone:(NSZone *)zone {
  TDInteractiveTransitionLayoutAttributes *attributes = [super copyWithZone:zone];
  attributes.shadowOpacity = self.shadowOpacity;
  attributes.shadowColor = self.shadowColor;
  attributes.shadowBlurRadius = self.shadowBlurRadius;
  attributes.shadowPath = self.shadowPath;
  return attributes;
}

- (BOOL)isEqual:(id)object {
  if ([object isKindOfClass:[self class]]) {
    TDInteractiveTransitionLayoutAttributes *o = object;
    return [super isEqual:object] &&
    [o.shadowColor isEqual:self.shadowColor] &&
    ABS(o.shadowOpacity - self.shadowOpacity) < 0.05 &&
    [self.shadowPath isEqual:o.shadowPath] &&
    CGSizeEqualToSize(self.shadowOffset, o.shadowOffset) &&
    ABS(o.shadowBlurRadius - self.shadowBlurRadius) < 0.05;
  }
  else {
    return NO;
  }
}

@end
