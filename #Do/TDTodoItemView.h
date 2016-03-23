//
//  TDTodoItemView.h
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDTodoItemDisplay.h"
#import "TDTheme.h"

@interface TDTodoItemView : UIView <TDTodoItemDisplay, TDThemeable>

- (void)beginEditingContent;
@property (nonatomic, weak) id<UITextFieldDelegate> titleFieldDelegate;

@end
