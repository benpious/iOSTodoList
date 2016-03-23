//
//  TDPersistentStore.h
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDManagedTodoLists.h"

@interface TDPersistentStore : NSObject

- (instancetype)initWithStoreURL:(NSURL *)storeLocation;
- (instancetype)initWithBuiltinStore;
- (NSError *)writeToDisk;
+ (NSURL *)builtInPersistenceURL;
@property (nonatomic) TDManagedTodoLists *lists;

@end
