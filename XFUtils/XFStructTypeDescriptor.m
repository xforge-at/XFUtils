//
//  XFStructTypeDescriptor.m
//  XFDebugMenu
//
//  Created by Manu Wallner on 10/11/13.
//  Copyright (c) 2013 XForge. All rights reserved.
//

#import "XFStructTypeDescriptor.h"

@implementation XFStructTypeDescriptor

+ (BOOL)isValidEncodingForDescriptor:(NSString *)encoding {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\{.*\\}$" options:0 error:nil];
    return [regex numberOfMatchesInString:encoding options:0 range:NSMakeRange(0, encoding.length)] > 0;
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
    [scanner scanString:@"{" intoString:nil];
    NSString *name;
    if([scanner scanUpToString:@"=" intoString:&name]) { }
    else if([scanner scanUpToString:@"}" intoString:&name]) { return; }
    _structName = name;
    //TODO: Get types of struct member variables
}

- (NSString *)description {
    return _structName;
}

- (BOOL)isEqual:(id)object {
    if(![object isKindOfClass:self.class]) return NO;
    XFStructTypeDescriptor *otherType = (XFStructTypeDescriptor *)object;
    return [otherType.structName isEqual:self.structName];
}

@end
