//
//  TDManagedTodoSection.h
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TDManagedTodoItem.h"
#import "ModelProtocols.h"

@interface TDManagedTodoSection : NSManagedObject <TDTodoSection>

@end

@interface TDManagedTodoSection (CoreDataGeneratedAccessors)

- (void)insertObject:(id)value
   inTodoItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTodoItemsAtIndex:(NSUInteger)idx;
- (void)insertTodoItems:(NSArray *)value
              atIndexes:(NSIndexSet *)indexes;
- (void)removeTodoItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTodoItemsAtIndex:(NSUInteger)idx
                             withObject:(id)value;
- (void)replaceTodoItemsAtIndexes:(NSIndexSet *)indexes
                    withTodoItems:(NSArray *)values;
- (void)addTodoItemsObject:(id)value;
- (void)removeTodoItemsObject:(id)value;
- (void)addTodoItems:(NSOrderedSet *)values;
- (void)removeTodoItems:(NSOrderedSet *)values;

@end
