//
//  TDTheme.h
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 An object holding information to theme a view
 
 @note
 Why don't we just use UIApperance proxies? Three reasons
 
 - UIAppearance doesn't update live -- you have to re-add views to the hiearchy to get updates
 
 - It's basically a singleton
 
 - Because of (2), UIAppearance can "bleed" into other processes, particularly App Extensions, and the built-in system keyboard (try setting properties on UITableView while there are multiple keyboards enabled. It is _hilarious_)
 */
@interface TDTheme : NSObject

@property (nonatomic) UIColor *textColor;
@property (nonatomic) UIColor *foregroundColor;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) UIColor *doneColor;
@property (nonatomic, readonly) UIColor *notDoneColor;
@property (nonatomic) UIColor *deleteColor;
@property (nonatomic) UIStatusBarStyle statusBarStyle;

@end

@protocol TDThemeable <NSObject>

@property (nonatomic) TDTheme *theme;

@end