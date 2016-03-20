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

@interface TDRootView () <UICollectionViewDataSource, UICollectionViewDelegate, TDSwipeableCollectionViewCellDelegate>

@property (nonatomic) UICollectionView *collectionView;

@end

@implementation TDRootView
@synthesize theme = _theme;

- (instancetype)initWithDelegate:(id<TDRootViewDelegate>)delegate {
  if (self = [super init]) {
    self.delegate = delegate;
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame
                                             collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGRect bounds = self.bounds;
  self.collectionView.bounds = bounds;
  self.collectionView.center = td_CGRectGetCenter(bounds);
  CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
  self.collectionView.contentInset = UIEdgeInsetsMake(statusBarHeight, 0, 0, 0);
  UICollectionViewFlowLayout *flowLayout = (id)self.collectionView.collectionViewLayout;
  CGFloat visibleItems = 8;
  flowLayout.itemSize = CGSizeMake(bounds.size.width, bounds.size.height / visibleItems);
}

- (void)setCollectionView:(UICollectionView *)collectionView {
  [_collectionView removeFromSuperview];
  _collectionView.dataSource = nil;
  _collectionView.delegate = nil;
  _collectionView = collectionView;
  _collectionView.dataSource = self;
  _collectionView.delegate = self;
  [self addSubview:_collectionView];
}

- (void)setDataSource:(id<TDDisplayDataSource>)dataSource {
  _dataSource = dataSource;
  [_dataSource configureCollectionView:self.collectionView];
  [self.collectionView reloadData];
}

- (void)setTheme:(TDTheme *)theme {
  _theme = theme;
  NSArray *cells = self.collectionView.visibleCells;
  for (TDSwipeableCollectionViewCell *cell in cells) {
    cell.theme = _theme;
  }
}

#pragma mark - collection view methods

- (NSInteger)collectionView:(UICollectionView *)__unused collectionView
     numberOfItemsInSection:(NSInteger)__unused section {
  return self.dataSource.numberOfItems;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
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

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
  [self.delegate selectedItemAtIndex:indexPath.item];
}

- (void)userSwipedOnCell:(TDSwipeableCollectionViewCell *)cell
              withAction:(TDItemMarkState)action {
  NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
  [self.delegate markItemAtIndex:indexPath.item
                       withState:action];
}

@end