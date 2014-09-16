//
//  XFProperty.h
//  XFDebugMenu
//
//  Created by Manu Wallner on 28/10/13.
//  Copyright (c) 2013 XForge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@class XFVariable;
@class XFTypeDescriptor;

@interface XFProperty : NSObject

+ (instancetype)propertyWithPrimitive:(objc_property_t)property;

- (id)valueForObject:(id)object;
- (void)setValue:(id)value forObject:(id)object;

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *customGetterName;
@property (nonatomic, strong, readonly) NSString *customSetterName;
@property (nonatomic, strong, readonly) XFTypeDescriptor *typeDescriptor;

@property (getter = isReadOnly, readonly) BOOL readOnly;
@property (getter = isCopied, readonly) BOOL copied;
@property (getter = isNonAtomic, readonly) BOOL nonAtomic;
@property (getter = isReferenced, readonly) BOOL referenced;
@property (getter = isDynamic, readonly) BOOL dynamic;
@property (getter = isWeak, readonly) BOOL weak;
@property (getter = isGarbageCollected, readonly) BOOL garbageCollected;


@end
