//
//  XFPointerTypeDescriptor.m
//  XFDebugMenu
//
//  Created by Manu Wallner on 10/11/13.
//  Copyright (c) 2013 XForge. All rights reserved.
//

#import "XFPointerTypeDescriptor.h"

@implementation XFPointerTypeDescriptor

+ (BOOL)isValidEncodingForDescriptor:(NSString *)encoding {
    return [encoding hasPrefix:@"^"];
}

- (instancetype)initWithEncoding:(NSString *)encoding {
    self = super.init;
    if (self) {
        NSString *innerEncoding = [encoding substringFromIndex:1];
        _innerTypeDescriptor = [XFTypeDescriptor typeDescriptorWithEncoding:innerEncoding];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@*", _innerTypeDescriptor.description];
}

- (BOOL)isEqual:(id)object {
    if(![object isKindOfClass:self.class]) return NO;
    XFPointerTypeDescriptor *otherType = (XFPointerTypeDescriptor *)object;
    return [otherType.innerTypeDescriptor isEqual:self.innerTypeDescriptor];
}

- (BOOL)isPointer {
    return YES;
}

@end
