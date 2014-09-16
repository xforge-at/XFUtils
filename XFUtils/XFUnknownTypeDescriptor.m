//
//  XFUnknownTypeDescriptor.m
//  XFDebugMenu
//
//  Created by Manu Wallner on 11/11/13.
//  Copyright (c) 2013 XForge. All rights reserved.
//

#import "XFUnknownTypeDescriptor.h"

@implementation XFUnknownTypeDescriptor

+ (BOOL)isValidEncodingForDescriptor:(NSString *)encoding {
    return YES;
}

- (instancetype)initWithEncoding:(NSString *)encoding {
    self = super.init;
    if (self) {
        _encoding = encoding;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"(unknown type(%@))", _encoding ];
}

@end
