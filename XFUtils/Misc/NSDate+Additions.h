//
//  NSDate+Additions.h
//  XFUtils
//
//  Created by Manu Wallner on 02/08/13.
//  Copyright (c) 2013 XForge Software Development GmbH. All rights reserved.
//

@import Foundation;

@interface NSDate (Additions)

/**
 *  Parse a date from a string
 *
 *  @param dateString A date string of the form "yyyy.mm.dd hh.mm.ss.SSS"
 *
 *  @return The string converted to a date
 */
+ (NSDate *)dateFromString:(NSString *)dateString;

@end
