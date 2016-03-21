//
//  TDManagedTodoItem.h
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ModelProtocols.h"

@interface TDManagedTodoItem : NSManagedObject <TDTodoItem>

@end

@interface TDManagedTodoItem (CoreDataGeneratedAccessors)

- (void)insertObject:(id)value
  inSectionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSectionsAtIndex:(NSUInteger)idx;
- (void)insertSections:(NSArray *)value
              atIndexes:(NSIndexSet *)indexes;
- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSectionsAtIndex:(NSUInteger)idx
                             withObject:(id)value;
- (void)replaceSectionsAtIndexes:(NSIndexSet *)indexes
                    withSections:(NSArray *)values;
- (void)addSectionsObject:(id)value;
- (void)removeSectionsObject:(id)value;
- (void)addSections:(NSOrderedSet *)values;
- (void)removeSections:(NSOrderedSet *)values;


@end
