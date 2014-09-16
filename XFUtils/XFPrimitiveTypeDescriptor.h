//
//  XFPrimitiveTypeDescriptor.h
//  XFDebugMenu
//
//  Created by Manu Wallner on 10/11/13.
//  Copyright (c) 2013 XForge. All rights reserved.
//

#import "XFTypeDescriptor.h"

typedef NS_ENUM(uint, XFPrimitiveType) {
    XFPrimitiveTypeChar,
    XFPrimitiveTypeInt,
    XFPrimitiveTypeShort,
    XFPrimitiveTypeLong,
    XFPrimitiveTypeLongLong,
    XFPrimitiveTypeFloat,
    XFPrimitiveTypeDouble,
    XFPrimitiveTypeString,
    XFPrimitiveTypeSelector,
    XFPrimitiveTypeBool,
    XFPrimitiveTypeVoid
};

@interface XFPrimitiveTypeDescriptor : XFTypeDescriptor

- (instancetype)initWithType:(XFPrimitiveType)type isUnsigned:(BOOL)unsign;
    
@property (nonatomic, readonly) XFPrimitiveType type;
@property (nonatomic, getter = isUnsigned, readonly) BOOL unsign;

@end
