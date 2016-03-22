//
//  TDMutableModelCollection.h
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TDMutableModelCollection <NSObject>

- (void)pushNewItem;
- (void)removeItemAtIndex:(NSUInteger)index;
- (void)exchangeItemAtIndex:(NSUInteger)index
            withItemAtIndex:(NSUInteger)otherIndex;
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj
          atIndex:(NSUInteger)idx;

@end
