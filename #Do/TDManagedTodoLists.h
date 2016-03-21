//
//  TDFetchedTodoLists.h
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ModelProtocols.h"

@interface TDManagedTodoLists : NSManagedObject <TDMutableModelCollection, TDTodoSectionList>

@end

@interface TDManagedTodoLists (CoreDataGeneratedAccessors)

- (void)insertObject:(id)value
       inListAtIndex:(NSUInteger)idx;
- (void)removeObjectFromListAtIndex:(NSUInteger)idx;
- (void)insertList:(NSArray *)value
              atIndexes:(NSIndexSet *)indexes;
- (void)removeListAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInListAtIndex:(NSUInteger)idx
                             withObject:(id)value;
- (void)replaceListAtIndexes:(NSIndexSet *)indexes
                    withList:(NSArray *)values;
- (void)addListObject:(id)value;
- (void)removeListObject:(id)value;
- (void)addList:(NSOrderedSet *)values;
- (void)removeList:(NSOrderedSet *)values;

@end
