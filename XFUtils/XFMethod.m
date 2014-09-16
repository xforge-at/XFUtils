//
//  XFMethod.m
//  XFDebugMenu
//
//  Created by Manu Wallner on 27/10/13.
//  Copyright (c) 2013 XForge. All rights reserved.
//

#import "XFMethod.h"
#import "XFClass.h"
#import "XFTypeDescriptor.h"

@implementation XFMethod

+ (instancetype)methodWithClass:(XFClass *)class andPrimitiveMethod:(Method)method {
    return [[self alloc] initWithClass:class andPrimitiveMethod:method];
}

- (instancetype)initWithClass:(XFClass *)class andPrimitiveMethod:(Method)method {
    self = super.init;
    if (self) {
        _class = class;
        _method = method;
        [self prepareArgumentEncodings];
    }
    return self;
}

- (void)prepareArgumentEncodings {
    uint argumentCount = method_getNumberOfArguments(_method);
    NSMutableArray *argumentTypes = [NSMutableArray arrayWithCapacity:argumentCount];
    
    for (int i = 0; i < argumentCount; i++) {
        char argTypeBuffer[64];
        method_getArgumentType(_method, i, argTypeBuffer, 64);
        NSString *argTypeString = [NSString stringWithUTF8String:argTypeBuffer];
        XFTypeDescriptor *typeDescriptor = [XFTypeDescriptor typeDescriptorWithEncoding:argTypeString];
        [argumentTypes addObject:typeDescriptor];
    }
    
    _argumentTypes = argumentTypes.copy;
}

- (NSInvocation *)invocationForObject:(id)object {
    if(![object isKindOfClass:NSClassFromString([self.class className])]) {
        @throw [NSException exceptionWithName:@"ClassMismatchException" reason:@"The class of the object passed is different to the method's class" userInfo:nil];
    }
    const char * types = method_getTypeEncoding(_method);
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:types];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = object;
    invocation.selector = method_getName(_method);
    return invocation;
}

- (NSString *)description {
    NSMutableString *methodString = [NSMutableString stringWithString:NSStringFromSelector(method_getName(_method))];
    NSScanner *scanner = [NSScanner scannerWithString:methodString];
    uint offset = 0;
    uint argIdx = 2; //skip CMD and self
    
    while ([scanner scanUpToString:@":" intoString:nil]) {
        if([scanner scanString:@":" intoString:nil]) {
            XFTypeDescriptor *type = _argumentTypes[argIdx];
            NSString *typeString = [NSString stringWithFormat:@"(%@) ", type.description];
            [methodString insertString:typeString atIndex:[scanner scanLocation]+offset];
            offset += typeString.length;
        }
        argIdx++;
    }
    
    methodString = [methodString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].mutableCopy;
    
    return [NSString stringWithFormat:@"[%@ %@]", _class, methodString];
}

@end