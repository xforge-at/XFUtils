//
//  XFCoreDataController.h
//  XFUtils
//
//  Created by Manu Wallner on 07.08.13.
//  Copyright (c) 2013 XForge Software Development GmbH. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface XFCoreDataController : NSObject

/**
 *  Initialize the core data stack
 *
 *  @param fileName The filename for the .momd file, without extension
 */
+ (void)initializeStackWithFileName:(NSString *)fileName;

/**
 *  Save everything to disk
 */
+ (void)saveToDisk;

/**
 *  @return The context that can be used on the main thread
 */
+ (NSManagedObjectContext *)contextForMainThread;

/**
 *  @return The private context that is used to save
 */
+ (NSManagedObjectContext *)privateContext;

+ (NSManagedObjectModel *)sharedModel;

/**
 *  @return A new private context as the child of the main thread context
 */
+ (NSManagedObjectContext *)newPrivateContext;

/**
 *  Delete all data by removing the store file and recreating it afterwards
 */
+ (void)deleteEverything;

@end
