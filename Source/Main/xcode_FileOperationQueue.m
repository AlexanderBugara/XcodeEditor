////////////////////////////////////////////////////////////////////////////////
//
//  EXPANZ
//  Copyright 2008-2011 EXPANZ
//  All Rights Reserved.
//
//  NOTICE: Expanz permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "xcode_FileOperationQueue.h"

@interface xcode_FileOperationQueue ()

- (NSString*) destinationPathFor:(NSString*)fileName inProjectDirectory:(NSString*)directory;

- (void) performFileWrites;

- (void) performCopyFrameworks;

- (void) performFileDeletions;

- (void) performCreateDirectories;

@end


@implementation xcode_FileOperationQueue

/* ================================================== Initializers ================================================== */
- (id) initWithBaseDirectory:(NSString*)baseDirectory {
    self = [super init];
    if (self) {
        _baseDirectory = [baseDirectory copy];
        _filesToWrite = [[NSMutableDictionary alloc] init];
        _frameworksToCopy = [[NSMutableDictionary alloc] init];
        _filesToDelete = [[NSMutableArray alloc] init];
        _directoriesToCreate = [[NSMutableArray alloc] init];
    }
    return self;
}

/* ================================================ Interface Methods =============================================== */
- (void) queueWrite:(NSString*)fileName inDirectory:(NSString*)directory withContents:(NSString*)contents {
    [_filesToWrite setObject:contents forKey:[self destinationPathFor:fileName inProjectDirectory:directory]];
}

- (void) queueFrameworkWithFilePath:(NSString*)filePath inDirectory:(NSString*)directory {

    NSURL* sourceUrl = [NSURL fileURLWithPath:filePath isDirectory:YES];
    NSString* destinationPath = [[_baseDirectory stringByAppendingPathComponent:directory]
            stringByAppendingPathComponent:[filePath lastPathComponent]];
    NSURL* destinationUrl = [NSURL fileURLWithPath:destinationPath isDirectory:YES];
    [_frameworksToCopy setObject:sourceUrl forKey:destinationUrl];
}

- (void) queueDeletion:(NSString*)filePath {
    LogDebug(@"Queing deletion for path: %@", filePath);
    [_filesToDelete addObject:filePath];
}

- (void) queueDirectory:(NSString*)withName inDirectory:(NSString*)parentDirectory {
    [_directoriesToCreate addObject:[self destinationPathFor:withName inProjectDirectory:parentDirectory]];
}

- (void) commitFileOperations {
    LogDebug(@"Starting to commit file operations!!!!!!!!!!!!!!!!!!");
    [self performFileWrites];
    LogDebug(@"Done with file writes");

    [self performCopyFrameworks];
    LogDebug(@"Done with copy frameworks");

    [self performFileDeletions];
    LogDebug(@"Done with file deletes");

    [self performCreateDirectories];
    LogDebug(@"Done with create directories");
}


/* ================================================== Private Methods =============================================== */
- (NSString*) destinationPathFor:(NSString*)fileName inProjectDirectory:(NSString*)directory {
    return [[_baseDirectory stringByAppendingPathComponent:directory] stringByAppendingPathComponent:fileName];
}

- (void) performFileWrites {
    [_filesToWrite enumerateKeysAndObjectsUsingBlock:^(id filePath, id data, BOOL* stop) {
        NSError* error = nil;
        if (![data writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
            [NSException raise:NSInternalInconsistencyException format:@"Error writing file at filePath: %@, error: %@",
                                                                       filePath, error];
        }
    }];
    [_filesToWrite removeAllObjects];
}

- (void) performCopyFrameworks {
    [_frameworksToCopy enumerateKeysAndObjectsUsingBlock:^(NSURL* destinationUrl, NSURL* frameworkPath, BOOL* stop) {

        NSFileManager* fileManager = [NSFileManager defaultManager];

        if ([fileManager fileExistsAtPath:[destinationUrl path]]) {
            [fileManager removeItemAtURL:destinationUrl error:nil];
        }
        NSError* error = nil;
        if (![fileManager copyItemAtURL:frameworkPath toURL:destinationUrl error:&error]) {
            LogDebug(@"User info: %@", [error userInfo]);
            [NSException raise:NSInternalInconsistencyException format:@"Error writing file at filePath: %@",
                                                                       [frameworkPath absoluteString]];
        }
    }];
    [_frameworksToCopy removeAllObjects];
}

- (void) performFileDeletions {
    LogDebug(@"Files to delete: %@", _filesToDelete);

    for (NSString* filePath in [_filesToDelete reverseObjectEnumerator]) {
        NSString* fullPath = [_baseDirectory stringByAppendingPathComponent:filePath];
        NSError* error = nil;

        if (![[NSFileManager defaultManager] removeItemAtPath:fullPath error:&error]) {
            NSLog(@"failed to remove item at path; error == %@", error);
            [NSException raise:NSInternalInconsistencyException format:@"Error deleting file at filePath: %@",
                                                                       filePath];
        }
    }
    [_filesToDelete removeAllObjects];
}

- (void) performCreateDirectories {
    for (NSString* filePath in _directoriesToCreate) {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:filePath]) {
            if (![fileManager
                    createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil]) {
                [NSException raise:NSInvalidArgumentException format:@"Error: Create folder failed %@", filePath];
            }
        }
    }
}

/* ================================================== Utility Methods =============================================== */
- (void) dealloc {
    [_baseDirectory release];
    [_filesToWrite release];
    [_frameworksToCopy release];
    [_filesToDelete release];
    [_directoriesToCreate release];
    [super dealloc];
}


@end