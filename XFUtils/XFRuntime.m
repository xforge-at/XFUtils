//
//  XFRuntime.m
//  XFDebugMenu
//
//  Created by Manu Wallner on 27/10/13.
//  Copyright (c) 2013 XForge. All rights reserved.
//

#import "XFRuntime.h"
#import <objc/objc.h>
#import <objc/runtime.h>

@implementation XFRuntime {
    void *_classesMemory;
}

static XFRuntime *_sharedRuntime = nil;
+ (instancetype)sharedRuntime {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedRuntime = [XFRuntime new];
    });
    return _sharedRuntime;
}

- (NSArray *)classes {
    NSMutableArray *returnArray = [NSMutableArray new];
    
    int numClasses;
    Class *classes = NULL;
    
    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    NSLog(@"Number of classes: %d", numClasses);
    
    if (numClasses > 0 )
    {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i++) {
            NSString *className = NSStringFromClass(classes[i]);
            if(className) [returnArray addObject:[XFClass classWithClassName:className]];
        }
        _classesMemory = classes;
    }
    
    return returnArray.copy;
}

- (void)dealloc {
    free(_classesMemory);
}

@end
