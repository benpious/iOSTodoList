//
//  TDTodoSection.h
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDTodoItem.h"

@interface TDTodoSection : NSObject

/**
 The title of the section
 */
@property (nonatomic) NSString *title;
/**
 The items associated with the Todo List
 */
@property (nonatomic) NSArray<TDTodoItem *> *todoItems;
- (instancetype)initWithTitle:(NSString *)title
                        items:(NSArray<TDTodoItem *> *)items;

@end
