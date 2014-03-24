////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "XcodeSourceFileType.h"

NSDictionary* NSDictionaryWithXCFileReferenceTypes()
{
    static NSDictionary* dictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        dictionary = @{
            @"sourcecode.c.h"        : @(SourceCodeHeader),
            @"sourcecode.c.objc"     : @(SourceCodeObjC),
            @"wrapper.framework"     : @(Framework),
            @"text.plist.strings"    : @(PropertyList),
            @"sourcecode.cpp.objcpp" : @(SourceCodeObjCPlusPlus),
            @"sourcecode.cpp.cpp"    : @(SourceCodeCPlusPlus),
            @"file.xib"              : @(XibFile),
            @"image.png"             : @(ImageResourcePNG),
            @"wrapper.cfbundle"      : @(Bundle),
            @"archive.ar"            : @(Archive),
            @"text.html"             : @(HTML),
            @"text"                  : @(TEXT),
            @"wrapper.pb-project"    : @(XcodeProject)
        };
    });

    return dictionary;
}


@implementation NSString (XcodeFileType)

+ (NSString*)stringFromSourceFileType:(XcodeSourceFileType)type
{
    return [[NSDictionaryWithXCFileReferenceTypes() allKeysForObject:@(type)] objectAtIndex:0];
}


- (XcodeSourceFileType)asSourceFileType
{
    NSDictionary* typeStrings = NSDictionaryWithXCFileReferenceTypes();

    if ([typeStrings objectForKey:self])
    {
        return (XcodeSourceFileType) [[typeStrings objectForKey:self] intValue];
    }
    else
    {
        return FileTypeNil;
    }
}


@end