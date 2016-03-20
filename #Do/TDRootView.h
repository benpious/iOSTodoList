//
//  TDRootView.h
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model+UI.h"
#import "TDItemMarkState.h"
#import "TDTheme.h"

@protocol TDRootViewDelegate <NSObject>

- (void)selectedItemAtIndex:(NSUInteger)index;
- (void)markItemAtIndex:(NSUInteger)index
              withState:(TDItemMarkState)state;
- (void)addNewItem;

@end

@interface TDRootView : UIView <TDThemeable>

- (instancetype)initWithDelegate:(id<TDRootViewDelegate>)delegate;
@property (nonatomic) id<TDDisplayDataSource> dataSource;
@property (nonatomic, weak) id<TDRootViewDelegate> delegate;

@end
