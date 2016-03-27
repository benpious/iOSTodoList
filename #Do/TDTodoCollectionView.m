//
//  TDTodoCollectionView.m
//  #Do
//
//  Created by Benjamin Pious on 3/21/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDTodoCollectionView.h"

@interface TDTodoCollectionView () <UIGestureRecognizerDelegate>

@property (nonatomic) UIPanGestureRecognizer *panGesture;

@end

@implementation TDTodoCollectionView

#pragma mark - initialization

- (instancetype)initWithPullDownResponder:(id<TDPullDownResponder>)responder {
  TDCollectionViewLayout *flowLayout = [[TDCollectionViewLayout alloc] init];
  if ((self = [super initWithFrame:CGRectZero
              collectionViewLayout:flowLayout])) {
    flowLayout.minimumLineSpacing = 2;
    [self registerClass:[TDPullDownOptionsView class]
forSupplementaryViewOfKind:kPullDownHeaderElementKind
    withReuseIdentifier:NSStringFromClass([TDPullDownOptionsView class])];
    self.backgroundColor = [UIColor clearColor];
    self.alwaysBounceVertical = YES;
    self.responder = responder;
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(panGestureRecognized:)];
    self.batchUpdateAnimationSpeed = 0.5f;
  }
  return self;
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)pan {
  if ([pan isEqual:self.panGesture] &&
      self.pullDownViewIsFullyVisible) {
    [self.pullDownView userDragAtPoint:[pan locationInView:self]];
    if (pan.state == UIGestureRecognizerStateEnded) {
      [self.responder userSelectedPullDownOption:self.pullDownView.selection];
    }
  }
}

#pragma mark - convenience accessors and setters

- (void)setPanGesture:(UIPanGestureRecognizer *)panGesture {
  [self removeGestureRecognizer:_panGesture];
  _panGesture.delegate = nil;
  _panGesture = panGesture;
  _panGesture.delegate = self;
  [self addGestureRecognizer:_panGesture];
}

- (TDPullDownOptionsView *)pullDownView {
  return (id)[self supplementaryViewForElementKind:kPullDownHeaderElementKind
                                       atIndexPath:[NSIndexPath indexPathForItem:0
                                                                       inSection:0]];
}

- (TDCollectionViewLayout *)todoLayout {
  return (id)self.collectionViewLayout;
}

- (BOOL)pullDownViewIsFullyVisible {
  return self.pullDownView.frame.origin.y < 0;
}

- (void)performUpdatesWithDuration:(float)duration
                      batchUpdates:(void (^)(void))updates
                        completion:(void (^)(BOOL))completion {
  [super performBatchUpdates:^{
    self.viewForFirstBaselineLayout.layer.speed = duration;
    if (updates) {
      updates();
    }
  }
                  completion:^(BOOL finished) {
                    self.viewForFirstBaselineLayout.layer.speed = 1;
                    if (finished) {
                      completion(finished);
                    }
                  }];
}

- (void)performBatchUpdates:(void (^)(void))updates
                 completion:(void (^)(BOOL))completion {
  [self performUpdatesWithDuration:self.batchUpdateAnimationSpeed
                      batchUpdates:updates
                        completion:completion];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  if ([@[gestureRecognizer, otherGestureRecognizer] containsObject:_panGesture]) {
    return YES;
  }
  else {
    /*
     It seems as though UICollectionView privately overrides this, or something else is going on, because unless we have this line,
     the collectionview continues to scroll even when the user is interactively repositioning cells.
     */
    return NO;
  }
}

@end
