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
#import "TDInteractiveTransitionLayoutAttributes.h"

static const NSTimeInterval kTDSwipeAnimationsTimeInterval = 0.2;

@interface TDSwipeableCollectionViewCell () <UIGestureRecognizerDelegate>

@property (nonatomic) TDSwipeBackgroundView *swipeView;
#pragma mark - swipe gesture state
@property (nonatomic) TDItemMarkState swipeMarkingState;
@property (nonatomic) BOOL hasRecognizedSwipe;
@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic) UILongPressGestureRecognizer *longPressRecognizer;

@end

@implementation TDSwipeableCollectionViewCell
@synthesize theme = _theme;

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(panDetected:)];
    self.contentEffectView = [[TDCellContentView alloc] init];
    self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(longPressDetected:)];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.indexPath = nil;
}

#pragma mark - user actions

- (void)panDetected:(UIPanGestureRecognizer *)gesture {
  if ([gesture isEqual:self.panGestureRecognizer]) {
    if (gesture.state == UIGestureRecognizerStateBegan) {
    self.priorSwipeMarkingState = self.swipeMarkingState;
    }
    CGPoint translation = [gesture translationInView:self];
    if ([self isTranslationValid:translation]) {
      self.hasRecognizedSwipe = YES;
      self.swipeMarkingState = [self markStateForTranslation:translation.x];
      self.swipeOffset = translation.x;
      if (gesture.state == UIGestureRecognizerStateEnded) {
        if (ABS(translation.x) > self.minimumSwipeDistance) {
          [self.swipeActionDelegate userSwipedOnCell:self
                                          withAction:self.swipeMarkingState];
        }
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

- (void)longPressDetected:(UILongPressGestureRecognizer *)press {
  if ([press isEqual:self.longPressRecognizer]) {
    [self.swipeActionDelegate userLongPressedOnCell:self
                                    recognizerState:press.state
                                         toPosition:[press locationInView:self]];
  }
}

- (BOOL)isTranslationValid:(CGPoint)translation {
  CGPoint absoluteTranslation = CGPointMake(ABS(translation.x), ABS(translation.y));
  return self.hasRecognizedSwipe ||
  (absoluteTranslation.x > 4 &&
   absoluteTranslation.y < self.maximumVerticalSwipeDistance);
}

- (void)resetSwipingState {
  self.hasRecognizedSwipe = NO;
  [UIView animateWithDuration:kTDSwipeAnimationsTimeInterval
                   animations:^{
                     self.swipeOffset = 0;
                   }
                   completion:^(BOOL __unused finished) {
                     self.swipeMarkingState = self.priorSwipeMarkingState;
                   }];
}

- (TDItemMarkState)markStateForTranslation:(CGFloat)translation {
  if (translation < 0) {
    return TDItemMarkStateDeleted;
  }
  else {
    if (self.priorSwipeMarkingState == TDItemMarkStateDone) {
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
  self.contentEffectView.bounds = bounds;
  self.contentEffectView.center = center;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
  [super applyLayoutAttributes:layoutAttributes];
  if ([layoutAttributes isKindOfClass:[TDInteractiveTransitionLayoutAttributes class]]) {
    TDInteractiveTransitionLayoutAttributes *interactiveAttributes = (id)layoutAttributes;
    self.layer.shadowColor = interactiveAttributes.shadowColor.CGColor;
    self.layer.shadowOpacity = interactiveAttributes.shadowOpacity;
    self.layer.shadowOffset = interactiveAttributes.shadowOffset;
    self.layer.shadowPath = interactiveAttributes.shadowPath.CGPath;
    self.layer.shadowRadius = interactiveAttributes.shadowBlurRadius;
  }
  else {
    self.layer.shadowOpacity = 0;
  }
}

#pragma mark - setters and getters

- (void)setContentEffectView:(TDCellContentView *)contentEffectView {
  [_contentEffectView removeFromSuperview];
  _contentEffectView = contentEffectView;
  [self.contentView addSubview:_contentEffectView];
}

- (void)setSwipeView:(TDSwipeBackgroundView *)swipeView {
  [_swipeView removeFromSuperview];
  _swipeView = swipeView;
  _swipeView.theme = self.theme;
  [self.contentView insertSubview:_swipeView
                          atIndex:0];
  [self setNeedsLayout];
}

- (void)setPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
  [self removeGestureRecognizer:_panGestureRecognizer];
  [_panGestureRecognizer removeTarget:self
                               action:@selector(panDetected:)];
  _panGestureRecognizer = panGestureRecognizer;
  _panGestureRecognizer.delegate = self;
  [self addGestureRecognizer:_panGestureRecognizer];
}

- (void)setLongPressRecognizer:(UILongPressGestureRecognizer *)longPressRecognizer {
  [self removeGestureRecognizer:_longPressRecognizer];
  [_longPressRecognizer removeTarget:self
                              action:@selector(longPressDetected:)];
  _longPressRecognizer = longPressRecognizer;
  [self addGestureRecognizer:_longPressRecognizer];
}

- (void)setSwipeMarkingState:(TDItemMarkState)swipeMarkingState {
  if (swipeMarkingState != _swipeMarkingState) {
    _swipeMarkingState = swipeMarkingState;
    self.swipeView = [TDSwipeBackgroundView swipeBackgroundToMarkState:_swipeMarkingState];
  }
}

- (void)setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];
  self.contentEffectView.isContentPressed = highlighted;
}

- (void)setTheme:(TDTheme *)theme {
  _theme = theme;
  self.swipeView.theme = theme;
  self.contentEffectView.theme = theme;
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

- (void)setSwipeOffset:(CGFloat)swipeOffset {
  _swipeOffset = swipeOffset;
  self.contentEffectView.transform = CGAffineTransformMakeTranslation(_swipeOffset, 0);
}

- (void)beginEditingContent {
  /* no op */
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)__unused gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)__unused otherGestureRecognizer {
  return YES;
}

@end
