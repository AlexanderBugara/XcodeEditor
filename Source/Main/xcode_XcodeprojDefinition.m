////////////////////////////////////////////////////////////////////////////////
//
//  Synapticats, LLC
//  Copyright 2012 Synapticats, LLC
//  All Rights Reserved.
//
//  NOTICE: Expanz and Synapticats, LLC permit you to use, modify, and distribute 
//  this file in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "xcode_XcodeprojDefinition.h"


@implementation xcode_XcodeprojDefinition

@synthesize sourceFileName = _sourceFileName;
@synthesize path = _path;
@synthesize type = _type;

/* ================================================= Class Methods ================================================== */
+ (xcode_XcodeprojDefinition*) sourceDefinitionWithName:(NSString*)name projPath:(NSString*)path type:(XcodeSourceFileType)type {
    
    return [[XcodeprojDefinition alloc] initWithName:name projPath:path type:type];
}

/* ================================================== Initializers ================================================== */
- (id) initWithName:(NSString*)name projPath:(NSString*)path type:(XcodeSourceFileType)type {
    self = [super init];
    if (self) {
        _sourceFileName = [name copy];
        _path = [path copy];
        _type = type;
    }
    return self;
}

/* ================================================ Interface Methods =============================================== */
- (NSString*) xcodeprojFileName {
    return [_sourceFileName stringByAppendingString:@".xcodeproj"];
}

- (NSString*) xcodeprojFullPathName {
    return [NSString stringWithFormat:@"%@/%@", _path, [_sourceFileName stringByAppendingString:@".xcodeproj"]];
}


@end