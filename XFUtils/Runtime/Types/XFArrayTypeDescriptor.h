//
//  XFArrayTypeDescriptor.h
//  XFUtils
//
//  Created by Manu Wallner on 10/11/13.
//  Copyright (c) 2013 XForge Software Development GmbH. All rights reserved.
//

#import "XFTypeDescriptor.h"

@interface XFArrayTypeDescriptor : XFTypeDescriptor

@property (nonatomic, strong, readonly) XFTypeDescriptor *innerTypeDescriptor;
@property (nonatomic, readonly) uint numberOfElements;

@end
