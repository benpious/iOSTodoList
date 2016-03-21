//
//  Model+UI.h
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDManagedTodoSection.h"
#import "TDManagedTodoItem.h"
#import "TDManagedTodoLists.h"
#import "TDSwipeableCollectionViewCell.h"

#pragma mark - forward declarations

@protocol TDDisplayableItem;

#pragma mark - protocols

@protocol TDDisplayDataSource <TDMutableModelCollection>

- (TDSwipeableCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)configureCollectionView:(UICollectionView *)collectionView;
- (void)markItemAtIndex:(NSUInteger)index
              withState:(TDItemMarkState)state;
@property (nonatomic, readonly) NSUInteger numberOfItems;
@property (nonatomic, readonly) NSOrderedSet<id<TDDisplayableItem>> *displayItems;

@end

@protocol TDDisplayableItem <NSObject>

- (void)decorateCollectionViewCell:(UICollectionViewCell *)cell;

@end

#pragma mark - categories

@interface TDManagedTodoItem (UI) <TDDisplayableItem>

@end

@interface TDManagedTodoSection (UI) <TDDisplayableItem, TDDisplayDataSource>

@end

@interface TDManagedTodoLists (UI) <TDDisplayDataSource>

@end
