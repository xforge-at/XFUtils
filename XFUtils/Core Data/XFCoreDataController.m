//
//  XFCoreDataController.m
//  XFUtils
//
//  Created by Manu Wallner on 07.08.13.
//  Copyright (c) 2013 XForge Software Development GmbH. All rights reserved.
//

#import "XFCoreDataController.h"

@implementation XFCoreDataController

static NSPersistentStoreCoordinator *_sharedCoordinator;
static NSManagedObjectContext *_mainThreadContext;
static NSManagedObjectContext *_saveContext;
static NSManagedObjectModel *_sharedModel;
static NSString *_fileName;

+ (void)initializeStackWithFileName:(NSString *)fileName {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"momd"];
        _sharedModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        _fileName = fileName;
        [self createStoreCoordinator];
        [self createContexts];
    });
}

+ (NSURL *)applicationFilesDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];

// Use different directories for Alpha and Beta
#ifdef DEBUG
    return [appSupportURL URLByAppendingPathComponent:@"at.xforge.data.debug"];
#elif BETA
    return [appSupportURL URLByAppendingPathComponent:@"at.xforge.data.beta"];
#else
    return [appSupportURL URLByAppendingPathComponent:@"at.xforge.data"];
#endif
}

+ (void)createStoreCoordinator {
    NSManagedObjectModel *mom = _sharedModel;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;

    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[ NSURLIsDirectoryKey ] error:&error];

    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [self logError:error];
            return;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];

            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"at.xforge.errors.core-data" code:101 userInfo:dict];

            [self logError:error];
            return;
        }
    }

    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"Data.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:@{} error:&error]) {
        [self logError:error];
        return;
    }
    _sharedCoordinator = coordinator;
}

+ (void)createContexts {
    _mainThreadContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _saveContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_mainThreadContext setParentContext:_saveContext];
    [_saveContext setPersistentStoreCoordinator:_sharedCoordinator];
}

+ (void)saveToDisk {
    [_saveContext performBlockAndWait:^{
        NSError *error = nil;
        [_saveContext save:&error];
        if (error) {
            [self logError:error];
        }
    }];
}

+ (void)deleteEverything {
    NSMutableArray *storesToDelete = [@[] mutableCopy];
    for (NSPersistentStore *store in _sharedCoordinator.persistentStores) {
        [storesToDelete addObject:store];
    }
    [storesToDelete enumerateObjectsUsingBlock:^(NSPersistentStore *store, NSUInteger idx, BOOL *stop) {
        NSError *error;
        [_sharedCoordinator removePersistentStore:store error:&error];
        if (error) {
            [self logError:error];
        }
    }];

    NSURL *path = [[self applicationFilesDirectory] URLByAppendingPathComponent:@"Data.storedata"];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtURL:path error:&error];

    if (error) {
        [self logError:error];
        return;
    }

    if (![_sharedCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:path options:@{} error:&error]) {
        [self logError:error];
        return;
    }
}

+ (NSManagedObjectContext *)contextForMainThread {
    return _mainThreadContext;
}

+ (NSManagedObjectModel *)sharedModel {
    return _sharedModel;
}

+ (NSManagedObjectContext *)privateContext {
    return _saveContext;
}

+ (NSManagedObjectContext *)newPrivateContext {
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setParentContext:_mainThreadContext];
    return context;
}

+ (void)logError:(NSError *)error {
    NSLog(@"Caught error: %@(%li)", error.domain, (long)error.code);
    NSLog(@"Error Reason: %@", error.localizedFailureReason);
    NSLog(@"Error Description: %@", error.localizedDescription);
    NSLog(@"Error userInfo: %@", error.userInfo);
}

@end