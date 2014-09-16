//
//  XFProperty.m
//  XFDebugMenu
//
//  Created by Manu Wallner on 28/10/13.
//  Copyright (c) 2013 XForge. All rights reserved.
//

#import "XFProperty.h"
#import "XFVariable.h"
#import "XFTypeDescriptor.h"

typedef NS_OPTIONS(uint, XFPropertyTypeAttribute) {
    XFPropertyTypeAttributeReadonly = 1 << 0,
    XFPropertyTypeAttributeCopy = 1 << 1,
    XFPropertyTypeAttributeReference = 1 << 2,
    XFPropertyTypeAttributeNonAtomic = 1 << 3,
    XFPropertyTypeAttributeDynamic = 1 << 4,
    XFPropertyTypeAttributeWeak = 1 << 5,
    XFPropertyTypeAttributeGarbageCollected = 1 << 6,
};

@interface XFProperty ()
@property (nonatomic, readonly) objc_property_t property;
@property (nonatomic) XFPropertyTypeAttribute attributes;
@end

@implementation XFProperty

+ (instancetype)propertyWithPrimitive:(objc_property_t)property {
    return [[XFProperty alloc] initWithPrimitive:property];
}

- (instancetype)initWithPrimitive:(objc_property_t)property {
    self = super.init;
    if (self) {
        _property = property;
        _name = @(property_getName(_property));
        [self parseAttributes:property_getAttributes(_property)];
    }
    return self;
}

- (void)parseAttributes:(const char *)attr {
    _attributes = 0;
    NSString *attributesString = [NSString stringWithUTF8String:attr];
    NSScanner *scanner = [NSScanner scannerWithString:attributesString];
    
    NSCharacterSet *seperatorSet = [NSCharacterSet characterSetWithCharactersInString:@","];
    
    //see #//apple_ref/doc/uid/TP40008048-CH101
    NSString *modifierString = @"RC&NGSDWP";
    NSCharacterSet *modifierSet = [NSCharacterSet characterSetWithCharactersInString:modifierString];
    
    //T is always the first character
    [scanner scanString:@"T" intoString:nil];
    NSString *type;
    [scanner scanUpToCharactersFromSet:seperatorSet intoString:&type];
    _typeDescriptor = [XFTypeDescriptor typeDescriptorWithEncoding:type];
    
    [scanner scanCharactersFromSet:seperatorSet intoString:nil];
    while (![scanner scanString:@"V" intoString:nil] && !scanner.isAtEnd) {
        NSString *modifierString, *modifierType;
        [scanner scanCharactersFromSet:modifierSet intoString:&modifierType];
        [scanner scanUpToCharactersFromSet:seperatorSet intoString:&modifierString];
        [scanner scanCharactersFromSet:seperatorSet intoString:nil];
        [self addModifier:modifierString ofType:modifierType];
    }
}

- (void)addModifier:(NSString *)modifierString ofType:(NSString *)modifierType{
    if ([modifierType isEqualToString:@"R"]) {
        _attributes |= XFPropertyTypeAttributeReadonly;
    } else if([modifierType isEqualToString:@"C"]) {
        _attributes |= XFPropertyTypeAttributeCopy;
    } else if([modifierType isEqualToString:@"&"]) {
        _attributes |= XFPropertyTypeAttributeReference;
    } else if([modifierType isEqualToString:@"N"]) {
        _attributes |= XFPropertyTypeAttributeNonAtomic;
    } else if([modifierType isEqualToString:@"D"]) {
        _attributes |= XFPropertyTypeAttributeDynamic;
    } else if([modifierType isEqualToString:@"W"]) {
        _attributes |= XFPropertyTypeAttributeWeak;
    } else if([modifierType isEqualToString:@"P"]) {
        _attributes |= XFPropertyTypeAttributeGarbageCollected;
    } else if([modifierType isEqualToString:@"G"]) {
        _customGetterName = modifierString;
    } else if([modifierType isEqualToString:@"S"]) {
        _customSetterName = modifierString;
    }
}

- (NSString *)description {
    NSMutableString *descriptionString = [@"" mutableCopy];
    /*
    [descriptionString appendString:@"("];
    if(self.isReadOnly) [descriptionString appendString:@"readonly, "];
    if(self.isCopied) [descriptionString appendString:@"copy, "];
    if(self.isNonAtomic) [descriptionString appendString:@"nonatomic, "];
    if(self.isWeak) [descriptionString appendString:@"weak, "];
    if(self.isReferenced) [descriptionString appendString:@"assign, "];
    if(self.customGetterName) [descriptionString appendFormat:@"getter = %@, ", self.customGetterName];
    if(self.customSetterName) [descriptionString appendFormat:@"getter = %@, ", self.customSetterName];
    
    if ([descriptionString hasSuffix:@", "]) {
        [descriptionString deleteCharactersInRange:NSMakeRange(descriptionString.length-2, 2)];
    }
    [descriptionString appendString:@") "];
    */
    if (_typeDescriptor) {
        [descriptionString appendFormat:@"%@ ", _typeDescriptor.description];
    }
    
    [descriptionString appendString:self.name];
    
    if ([descriptionString hasPrefix:@"() "]) {
        [descriptionString deleteCharactersInRange:NSMakeRange(0, 3)];
    }
    return [descriptionString copy];
}


- (id)valueForObject:(id)object {
    return [object objectForKey:_name];
}

- (void)setValue:(id)value forObject:(id)object {
    [object setObject:value forKey:_name];
}

#pragma mark - Properties

- (BOOL)isReadOnly {
    return (BOOL)(XFPropertyTypeAttributeReadonly & _attributes);
}

- (BOOL)isCopied {
    return (BOOL)(XFPropertyTypeAttributeCopy & _attributes);
}

- (BOOL)isNonAtomic {
    return (BOOL)(XFPropertyTypeAttributeNonAtomic & _attributes);
}

- (BOOL)isReferenced {
    return (BOOL)(XFPropertyTypeAttributeReference & _attributes);
}

- (BOOL)isDynamic {
    return (BOOL)(XFPropertyTypeAttributeDynamic & _attributes);
}

- (BOOL)isWeak {
    return (BOOL)(XFPropertyTypeAttributeWeak & _attributes);
}

- (BOOL)isGarbageCollected {
    return (BOOL)(XFPropertyTypeAttributeGarbageCollected & _attributes);
}

@end