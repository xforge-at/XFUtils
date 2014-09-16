//
//  XFTypeMaker.h
//  XFDebugMenu
//
//  Created by Manu Wallner on 11/11/13.
//  Copyright (c) 2013 XForge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFUnknownTypeDescriptor.h"
#import "XFPointerTypeDescriptor.h"
#import "XFStructTypeDescriptor.h"
#import "XFArrayTypeDescriptor.h"
#import "XFFunctionPointerTypeDescriptor.h"
#import "XFPrimitiveTypeDescriptor.h"
#import "XFObjectTypeDescriptor.h"

//ex: [XFTypeDescriptor make].pointer.to.pointer.to.unsigned.int (unsigned int **)
//ex: .pointer.to.array(@12).of.idWithProtocol(@"UITableViewDelegate")
//ex: .array(@4).of.float

@interface XFTypeMaker : NSObject

@end
