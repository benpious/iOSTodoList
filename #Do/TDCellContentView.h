//
//  TDCellContentView.h
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDTheme.h"

@interface TDCellContentView : UIView <TDThemeable>

@property (nonatomic) UIView<TDThemeable> *contentView;
@property (nonatomic) BOOL isContentPressed;

@end
