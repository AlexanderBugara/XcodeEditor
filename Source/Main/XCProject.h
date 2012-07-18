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

#import <Foundation/Foundation.h>
#import "XcodeMemberType.h"
#import "XcodeSourceFileType.h"

@class XCClassDefinition;
@class XCGroup;
@class XCFileOperationQueue;
@class XCSourceFile;
@class XCTarget;
@class XCSubProjectDefinition;


@interface XCProject : NSObject {

@private
    XCFileOperationQueue* _fileOperationQueue;

    NSString* _filePath;
    NSMutableDictionary* _dataStore;
    NSMutableArray* _targets;
}

@property(nonatomic, strong, readonly) XCFileOperationQueue* fileOperationQueue;

/* ================================================== Initializers ================================================== */

+ (XCProject*) projectWithFilePath:(NSString*)filePath;

/**
* Creates a new project editor instance with the specified Project.xcodeproj file.
*/
- (id) initWithFilePath:(NSString*)filePath;

/* ================================================================================================================== */

#pragma mark Files
/**
* Returns all file resources in the project, as an array of `XCSourceFile` objects.
*/
- (NSArray*) files;

/**
* Returns the project file with the specified key, or nil.
*/
- (XCSourceFile*) fileWithKey:(NSString*)key;

/**
* Returns the project file with the specified name, or nil. If more than one project file matches the specified name,
* which one is returned is undefined.
*/
- (XCSourceFile*) fileWithName:(NSString*)name;

/**
* Returns all header files in the project, as an array of `XCSourceFile` objects.
*/
- (NSArray*) headerFiles;

/**
* Returns all implementation obj-c implementation files in the project, as an array of `XCSourceFile` objects.
*/
- (NSArray*) objectiveCFiles;

/**
* Returns all implementation obj-c++ implementation files in the project, as an array of `XCSourceFile` objects.
*/
- (NSArray*) objectiveCPlusPlusFiles;

/**
* Returns all the xib files in the project, as an array of `XCSourceFile` objects.
*/
- (NSArray*) xibFiles;

- (NSArray*) imagePNGFiles;

- (NSString*) filePath;


/* ================================================================================================================== */
#pragma mark Groups
/**
* Lists the groups in an xcode project, returning an array of `XCGroup` objects.
*/
- (NSArray*) groups;

/**
 * Returns the root (top-level) group.
 */
- (XCGroup*) rootGroup;

/**
* Returns the group with the given key, or nil.
*/
- (XCGroup*) groupWithKey:(NSString*)key;

/**
 * Returns the group with the specified display name path - the directory relative to the root group. Eg Source/Main
 */
- (XCGroup*) groupWithPathFromRoot:(NSString*)path;

/**
* Returns the parent group for the group or file with the given key;
*/
- (XCGroup*) groupForGroupMemberWithKey:(NSString*)key;

/* ================================================================================================================== */
#pragma mark Targets
/**
* Lists the targets in an xcode project, returning an array of `XCTarget` objects.
*/
- (NSArray*) targets;

/**
* Returns the target with the specified name, or nil. 
*/
- (XCTarget*) targetWithName:(NSString*)name;

/* ================================================================================================================== */
#pragma mark Saving
/**
* Saves a project after editing.
*/
- (void) save;


/* ================================================================================================================== */
/**
* Raw project data.
*/
- (NSMutableDictionary*) objects;

@end
