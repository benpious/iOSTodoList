//
//  TDFetchedTodoLists.m
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDManagedTodoLists.h"
#import "TDManagedTodoSection.h"

@implementation TDManagedTodoLists
@dynamic list;

- (void)pushNewItem {
  NSEntityDescription *entityDescription = self.managedObjectContext.persistentStoreCoordinator.managedObjectModel.entitiesByName[@"TodoSection"];
  TDManagedTodoSection *item = [[TDManagedTodoSection alloc] initWithEntity:entityDescription
                                             insertIntoManagedObjectContext:self.managedObjectContext];
  [self insertObject:item
       inListAtIndex:0];
}

- (void)removeItemAtIndex:(NSUInteger)index {
  [self removeListAtIndexes:[NSIndexSet indexSetWithIndex:index]];
}

- (void)exchangeItemAtIndex:(NSUInteger)index
            withItemAtIndex:(NSUInteger)otherIndex {
  NSMutableIndexSet *indices = [NSMutableIndexSet indexSet];
  [indices addIndex:index];
  [indices addIndex:otherIndex];
  [self replaceListAtIndexes:indices
                    withList:@[self.list[index], self.list[otherIndex]]];
}

- (void)setObject:(id)obj
          atIndex:(NSUInteger)idx {
  [self insertObject:obj
       inListAtIndex:idx];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
  return self.list[idx];
}

@end
