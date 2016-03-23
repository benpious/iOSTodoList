//
//  TDPullDownResponder.h
//  #Do
//
//  Created by Benjamin Pious on 3/21/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TDPullDownSelection) {
  TDPullDownSelectionNone = 0,
  TDPullDownSelectionAddNew = 1,
  TDPullDownSelectionGoBack = 2,
  TDPullDownSelectionGoToOptions = 3,
};

@protocol TDPullDownResponder <NSObject>

- (void)userSelectedPullDownOption:(TDPullDownSelection)selection;

@end
