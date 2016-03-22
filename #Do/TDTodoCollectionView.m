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
  UICollectionViewFlowLayout *flowLayout = [[TDCollectionViewLayout alloc] init];
  if ((self = [super initWithFrame:CGRectZero
              collectionViewLayout:flowLayout])) {
    [self registerClass:[TDPullDownOptionsView class]
forSupplementaryViewOfKind:kPullDownHeaderElementKind
    withReuseIdentifier:NSStringFromClass([TDPullDownOptionsView class])];
    self.backgroundColor = [UIColor clearColor];
    self.alwaysBounceVertical = YES;
    self.responder = responder;
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(panGestureRecognized:)];
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)__unused gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)__unused otherGestureRecognizer {
  /* necessary to ensure that the pan gesture recognizer doesn't consume all hte touch events intended for the scroll view */
  return YES;
}

@end
