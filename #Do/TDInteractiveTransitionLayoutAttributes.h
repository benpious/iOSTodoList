//
//  TDInteractiveTransitionLayoutAttributes.h
//  #Do
//
//  Created by Ben Pious on 3/23/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDInteractiveTransitionLayoutAttributes : UICollectionViewLayoutAttributes

+ (id)createWithLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes;
@property (nonatomic) UIColor *shadowColor;
@property (nonatomic) float shadowOpacity;
@property (nonatomic) UIBezierPath *shadowPath;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic) CGFloat shadowBlurRadius;

@end
