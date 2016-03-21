//
//  TDResult.m
//  #Do
//
//  Created by Benjamin Pious on 3/20/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDResult.h"

@interface TDResultSuccess : TDResult

@property (nonatomic) id result;

@end

@interface TDResultError : TDResult

@property (nonatomic) NSError *error;

@end

@implementation TDResult

- (instancetype)initWithResult:(id)result {
  return [[TDResultSuccess alloc] initWithResult:result];
}

- (instancetype)initWithError:(NSError *)error {
  return [[TDResultError alloc] initWithError:error];
}

- (void)succeed:(void(^)(id))__unused success
           fail:(void(^)(NSError *error))__unused fail {
  @throw [NSException exceptionWithName:@"Abstract class method called"
                                 reason:@"This class is abstract"
                               userInfo:nil];
}

@end

@implementation TDResultSuccess

- (instancetype)initWithResult:(id)result {
  if (self = [super init]) {
    self.result = result;
  }
  return self;
}

- (void)succeed:(void (^)(id))success
           fail:(void (^)(NSError *))__unused fail {
  if (success) {
    success(self.result);
  }
}

@end

@implementation TDResultError

- (instancetype)initWithError:(NSError *)error {
  if (self = [super init]) {
    self.error = error;
  }
  return self;
}

- (void)succeed:(void (^)(id))__unused success
           fail:(void (^)(NSError *))fail {
  if (fail) {
    fail(self.error);
  }
}

@end
