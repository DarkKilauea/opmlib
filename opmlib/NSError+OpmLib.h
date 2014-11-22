//
//  NSError+OpmLib.h
//  opmlib
//
//  Created by Joshua Jones on 11/21/14.
//  Copyright (c) 2014 Joshua Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const OpmLibErrorDomain = @"OpmLibErrorDomain";

NS_ENUM(NSInteger, OpmLibError)
{
    OpmError_PackageMetadata_InvalidJson = -100,
    OpmError_PackageMetadata_MissingIdentifer = -101,
    OpmError_PackageMetadata_MissingVersion = -102,
};

@interface NSError (OpmLib)

+ (NSError*)opmLibLocalizedErrorWithCode:(NSInteger)code key:(NSString*)key, ...;
+ (BOOL)opmLibFillLocalizedError:(NSError**)error code:(NSInteger)code key:(NSString*)key, ...;

@end
