//
//  PackageMetadata.h
//  opmlib
//
//  Created by Joshua Jones on 11/21/14.
//  Copyright (c) 2014 Joshua Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackageMetadata : NSObject

@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* packageVersion;
@property (nonatomic, strong) NSString* packageDescription;
@property (nonatomic, strong) NSString* packageMaintainer;
@property (nonatomic, strong) NSArray* authors;
@property (nonatomic, strong) NSArray* dependencies;

+ (PackageMetadata*)metadataWithJsonData:(NSData*)data error:(NSError**)error;

@end
