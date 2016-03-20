//
//  TDTodoItem.h
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDTodoItem : NSObject

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
- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title
              descriptionText:(NSAttributedString *)descriptionText;
- (instancetype)initWithTitle:(NSString *)title
              descriptionText:(NSAttributedString *)descriptionText
                       isDone:(BOOL)isDone;

@end
