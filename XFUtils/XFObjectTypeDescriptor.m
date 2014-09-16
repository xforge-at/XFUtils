//
//  XFObjectTypeDescriptor.m
//  XFDebugMenu
//
//  Created by Manu Wallner on 10/11/13.
//  Copyright (c) 2013 XForge. All rights reserved.
//

#import "XFObjectTypeDescriptor.h"

@implementation XFObjectTypeDescriptor

+ (BOOL)isValidEncodingForDescriptor:(NSString *)encoding {
    return [encoding hasPrefix:@"@"];
}

- (instancetype)initWithEncoding:(NSString *)encoding {
    self = super.init;
    if (self) {
        if ([encoding isEqualToString:@"@"]) {
            _objectClassName = @"id";
            _isId = YES;
        } else {
            //ugly but quickest way to do this
            _objectClassName = [encoding substringWithRange:NSMakeRange(2, encoding.length-3)];
            _isId = NO;
        }
        if ([_objectClassName hasPrefix:@"<"] && [_objectClassName hasSuffix:@">"]) {
            _hasProtocol = YES;
            _isId = YES;
            _objectClassName = [_objectClassName substringWithRange:NSMakeRange(1, _objectClassName.length-2)];
        }
        
    }
    return self;
}

- (instancetype)initWithClassName:(NSString *)className {
    self = super.init;
    if (self) {
        _isId = NO;
        _hasProtocol = NO;
        _objectClassName = className;
    }
    return self;
}

- (instancetype)initAsID {
    self = super.init;
    if (self) {
        _isId = YES;
        _hasProtocol = NO;
        _objectClassName = @"id";
    }
    return self;
}

- (instancetype)initAsIDWithProtocol:(NSString *)protocol {
    self = super.init;
    if (self) {
        _isId = YES;
        _hasProtocol = YES;
        _objectClassName = [NSString stringWithFormat:@"id<%@>",protocol];
    }
    return self;
    
}

- (NSString *)description {
    if (_hasProtocol) return [NSString stringWithFormat:@"id<%@>", _objectClassName];
    if (_isId) return @"id";
    return [_objectClassName stringByAppendingString:@" *"];
}

- (BOOL)isEqual:(id)object {
    if(![object isKindOfClass:self.class]) return NO;
    XFObjectTypeDescriptor *otherType = (XFObjectTypeDescriptor *)object;
    return [otherType.objectClassName isEqual:_objectClassName] && otherType.isId == _isId && self.hasProtocol == otherType.hasProtocol;
}

@end
