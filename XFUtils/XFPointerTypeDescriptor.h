//
//  XFPointerTypeDescriptor.h
//  XFDebugMenu
//
//  Created by Manu Wallner on 10/11/13.
//  Copyright (c) 2013 XForge. All rights reserved.
//

#import "XFTypeDescriptor.h"

@interface XFPointerTypeDescriptor : XFTypeDescriptor

@property (nonatomic, strong, readonly) XFTypeDescriptor *innerTypeDescriptor;

@end
