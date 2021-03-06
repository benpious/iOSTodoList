//
//  TDRootView.m
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDRootView.h"
#import "CGGeometry+DoApp.h"
#import "TDSwipeableCollectionViewCell.h"
#import "TDCollectionViewLayout.h"
#import "TDPullDownOptionsView.h"
#import "TDTodoCollectionView.h"

#pragma mark - extension

@interface TDRootView () <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate ,TDSwipeableCollectionViewCellDelegate, TDPullDownResponder, TDCCollectionViewLayoutDelegate>

@property (nonatomic) TDTodoCollectionView *collectionView;
#pragma mark - layout state
@property (nonatomic) TDCollectionViewLayoutState currentCollectionViewOperation;
@property (nonatomic) NSIndexPath *lastSelectedIndexPath;
@property (nonatomic) NSUInteger priorElementCount;
@property (nonatomic) NSArray<NSIndexPath *> *indexPathsToDelete;

@end

@implementation TDRootView
@synthesize theme = _theme;

#pragma mark - initialization

- (instancetype)initWithDelegate:(id<TDRootViewDelegate>)delegate {
  if (self = [super init]) {
    self.delegate = delegate;
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.collectionView = [[TDTodoCollectionView alloc] initWithPullDownResponder:self];
    self.collectionView.todoLayout.todoLayoutDelegate = self;
  }
  return self;
}

#pragma mark - layout

- (void)layoutSubviews {
  [super layoutSubviews];
  CGRect bounds = self.bounds;
  CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
  CGFloat oldOffset = self.collectionView.contentInset.top;
  self.collectionView.contentInset = UIEdgeInsetsMake(statusBarHeight, 0, 0, 0);
  self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x,
                                                  self.collectionView.contentOffset.y - (oldOffset - statusBarHeight));
  UICollectionViewFlowLayout *flowLayout = (id)self.collectionView.collectionViewLayout;
  CGFloat visibleItems = 8;
  flowLayout.itemSize = CGSizeMake(bounds.size.width, bounds.size.height / visibleItems);
  self.collectionView.bounds = bounds;
  self.collectionView.center = td_CGRectGetCenter(bounds);
}

#pragma mark - setters and getters

- (void)setCollectionView:(TDTodoCollectionView *)collectionView {
  [_collectionView removeFromSuperview];
  _collectionView.dataSource = nil;
  _collectionView.delegate = nil;
  _collectionView = collectionView;
  _collectionView.dataSource = self;
  _collectionView.delegate = self;
  [self addSubview:_collectionView];
}

- (void)setDataSource:(id<TDDisplayDataSource>)dataSource {
  id<TDDisplayDataSource> priorDataSource = _dataSource;
  self.priorElementCount = priorDataSource.numberOfItems;
  _dataSource = dataSource;
  self.collectionView.pullDownView.options = _dataSource.pullDownOptions;
  [_dataSource configureCollectionView:self.collectionView];
  NSMutableArray *paths = [NSMutableArray array];
  for (NSUInteger i = 0; i < dataSource.numberOfItems; i++) {
    [paths addObject:[NSIndexPath indexPathForItem:i
                                         inSection:0]];
  }
  if (priorDataSource) {
    self.currentCollectionViewOperation = TDTodoCollectionViewLayoutStatePickingSection; /* TODO: need a way to make sure that this is a section and not backing up*/
    [self.collectionView sendSubviewToBack:self.collectionView.pullDownView];
    NSMutableArray *priorIndexPaths = [NSMutableArray array];
    for (NSUInteger i = 0; i < priorDataSource.numberOfItems; i++) {
      [priorIndexPaths addObject:[NSIndexPath indexPathForItem:i
                                                     inSection:0]];
    }
    [self.collectionView performBatchUpdates:^{
      [self.collectionView deleteItemsAtIndexPaths:priorIndexPaths];
      [self.collectionView insertItemsAtIndexPaths:paths];
    }
                                  completion:^(BOOL __unused finished) {
                                    self.currentCollectionViewOperation = TDCollectionViewLayoutStateNormal;
                                  }];
  }
  else {
    [self.collectionView reloadData];
  }
}

- (void)setTheme:(TDTheme *)theme {
  _theme = theme;
  self.backgroundColor = theme.backgroundColor;
  NSArray *cells = self.collectionView.visibleCells;
  for (TDSwipeableCollectionViewCell *cell in cells) {
    cell.theme = _theme;
  }
  self.collectionView.pullDownView.theme = theme;
}

#pragma mark - collection view methods

- (NSInteger)collectionView:(UICollectionView *)__unused collectionView
     numberOfItemsInSection:(NSInteger)__unused section {
  return self.dataSource.numberOfItems;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)__unused collectionView {
  return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  TDSwipeableCollectionViewCell *swipeCell = [self.dataSource collectionView:collectionView
                                                      cellForItemAtIndexPath:indexPath];
  swipeCell.swipeActionDelegate = self;
  swipeCell.theme = self.theme;
  return swipeCell;
}

- (void)collectionView:(UICollectionView *)__unused collectionView
   moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath
           toIndexPath:(NSIndexPath *)destinationIndexPath {
  [self.dataSource exchangeItemAtIndex:sourceIndexPath.item
                       withItemAtIndex:destinationIndexPath.item];
}

