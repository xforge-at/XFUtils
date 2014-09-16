//
//  XFObjectTypeDescriptor.h
//  XFDebugMenu
//
//  Created by Manu Wallner on 10/11/13.
//  Copyright (c) 2013 XForge. All rights reserved.
//

#import "XFTypeDescriptor.h"

@interface XFObjectTypeDescriptor : XFTypeDescriptor

@property (nonatomic, strong, readonly) NSString *objectClassName;
@property (nonatomic, readonly) BOOL isId;
@property (nonatomic, readonly) BOOL hasProtocol;

@end
