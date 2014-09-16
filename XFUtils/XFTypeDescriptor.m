//
//  XFTypeDescriptor.m
//  XFDebugMenu
//
//  Created by Manu Wallner on 10/11/13.
//  Copyright (c) 2013 XForge. All rights reserved.
//

#import "XFTypeDescriptor.h"
#import "XFPrimitiveTypeDescriptor.h"
#import "XFObjectTypeDescriptor.h"
#import "XFPointerTypeDescriptor.h"
#import "XFStructTypeDescriptor.h"
#import "XFFunctionPointerTypeDescriptor.h"
#import "XFArrayTypeDescriptor.h"
#import "XFUnknownTypeDescriptor.h"
#import "XFTypeMaker.h"

@implementation XFTypeDescriptor

+ (XFTypeMaker *)make {
    return [XFTypeMaker new];
}

+ (instancetype)typeDescriptorWithEncoding:(NSString *)encoding {
    NSArray *descriptors = @[
                             XFPrimitiveTypeDescriptor.class,
                             XFObjectTypeDescriptor.class,
                             XFStructTypeDescriptor.class,
                             XFArrayTypeDescriptor.class,
                             XFFunctionPointerTypeDescriptor.class,
                             XFPointerTypeDescriptor.class,
                             XFUnknownTypeDescriptor.class
                             ];
    
    for (Class descriptorClass in descriptors) {
        if([descriptorClass isValidEncodingForDescriptor:encoding])
            return [[descriptorClass alloc] initWithEncoding:encoding];
    }
    
    return nil;
}

+ (BOOL)isValidEncodingForDescriptor:(NSString *)encoding {
    return NO;
}

- (instancetype)initWithEncoding:(NSString *)encoding {
    return nil;
}

- (BOOL)isPrimitiveType {
    return NO;
}

- (BOOL)isPointer {
    return NO;
}

- (BOOL)isArray {
    return NO;
}

- (instancetype)innerTypeDescriptor {
    return nil;
}

@end
