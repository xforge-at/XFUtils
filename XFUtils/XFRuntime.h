//
//  XFRuntime.h
//  XFDebugMenu
//
//  Created by Manu Wallner on 27/10/13.
//  Copyright (c) 2013 XForge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFProperty.h"
#import "XFMethod.h"
#import "XFClass.h"
#import "XFVariable.h"

@interface XFRuntime : NSObject

+ (instancetype)sharedRuntime;
- (NSArray *)classes;

@end
