//
//  TDTodoSectionList.h
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDTodoSection.h"

@interface TDTodoSectionList : NSObject

/**
 The list of all the sections in the list
 */
@property (nonatomic) NSArray<TDTodoSection *> *list;
- (instancetype)initWithList:(NSArray<TDTodoSection *> *)list;


@end
