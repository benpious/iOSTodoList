//
//  TDPersistentStore.m
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDPersistentStore.h"
#import "TDManagedTodoItem.h"
#import "TDManagedTodoSection.h"
#import "TDManagedTodoLists.h"
#import "NSManagedObjectModel+KCOrderedAccessorFix.h"
#import <CoreData/CoreData.h>

#pragma mark - Extension

@interface TDPersistentStore ()

#pragma mark - Core Data Stack
@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic) NSManagedObjectModel *model;
@property (nonatomic) NSPersistentStore *store;
#pragma mark - Entity Descriptions
@property (nonatomic) NSEntityDescription *todoDescription;
@property (nonatomic) NSEntityDescription *sectionDescription;
@property (nonatomic) NSEntityDescription *sectionListDescription;
#pragma mark - Other
@property (nonatomic) NSURL *persistenceURL;

@end

@implementation TDPersistentStore

#pragma mark - initializers

- (instancetype)initWithBuiltinStore {
  if (self = [self initWithStoreURL:self.class.builtInPersistenceURL]) {
    
  }
  return self;
}

- (instancetype)initWithStoreURL:(NSURL *)storeLocation {
  if (self = [super init]) {
//#warning delete from this
//    [[NSFileManager defaultManager] removeItemAtURL:storeLocation
//                                              error:nil]; /* FOR TESTING */
//#warning to this
    self.persistenceURL = storeLocation;
    [self setUpCoreData];
    self.lists = [self sectionListFromDatabase];
  }
  return self;
}

#pragma mark - setup

- (void)setUpCoreData {
  self.model = [self createManagedObjectModel];
  [self.model kc_generateOrderedSetAccessors];
  NSArray *coordinatorAndStore = [self createPersistentStoreWithManagedObjectModel:self.model];
  self.coordinator = coordinatorAndStore[0];
  self.store = coordinatorAndStore[1];
  self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  self.context.persistentStoreCoordinator = self.coordinator;
}

- (NSArray *)createPersistentStoreWithManagedObjectModel:(NSManagedObjectModel *)model {
  NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
  NSError *error = nil;
  NSPersistentStore *store = [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                            configuration:nil
                                                                      URL:self.persistenceURL
                                                                  options:@{}
                                                                    error:&error];
  if (error) {
    /* TODO: handle the error */
  }
  return @[storeCoordinator, store];
}

+ (NSURL *)builtInPersistenceURL {
  NSURL *documentDirectory = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                    inDomains:NSUserDomainMask].firstObject;
  return [documentDirectory URLByAppendingPathComponent:@"todoListModelDatabase.sqlite"];
}

