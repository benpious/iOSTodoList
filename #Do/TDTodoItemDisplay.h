//
//  TDTodoItemDisplay.h
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TDTodoItemDisplay <NSObject>

@property (nonatomic) NSString *title;
@property (nonatomic) NSAttributedString *descriptionText;
@property (nonatomic) BOOL isDone;
@property (nonatomic) BOOL isExpanded;

@end
