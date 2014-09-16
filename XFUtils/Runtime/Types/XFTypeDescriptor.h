//
//  XFTypeDescriptor.h
//  XFUtils
//
//  Created by Manu Wallner on 10/11/13.
//  Copyright (c) 2013 XForge Software Development GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XFTypeMaker;

@interface XFTypeDescriptor : NSObject

+ (BOOL)isValidEncodingForDescriptor:(NSString *)encoding;
+ (instancetype)typeDescriptorWithEncoding:(NSString *)encoding;

- (instancetype)initWithEncoding:(NSString *)encoding;
- (BOOL)isPrimitiveType;
- (BOOL)isPointer;
- (BOOL)isArray;
- (instancetype)innerTypeDescriptor;

@end
