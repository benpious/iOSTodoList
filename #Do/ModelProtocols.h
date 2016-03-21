//
//  ModelProtocols.h
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMutableModelCollection.h"

@protocol TDTodoSection;

#pragma mark - Item

@protocol TDTodoItem <NSObject>
/**
 The title of the item
 */
@property (nonatomic) NSString *title;
/**
 The description the user entered for the text
 */
@property (nonatomic) NSAttributedString *descriptionText;
/**
 If the item is marked as done or not
 */
@property (nonatomic) BOOL isDone;
/**
 The sections that the item is a member of
 */
@property (nonatomic) NSOrderedSet<id<TDTodoSection>> *sections;

@end

#pragma mark - Section

@protocol TDTodoSection <TDMutableModelCollection>

/**
 The title of the section
 */
@property (nonatomic) NSString *title;
/**
 The items associated with the Todo List
 */
@property (nonatomic) NSOrderedSet<id<TDTodoItem>> *todoItems;

@end

@protocol TDTodoSectionList <TDMutableModelCollection>

/**
 The list of all the sections in the list
 */
@property (nonatomic) NSOrderedSet<id<TDTodoSection>> *list;

@end
