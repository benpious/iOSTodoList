//
//  TDTodoCollectionView.h
//  #Do
//
//  Created by Benjamin Pious on 3/21/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDPullDownOptionsView.h"
#import "TDCollectionViewLayout.h"
#import "TDPullDownResponder.h"

@interface TDTodoCollectionView : UICollectionView

- (instancetype)initWithPullDownResponder:(id<TDPullDownResponder>)responder;
- (void)performUpdatesWithDuration:(float)duration
                      batchUpdates:(void (^)(void))updates
                        completion:(void (^)(BOOL))completion;
@property (nonatomic, weak) id<TDPullDownResponder> responder;
@property (nonatomic, readonly) TDPullDownOptionsView *pullDownView;
@property (nonatomic, readonly) TDCollectionViewLayout *todoLayout;
@property (nonatomic) float batchUpdateAnimationSpeed;

@end
