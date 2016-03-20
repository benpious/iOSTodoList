//
//  Model+UI.m
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "Model+UI.h"
#import "TDTodoSectionCollectionViewCell.h"
#import "TDTodoItemCollectionViewCell.h"

#pragma mark - Todo Item

@implementation TDTodoItem (UI)

#pragma mark - collection view class

+ (Class)collectionViewCellClass {
  return [TDTodoItemCollectionViewCell class];
}

#pragma mark - UI decoration methods

- (void)decorateCollectionViewCell:(UICollectionViewCell *)cell {
  if ([cell isKindOfClass:[TDTodoItemCollectionViewCell class]]) {
    TDTodoItemCollectionViewCell *todoCell = (id)cell;
    todoCell.title = self.title;
  }
}

@end

#pragma mark - section Item

@implementation TDTodoSection (UI)

- (void)exchangeItemAtIndex:(NSUInteger)index
            withItemAtIndex:(NSUInteger)otherIndex {
  /** TODO: implement */
}

- (void)markItemAtIndex:(NSUInteger)index
              withState:(TDItemMarkState)state {
  switch (state) {
    case TDItemMarkStateNotDone:
      self.todoItems[index].isDone = NO;
      break;
    case TDItemMarkStateDone:
      self.todoItems[index].isDone = YES;
    case TDItemMarkStateDeleted:
      /* TODO: handle this case */
      break;
  }
}

- (NSArray<id<TDDisplayableItem>> *)displayItems {
  return self.todoItems;
}

- (TDSwipeableCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  TDSwipeableCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIDForCollectionView
                                                                                  forIndexPath:indexPath];
  [self decorateCollectionViewCell:cell
                         indexPath:indexPath];
  return cell;
}

- (void)configureCollectionView:(UICollectionView *)collectionView {
  [collectionView registerClass:self.class.collectionViewCellClass
     forCellWithReuseIdentifier:self.reuseIDForCollectionView];
}

- (NSString *)reuseIDForCollectionView {
  return NSStringFromClass(self.class);
}

- (NSUInteger)numberOfItems {
  return self.todoItems.count;
}

#pragma mark - collection view class

+ (Class)collectionViewCellClass {
  return [TDTodoItemCollectionViewCell class];
}

#pragma mark - UI decoration methods

- (void)decorateCollectionViewCell:(UICollectionViewCell *)cell
                         indexPath:(NSIndexPath *)indexPath {
  [self.todoItems[indexPath.item] decorateCollectionViewCell:cell];
}

- (void)decorateCollectionViewCell:(UICollectionViewCell *)cell {
  if ([cell isKindOfClass:[TDTodoSectionCollectionViewCell class]]) {
    TDTodoSectionCollectionViewCell *sectionCell = (id)cell;
    sectionCell.name = self.title;
  }
}

@end

#pragma mark - Section list

@implementation TDTodoSectionList (UI)

- (void)exchangeItemAtIndex:(NSUInteger)index
            withItemAtIndex:(NSUInteger)otherIndex {
  /* TODO: implement */
}

- (NSArray<id<TDDisplayableItem>> *)displayItems {
  return self.list;
}

- (void)markItemAtIndex:(NSUInteger)index
              withState:(TDItemMarkState)state {
  switch (state) {
    case TDItemMarkStateDeleted:
      /* TODO: handle this case */
      break;
    default: {
      @throw [NSException exceptionWithName:@"Invalid Todo Action"
                                     reason:@"Section List items do not have a \"done\" state to set"
                                   userInfo:nil];
    }
      break;
  }
}

- (void)configureCollectionView:(UICollectionView *)collectionView {
  [collectionView registerClass:self.class.collectionViewCellClass
     forCellWithReuseIdentifier:self.reuseIDForCollectionView];
}

+ (Class)collectionViewCellClass {
  return [TDTodoSectionCollectionViewCell class];
}

- (TDSwipeableCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  TDSwipeableCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIDForCollectionView
                                                                         forIndexPath:indexPath];
  [self decorateCollectionViewCell:cell
                         indexPath:indexPath];
  return cell;
}

- (NSString *)reuseIDForCollectionView {
  return NSStringFromClass(self.class);
}

- (NSUInteger)numberOfItems {
  return self.list.count;
}

- (void)decorateCollectionViewCell:(UICollectionViewCell *)cell
                         indexPath:(NSIndexPath *)indexPath {
  [self.list[indexPath.item] decorateCollectionViewCell:cell];
}

@end