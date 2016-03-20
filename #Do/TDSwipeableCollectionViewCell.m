//
//  TDSwipeableCollectionViewCell.m
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDSwipeableCollectionViewCell.h"
#import "TDSwipeBackgroundView.h"
#import "CGGeometry+DoApp.h"

static const NSTimeInterval kTDSwipeAnimationsTimeInterval = 0.2;

@interface TDSwipeableCollectionViewCell ()

@property (nonatomic) TDSwipeBackgroundView *swipeView;
#pragma mark - swipe gesture state
@property (nonatomic) TDItemMarkState swipeMarkingState;
@property (nonatomic) TDItemMarkState priorSwipeMarkingState;
@property (nonatomic) BOOL hasRecognizedSwipe;
@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
#pragma mark - utility
@property (nonatomic, readonly) CGFloat minimumSwipeDistance;
@property (nonatomic, readonly) CGFloat maximumVerticalSwipeDistance;

@end

@implementation TDSwipeableCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(panDetected:)];
  }
  return self;
}

#pragma mark - user actions

- (void)panDetected:(UIPanGestureRecognizer *)gesture {
  if ([gesture isEqual:self.panGestureRecognizer]) {
    if (gesture.state == UIGestureRecognizerStateBegan) {
    self.priorSwipeMarkingState = self.swipeMarkingState;
    }
    CGPoint translation = [gesture translationInView:self];
    CGPoint absoluteTranslation = CGPointMake(ABS(translation.x), ABS(translation.y));
    if (self.hasRecognizedSwipe ||
        (absoluteTranslation.x > self.minimumSwipeDistance &&
         absoluteTranslation.y < self.maximumVerticalSwipeDistance)) {
          self.hasRecognizedSwipe = YES;
      self.swipeMarkingState = [self markStateForTranslation:translation.x];
      self.swipeOffset = translation.x;
      if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.swipeActionDelegate userSwipedOnCell:self
                                        withAction:self.swipeMarkingState];
        [self resetSwipingState];
      }
      else if (gesture.state == UIGestureRecognizerStateCancelled) {
        [self resetSwipingState];
      }
    }
    else {
      [self resetSwipingState];
    }
  }
}

- (void)resetSwipingState {
  self.hasRecognizedSwipe = NO;
  self.swipeMarkingState = self.priorSwipeMarkingState;
  [UIView animateWithDuration:kTDSwipeAnimationsTimeInterval
                         animations:^{
                           self.swipeOffset = 0;
                         }
                         completion:^(BOOL __unused finished) {
                           self.swipeView = nil;
                         }];
}

- (TDItemMarkState)markStateForTranslation:(CGFloat)translation {
  if (translation > 0) {
    return TDItemMarkStateDeleted;
  }
  else {
    if (self.swipeMarkingState == TDItemMarkStateDone) {
      return TDItemMarkStateNotDone;
    }
    else {
      return TDItemMarkStateDone;
    }
  }
}

#pragma mark - layout

- (void)layoutSubviews {
  [super layoutSubviews];
  CGRect bounds = self.bounds;
  CGPoint center = td_CGRectGetCenter(bounds);
  self.swipeView.bounds = bounds;
  self.swipeView.center = center;
}

#pragma mark - setters and getters

- (void)setSwipeView:(TDSwipeBackgroundView *)swipeView {
  [_swipeView removeFromSuperview];
  _swipeView = swipeView;
  [self.contentView insertSubview:_swipeView
                          atIndex:self.subviews.count];
}

- (void)setPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
  [self removeGestureRecognizer:_panGestureRecognizer];
  [_panGestureRecognizer removeTarget:self
                               action:@selector(panDetected:)];
  _panGestureRecognizer = panGestureRecognizer;
  [self addGestureRecognizer:_panGestureRecognizer];
}

- (void)setSwipeMarkingState:(TDItemMarkState)swipeMarkingState {
  if (swipeMarkingState != _swipeMarkingState) {
    _swipeMarkingState = swipeMarkingState;
    self.swipeView = [TDSwipeBackgroundView swipeBackgroundToMarkState:_swipeMarkingState];
  }
}

#pragma mark swiping logic

- (BOOL)allowsSwiping {
  return YES;
}

- (CGFloat)minimumSwipeDistance {
  return self.bounds.size.width / 8;
}

- (CGFloat)maximumVerticalSwipeDistance {
  return self.bounds.size.height / 2;
}

@end
