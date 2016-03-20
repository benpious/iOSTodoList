//
//  TDCollectionViewLayout.m
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDCollectionViewLayout.h"

@implementation TDCollectionViewLayout

- (CGSize)collectionViewContentSize {
  CGSize size = [super collectionViewContentSize];
  CGFloat arbitraryAddition = 20;
  size.height =  MAX((self.collectionView.bounds.size.height + arbitraryAddition), size.height);
  return size;
}

@end
