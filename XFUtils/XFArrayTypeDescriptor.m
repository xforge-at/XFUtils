//
//  XFArrayTypeDescriptor.m
//  XFDebugMenu
//
//  Created by Manu Wallner on 10/11/13.
//  Copyright (c) 2013 XForge. All rights reserved.
//

#import "XFArrayTypeDescriptor.h"

@implementation XFArrayTypeDescriptor

+ (BOOL)isValidEncodingForDescriptor:(NSString *)encoding {
    //either num,ptr,type or [num,type]
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([0-9]+\\^|\\[[0-9]+[a-zA-Z]\\])" options:0 error:nil];
    return [regex numberOfMatchesInString:encoding options:0 range:NSMakeRange(0, encoding.length)];
}

- (instancetype)initWithEncoding:(NSString *)encoding {
    self = super.init;
    if (self) {
        [self parseEncoding:encoding];
    }
    return self;
}

- (void)parseEncoding:(NSString *)encoding {
    NSScanner *scanner = [NSScanner scannerWithString:encoding];
    [scanner scanString:@"[" intoString:nil];
    int numElements;
    if(![scanner scanInt:&numElements]) {
        @throw [NSException exceptionWithName:@"TypeParseException" reason:@"This seems to be an array type, but doesn't contain the number of elements..." userInfo:nil];
    }
    _numberOfElements = numElements;
    [scanner scanString:@"^" intoString:nil];
    
    NSString *innerEncoding = [encoding substringFromIndex:scanner.scanLocation];
    if ([innerEncoding hasSuffix:@"]"]) {
        innerEncoding = [innerEncoding substringToIndex:innerEncoding.length-1];
    }
    _innerTypeDescriptor = [XFTypeDescriptor typeDescriptorWithEncoding:innerEncoding];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@[%i]", _innerTypeDescriptor.description, _numberOfElements];
}

- (BOOL)isEqual:(id)object {
    if(![object isKindOfClass:self.class]) return NO;
    XFArrayTypeDescriptor *otherType = (XFArrayTypeDescriptor *)object;
    return otherType.numberOfElements == self.numberOfElements && [otherType.innerTypeDescriptor isEqual:self.innerTypeDescriptor];
}

- (BOOL)isArray {
    return YES;
}

@end
