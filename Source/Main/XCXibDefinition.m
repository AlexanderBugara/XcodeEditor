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
#import "XCXibDefinition.h"


@implementation XCXibDefinition

@synthesize name = _name;
@synthesize content = _content;

/* ================================================= Class Methods ================================================== */
+ (XCXibDefinition*) xibDefinitionWithName:(NSString*)name {
    return [[[XCXibDefinition alloc] initWithName:name] autorelease];
}

+ (XCXibDefinition*) xibDefinitionWithName:(NSString*)name content:(NSString*)content {
    return [[[XCXibDefinition alloc] initWithName:name content:content] autorelease];
}


/* ================================================== Initializers ================================================== */
- (id) initWithName:(NSString*)name {
    return [self initWithName:name content:nil];
}


- (id) initWithName:(NSString*)name content:(NSString*)content {
    self = [super init];
    if (self) {
        _name = name;
        _content = content;
    }
    return self;
}

/* ================================================== Deallocation ================================================== */
- (void) dealloc {
	[_name release];
	[_content release];

	[super dealloc];
}

/* ================================================ Interface Methods =============================================== */
- (NSString*) xibFileName {
    return [_name stringByAppendingString:@".xib"];
}

@end