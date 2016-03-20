//
//  CGGeometry+DoApp.c
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#include "CGGeometry+DoApp.h"

CGPoint td_CGRectGetCenter(CGRect r) {
  return CGPointMake(r.origin.x + r.size.width / 2,
                     r.origin.y + r.size.height / 2);
}