- (void)collectionView:(UICollectionView *)__unused collectionView
didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
  self.lastSelectedIndexPath = indexPath;
  [self.delegate selectedItemAtIndex:indexPath.item];
}

#pragma mark - supplementary view methods

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
  TDPullDownOptionsView *pullDownView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                           withReuseIdentifier:NSStringFromClass([TDPullDownOptionsView class])
                                                                                  forIndexPath:indexPath];
  return pullDownView;
}

#pragma mark - swipe cell delegate methods

- (void)userSwipedOnCell:(TDSwipeableCollectionViewCell *)cell
              withAction:(TDItemMarkState)action {
  NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
  if (action == TDItemMarkStateDone ||
      action == TDItemMarkStateNotDone) {
    [(id)cell setIsDone:action == TDItemMarkStateNotDone ? NO : YES];
    if (action == TDItemMarkStateDone) {
      NSIndexPath *path = [NSIndexPath indexPathForItem:self.dataSource.indexOfFirstDoneTodoItem
                                              inSection:0];
      [self.collectionView moveItemAtIndexPath:cell.indexPath
                                   toIndexPath:path];
    }
  }
  [self.delegate markItemAtIndex:indexPath.item
                       withState:action];
  if (action == TDItemMarkStateDeleted) {
    self.indexPathsToDelete = @[indexPath];
    [self.collectionView performBatchUpdates:^{
      [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
                                  completion:^(BOOL __unused finished) {
                                    self.indexPathsToDelete = nil;
                                  }];
  }
}

- (void)userLongPressedOnCell:(TDSwipeableCollectionViewCell *)cell
              recognizerState:(UIGestureRecognizerState)state
                   toPosition:(CGPoint)position {
  position = [self.collectionView convertPoint:position
                                      fromView:cell];
  NSIndexPath *path = [self.collectionView indexPathForCell:cell];
  switch (state) {
    case UIGestureRecognizerStateBegan:
      [self.collectionView beginInteractiveMovementForItemAtIndexPath:path];
      [self.collectionView updateInteractiveMovementTargetPosition:position];
      break;
    case UIGestureRecognizerStateChanged:
      [self.collectionView updateInteractiveMovementTargetPosition:position];
      break;
    case UIGestureRecognizerStateCancelled:
      [self.collectionView cancelInteractiveMovement];
    case UIGestureRecognizerStateEnded:
      [self.collectionView endInteractiveMovement];
    default:
      break;
  }
}

- (NSIndexPath *)indexPathForCell:(TDSwipeableCollectionViewCell *)cell {
  return [self.collectionView indexPathForCell:cell];
}

#pragma mark - pull down delegate

- (void)userSelectedPullDownOption:(TDPullDownSelection)selection {
  [self.delegate userSelectedPullDownOption:selection];
  if (selection == TDPullDownSelectionAddNew) {
    self.currentCollectionViewOperation = TDTodoCollectionViewLayoutStateAddingNewItem;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0
                                                 inSection:0];
    [self.collectionView performBatchUpdates:^{
      [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
    }
                                  completion:^(BOOL __unused  finished) {
                                    TDSwipeableCollectionViewCell *cell = (id)[self.collectionView cellForItemAtIndexPath:indexPath];
                                    [cell beginEditingContent];
                                  }];
  }
}

#pragma mark collection view todo layout delegate

- (TDCollectionViewLayoutState)stateForCollectionViewLayout:(TDCollectionViewLayout *)__unused layout {
  return self.currentCollectionViewOperation;
}

- (NSIndexPath *)indexPathOfTransitionForCollectionViewLayout:(TDCollectionViewLayout *)__unused layout {
  return self.lastSelectedIndexPath;
}

- (NSArray<NSIndexPath *> *)indexPathsBelowTransitionCollectionViewLayout:(TDCollectionViewLayout *)__unused layout {
  if (self.currentCollectionViewOperation == TDTodoCollectionViewLayoutStatePickingSection) {
    NSMutableArray *array = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.lastSelectedIndexPath.item; i++) {
      [array addObject:[NSIndexPath indexPathForItem:i
                                           inSection:0]];
    }
    return array;
  }
  else {
    return nil;
  }
}

- (NSArray<NSIndexPath *> *)indexPathsAboveTransitionCollectionViewLayout:(TDCollectionViewLayout *)__unused layout {
  if (self.currentCollectionViewOperation == TDTodoCollectionViewLayoutStatePickingSection) {
    NSUInteger count = self.priorElementCount;
    NSMutableArray *array = [NSMutableArray array];
    for (NSUInteger i = self.lastSelectedIndexPath.item; i < count; i++) {
      [array addObject:[NSIndexPath indexPathForItem:i
                                           inSection:0]];
    }
    return array;
  }
  else {
    return nil;
  }
}

- (NSIndexPath *)indexPathToPinToTopForCollectionViewLayout:(TDCollectionViewLayout *)__unused layout {
  if (self.currentCollectionViewOperation == TDTodoCollectionViewLayoutStateAddingNewItem) {
    return [NSIndexPath indexPathForItem:0
                               inSection:0];
  }
  else {
    return nil;
  }
}

- (NSArray<NSIndexPath *> *)indexPathsToDeleteWithSwipeAnimationForCollectionViewLayout:(TDCollectionViewLayout *)__unused layout {
  return self.indexPathsToDelete;
}

@end
