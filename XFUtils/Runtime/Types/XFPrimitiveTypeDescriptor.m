//
//  XFPrimitiveTypeDescriptor.m
//  XFUtils
//
//  Created by Manu Wallner on 10/11/13.
//  Copyright (c) 2013 XForge Software Development GmbH. All rights reserved.
//

#import "XFPrimitiveTypeDescriptor.h"

@implementation XFPrimitiveTypeDescriptor

+ (BOOL)isValidEncodingForDescriptor:(NSString *)encoding {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[cislqfdbv\\:\\*]$" options:NSRegularExpressionCaseInsensitive error:nil];
    return [regex numberOfMatchesInString:encoding options:0 range:NSMakeRange(0, encoding.length)] > 0;
}

- (instancetype)initWithEncoding:(NSString *)encoding {
    self = [super init];
    if (self) {
        [self parseEncoding:encoding];
    }
    return self;
}

- (instancetype)initWithType:(XFPrimitiveType)type isUnsigned:(BOOL)unsign {
    self = super.init;
    if (self) {
        _type = type;
        _unsign = unsign;
    }
    return self;
}

- (void)parseEncoding:(NSString *)encoding {
    NSScanner *scanner = [NSScanner scannerWithString:encoding];
    NSString *actualType;
    [scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:&actualType];
    if (!actualType) {
        [scanner scanCharactersFromSet:[NSCharacterSet punctuationCharacterSet] intoString:&actualType];
    }

    switch ([actualType characterAtIndex:0]) {
        case 'C':
            _unsign = YES;
        case 'c':
            _type = XFPrimitiveTypeChar;
            break;
        case 'I':
            _unsign = YES;
        case 'i':
            _type = XFPrimitiveTypeInt;
            break;
        case 'S':
            _unsign = YES;
        case 's':
            _type = XFPrimitiveTypeShort;
            break;
        case 'L':
            _unsign = YES;
        case 'l':
            _type = XFPrimitiveTypeLong;
            break;
        case 'Q':
            _unsign = YES;
        case 'q':
            _type = XFPrimitiveTypeLongLong;
            break;
        case 'f':
            _type = XFPrimitiveTypeFloat;
            break;
        case 'd':
            _type = XFPrimitiveTypeDouble;
            break;
        case 'B':
            _type = XFPrimitiveTypeBool;
            break;
        case 'v':
            _type = XFPrimitiveTypeVoid;
            break;
        case ':':
            _type = XFPrimitiveTypeSelector;
            break;
        case '*':
            _type = XFPrimitiveTypeString;
            break;
        default:
            @throw [NSException exceptionWithName:@"UnsupportedEncodingException" reason:@"This is probably an unsupported encoding" userInfo:nil];
    }
}

- (NSString *)description {
    NSMutableString *descrString = [@"" mutableCopy];

    if (self.isUnsigned) [descrString appendString:@"unsigned "];

    switch (_type) {
        case XFPrimitiveTypeInt:
            [descrString appendString:@"int"];
            break;
        case XFPrimitiveTypeBool:
            [descrString appendString:@"bool"];
            break;
        case XFPrimitiveTypeChar:
            [descrString appendString:@"char"];
            break;
        case XFPrimitiveTypeLong:
            [descrString appendString:@"long"];
            break;
        case XFPrimitiveTypeVoid:
            [descrString appendString:@"void"];
            break;
        case XFPrimitiveTypeDouble:
            [descrString appendString:@"double"];
            break;
        case XFPrimitiveTypeFloat:
            [descrString appendString:@"float"];
            break;
        case XFPrimitiveTypeShort:
            [descrString appendString:@"short"];
            break;
        case XFPrimitiveTypeString:
            [descrString appendString:@"char *"];
            break;
        case XFPrimitiveTypeLongLong:
            [descrString appendString:@"long long"];
            break;
        case XFPrimitiveTypeSelector:
            [descrString appendString:@"SEL"];
            break;
    }

    return [descrString copy];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:self.class]) return NO;
    XFPrimitiveTypeDescriptor *otherType = (XFPrimitiveTypeDescriptor *)object;
    return otherType.unsign == self.unsign && otherType.type == self.type;
}

- (BOOL)isPrimitiveType {
    return YES;
}

@end
