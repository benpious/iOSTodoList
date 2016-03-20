//
//  Model+UI.h
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDTodoSection.h"
#import "TDTodoItem.h"
#import "TDTodoSectionList.h"
#import "TDSwipeableCollectionViewCell.h"

@protocol TDDisplayableItem;

@protocol TDDisplayDataSource <NSObject>

- (TDSwipeableCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath;
- (void)configureCollectionView:(UICollectionView *)collectionView;
- (void)markItemAtIndex:(NSUInteger)index
              withState:(TDItemMarkState)state;
@property (nonatomic, readonly) NSUInteger numberOfItems;
@property (nonatomic, readonly) NSArray<id<TDDisplayableItem>> *displayItems;

@end

@protocol TDDisplayableItem <NSObject>

- (void)decorateCollectionViewCell:(UICollectionViewCell *)cell;

@end

@interface TDTodoItem (UI) <TDDisplayableItem>

@end

@interface TDTodoSection (UI) <TDDisplayableItem, TDDisplayDataSource>

@end

@interface TDTodoSectionList (UI) <TDDisplayDataSource>

@end