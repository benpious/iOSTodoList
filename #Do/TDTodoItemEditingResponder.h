//
//  TDTodoItemEditingResponder.h
//  #Do
//
//  Created by Ben Pious on 3/22/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TDTodoItemEditingResponder <NSObject>

- (void)userFinishedEditingTodoItemTitle:(NSString *)title
                      forItemAtIndexPath:(NSIndexPath *)indexPath;

@end