- (NSManagedObjectModel *)createManagedObjectModel {
  NSManagedObjectModel *model = [[NSManagedObjectModel alloc] init];
  /* Todo Item */
  NSEntityDescription *todoItem = [[NSEntityDescription alloc] init];
  NSEntityDescription *todoSection = [[NSEntityDescription alloc] init];
  todoItem.name = @"TodoItem";
  todoItem.managedObjectClassName = NSStringFromClass([TDManagedTodoItem class]);
  NSAttributeDescription *todoItemTitle = [[NSAttributeDescription alloc] init];
  todoItemTitle.attributeType = NSStringAttributeType;
  todoItemTitle.name = NSStringFromSelector(@selector(title));
  todoItemTitle.indexed = YES;
  NSAttributeDescription *todoItemIsDone = [[NSAttributeDescription alloc] init];
  todoItemIsDone.name = NSStringFromSelector(@selector(isDone));
  todoItemIsDone.attributeType = NSBooleanAttributeType;
  todoItemIsDone.defaultValue = @(NO);
  NSRelationshipDescription *memberSections = [[NSRelationshipDescription alloc] init];
  memberSections.name = NSStringFromSelector(@selector(sections));
  memberSections.destinationEntity = todoSection;
  memberSections.ordered = YES;
  memberSections.minCount = 0;
  memberSections.maxCount = 0;
  todoItem.properties = @[todoItemTitle, todoItemIsDone, memberSections];
  /* Todo Section */
  todoSection.name = @"TodoSection";
  todoSection.managedObjectClassName = NSStringFromClass([TDManagedTodoSection class]);
  NSRelationshipDescription *sectionToItems = [[NSRelationshipDescription alloc] init];
  sectionToItems.name = NSStringFromSelector(@selector(todoItems));
  sectionToItems.destinationEntity = todoItem;
  sectionToItems.ordered = YES;
  sectionToItems.minCount = 0;
  sectionToItems.maxCount = 0;
  memberSections.inverseRelationship = sectionToItems;
  sectionToItems.inverseRelationship = memberSections;
  NSAttributeDescription *todoSectionTitle = [[NSAttributeDescription alloc] init];
  todoSectionTitle.attributeType = NSStringAttributeType;
  todoSectionTitle.name = NSStringFromSelector(@selector(title));
  todoSection.properties = @[sectionToItems, todoSectionTitle];
  /* List of Sections */
  NSEntityDescription *listOfSections = [[NSEntityDescription alloc] init];
  listOfSections.name = @"ListOfSections";
  listOfSections.managedObjectClassName = NSStringFromClass([TDManagedTodoLists class]);
  NSRelationshipDescription *listToSectionsRelation = [[NSRelationshipDescription alloc] init];
  listToSectionsRelation.name = NSStringFromSelector(@selector(list));
  listToSectionsRelation.destinationEntity = todoSection;
  listToSectionsRelation.ordered = YES;
  listToSectionsRelation.minCount = 0;
  listToSectionsRelation.maxCount = 0;
  listOfSections.properties = @[listToSectionsRelation];
  model.entities = @[todoItem, todoSection, listOfSections];
  self.todoDescription = todoItem;
  self.sectionDescription = todoSection;
  self.sectionListDescription = listOfSections;
  return model;
}

#pragma mark - fetching

- (NSFetchedResultsController *)controllerForRequestWithEntityName:(NSString *)name
                                                             setup:(void(^)(NSFetchRequest *))setup {
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:name];
  NSFetchedResultsController *requestController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                      managedObjectContext:self.context
                                                                                        sectionNameKeyPath:nil
                                                                                                 cacheName:nil];
  if (setup) {
    setup(request);
  }
  NSError *error = nil;
  [requestController performFetch:&error];
  return requestController;
}

- (TDManagedTodoLists *)sectionListFromDatabase {
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.sectionListDescription.name];
  NSError *e = nil;
  TDManagedTodoLists *lists = [self.context executeFetchRequest:request
                                                          error:&e].firstObject;
  if (!lists &&
      !e) {
    lists = [[TDManagedTodoLists alloc] initWithEntity:self.sectionListDescription
                        insertIntoManagedObjectContext:self.context];
    //for testing
    TDManagedTodoSection *section = [[TDManagedTodoSection alloc] initWithEntity:self.sectionDescription
                                                  insertIntoManagedObjectContext:self.context];
    section.title = @"Test Section";
    TDManagedTodoItem *todoItem = [[TDManagedTodoItem alloc] initWithEntity:self.todoDescription
                                             insertIntoManagedObjectContext:self.context];
    todoItem.title = @"Item Title";
    [section addTodoItemsObject:todoItem];
    [lists addListObject:section];
  }
  else if (e) {
    /* TODO: handle the error */
  }
  return lists;
}

- (NSFetchedResultsController *)todoItemsInSection:(TDManagedTodoSection *)section {
  return [self controllerForRequestWithEntityName:self.todoDescription.name setup:^(NSFetchRequest *request) {
    request.predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject,
                                                              NSDictionary<NSString *,id> * __unused bindings) {
      return [[evaluatedObject tags] containsObject:section.title];
    }];
  }];
}

- (NSError *)writeToDisk {
  NSError *e = nil;
  [self.context save:&e];
  return e;
}

@end
