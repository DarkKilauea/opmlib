//
//  PackageMetadata.m
//  opmlib
//
//  Created by Joshua Jones on 11/21/14.
//  Copyright (c) 2014 Joshua Jones. All rights reserved.
//

#import "PackageMetadata.h"
#import "NSError+OpmLib.h"

@implementation PackageMetadata

+ (PackageMetadata*)metadataWithJsonData:(NSData*)data error:(NSError**)error
{
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    
    if (!jsonObject)
        return nil;
    
    if (![jsonObject isKindOfClass:[NSDictionary class]])
    {
        [NSError opmLibFillLocalizedError:error
                                     code:OpmError_PackageMetadata_InvalidJson
                                      key:@"PackageMetadata_ExpectedDictionary"];
        return nil;
    }
    
    PackageMetadata* metadata = [[PackageMetadata alloc] init];
    metadata.identifier = [jsonObject objectForKey:@"id"];
    if (!metadata.identifier)
    {
        [NSError opmLibFillLocalizedError:error
                                     code:OpmError_PackageMetadata_MissingIdentifer
                                      key:@"PackageMetadata_ExpectedIdentifer"];
        return nil;
    }
    
    metadata.packageVersion = [jsonObject objectForKey:@"version"];
    if (!metadata.packageVersion)
    {
        [NSError opmLibFillLocalizedError:error
                                     code:OpmError_PackageMetadata_MissingVersion
                                      key:@"PackageMetadata_ExpectedVersion"];
        return nil;
    }
    
    metadata.name = [jsonObject objectForKey:@"name"];
    metadata.packageDescription = [jsonObject objectForKey:@"description"];
    metadata.packageMaintainer = [jsonObject objectForKey:@"maintainer"];
    
    id authors = [jsonObject objectForKey:@"authors"];
    if (authors)
    {
        NSArray* checkedAuthors = [self checkJSONArray:authors key:@"authors" error:error];
        if (!checkedAuthors)
            return nil;
        
        metadata.authors = checkedAuthors;
    }
    
    id dependencies = [jsonObject objectForKey:@"dependencies"];
    if (dependencies)
    {
        NSArray* checkedDependencies = [self checkJSONArray:dependencies key:@"dependencies" error:error];
        if (!checkedDependencies)
            return nil;
        
        metadata.dependencies = checkedDependencies;
    }
    
    return metadata;
}

+ (NSArray*)checkJSONArray:(id)array key:(NSString*)key error:(NSError**)error
{
    if (![array isKindOfClass:[NSArray class]])
    {
        [NSError opmLibFillLocalizedError:error
                                     code:OpmError_PackageMetadata_InvalidJson
                                      key:@"PackageMetadata_ExpectedSubArray", key];
        return nil;
    }
    
    if (![self checkArrayOnlyContainsStrings:array])
    {
        [NSError opmLibFillLocalizedError:error
                                     code:OpmError_PackageMetadata_InvalidJson
                                      key:@"PackageMetadata_ExpectedStringsInSubArray", key];
        return nil;
    }
    
    return array;
}

+ (BOOL)checkArrayOnlyContainsStrings:(NSArray*)array
{
    for (id item in array)
    {
        if (![item isKindOfClass:[NSString class]])
            return NO;
    }
    
    return YES;
}

@end
