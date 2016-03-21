//
//  TDResult.h
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDResult<__covariant T> : NSObject

- (instancetype)initWithResult:(T)result;
- (instancetype)initWithError:(NSError *)error;
- (void)succeed:(void(^)(T))success
           fail:(void(^)(NSError *error))fail;

@end
