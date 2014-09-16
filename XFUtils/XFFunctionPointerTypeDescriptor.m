//
//  XFFunctionPointerTypeDescriptor.m
//  XFDebugMenu
//
//  Created by Manu Wallner on 10/11/13.
//  Copyright (c) 2013 XForge. All rights reserved.
//

#import "XFFunctionPointerTypeDescriptor.h"

@implementation XFFunctionPointerTypeDescriptor

+ (BOOL)isValidEncodingForDescriptor:(NSString *)encoding {
    return [encoding hasPrefix:@"^?"];
}

- (instancetype)initWithEncoding:(NSString *)encoding {
    self = super.init;
    if (self) {
        //TODO: find out what the exact encoding for a function pointer is, as there is no info on the apple docs
        NSLog(@"encoding %@", encoding);
        _encoding = encoding;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    return [[self encoding] isEqual:[object encoding]];
}

- (NSString *)description {
    return _encoding;
}

@end
