//
//  TDManagedTodoSection.m
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDManagedTodoSection.h"
#import "TDManagedTodoItem.h"

@implementation TDManagedTodoSection
@dynamic title, todoItems;

- (void)pushNewItem {
  NSEntityDescription *entityDescription = self.managedObjectContext.persistentStoreCoordinator.managedObjectModel.entitiesByName[@"TodoItem"];
  TDManagedTodoItem *item = [[TDManagedTodoItem alloc] initWithEntity:entityDescription
                                       insertIntoManagedObjectContext:self.managedObjectContext];
  [self insertObject:item
  inTodoItemsAtIndex:0];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
  return self.todoItems[idx];
}

- (void)removeItemAtIndex:(NSUInteger)index {
  [self removeTodoItemsObject:self.todoItems[index]];
}

- (void)setObject:(id)obj
          atIndex:(NSUInteger)idx {
  [self insertObject:obj
  inTodoItemsAtIndex:idx];
}

- (void)exchangeItemAtIndex:(NSUInteger)index
            withItemAtIndex:(NSUInteger)otherIndex {
  NSMutableIndexSet *indices = [NSMutableIndexSet indexSet];
  [indices addIndex:index];
  [indices addIndex:otherIndex];
  [self replaceTodoItemsAtIndexes:indices
                    withTodoItems:@[self.todoItems[index], self.todoItems[otherIndex]]];
}

@end
