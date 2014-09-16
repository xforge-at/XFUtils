//
//  XFClass.h
//  XFDebugMenu
//
//  Created by Manu Wallner on 27/10/13.
//  Copyright (c) 2013 XForge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFClass : NSObject

+ (instancetype)classWithClassName:(NSString *)cls;

@property (nonatomic, strong, readonly) NSString *className;
@property (nonatomic, strong, readonly) NSArray *instanceMethods;
@property (nonatomic, strong, readonly) NSArray *classMethods;
@property (nonatomic, strong, readonly) NSArray *properties;
@property (nonatomic, strong, readonly) NSArray *protocols;
@property (nonatomic, strong, readonly) NSArray *instanceVariables;
@property (nonatomic, weak, readonly) XFClass *superClass;

@end
