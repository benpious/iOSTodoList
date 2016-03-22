//
//  TDTodoSectionItemView.h
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDSectionDisplay.h"
#import "TDTheme.h"

@interface TDTodoSectionItemView : UIView <TDSectionDisplay, TDThemeable>

@property (nonatomic, weak) id<UITextFieldDelegate> titleFieldDelegate;

@end
