//
//  PackageMetadataTests.m
//  opmlib
//
//  Created by Joshua Jones on 11/21/14.
//  Copyright (c) 2014 Joshua Jones. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import <opmlib/opmlib.h>

@interface PackageMetadataTests : XCTestCase

@end

@implementation PackageMetadataTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParseJsonSuccessfulForValidJson
{
    NSString* json = @"{"
    "   \"id\": \"test-package\","
    "   \"name\": \"Test Package\","
    "   \"description\": \"This is just a test package for use with unit tests.\","
    "   \"maintainer\": \"Objective-C Package Manager Team\","
    "   \"authors\": [\"Awesome Guy\", \"Another Awesome Person\"],"
    "   \"version\": \"1.0.15.245\","
    "   \"dependencies\": [\"test-dependent-package\", \"another-package\"],"
    "}";
    
    NSError* error = nil;
    PackageMetadata* metadata = [PackageMetadata metadataWithJsonData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                                error:&error];
    
    XCTAssertNotNil(metadata);
    XCTAssertNil(error);
    
    if (metadata)
    {
        XCTAssertEqualObjects(metadata.identifier, @"test-package");
        XCTAssertEqualObjects(metadata.name, @"Test Package");
        XCTAssertEqualObjects(metadata.packageVersion, @"1.0.15.245");
        XCTAssertEqualObjects(metadata.packageDescription, @"This is just a test package for use with unit tests.");
        XCTAssertEqualObjects(metadata.packageMaintainer, @"Objective-C Package Manager Team");
        XCTAssertEqualObjects(metadata.authors, (@[@"Awesome Guy", @"Another Awesome Person"]));
        XCTAssertEqualObjects(metadata.dependencies, (@[@"test-dependent-package", @"another-package"]));
    }
}

- (void)testParseJsonFailsForTruncatedJson
{
    NSString* json = @"{"
    "   \"id\": \"test-package\","
    "   \"name\": \"Test Package\","
    "   \"description\": \"This is just a test package for use with unit tests.\","
    "   \"maintainer\": \"Objective-C Packa";
    
    NSError* error = nil;
    PackageMetadata* metadata = [PackageMetadata metadataWithJsonData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                                error:&error];
    
    XCTAssertNil(metadata);
    XCTAssertNotNil(error);
}

- (void)testParseJsonFailsForMissingIdentifier
{
    NSString* json = @"{"
    "   \"name\": \"Test Package\","
    "   \"description\": \"This is just a test package for use with unit tests.\","
    "   \"maintainer\": \"Objective-C Package Manager Team\","
    "   \"authors\": [\"Awesome Guy\", \"Another Awesome Person\"],"
    "   \"version\": \"1.0.15.245\","
    "   \"dependencies\": [\"test-dependent-package\", \"another-package\"],"
    "}";
    
    NSError* error = nil;
    PackageMetadata* metadata = [PackageMetadata metadataWithJsonData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                                error:&error];
    
    XCTAssertNil(metadata);
    XCTAssertNotNil(error);
    
    if (error)
    {
        XCTAssertEqual(error.code, OpmError_PackageMetadata_MissingIdentifer);
    }
}

- (void)testParseJsonFailsForMissingVersion
{
    NSString* json = @"{"
    "   \"id\": \"test-package\","
    "   \"name\": \"Test Package\","
    "   \"description\": \"This is just a test package for use with unit tests.\","
    "   \"maintainer\": \"Objective-C Package Manager Team\","
    "   \"authors\": [\"Awesome Guy\", \"Another Awesome Person\"],"
    "   \"dependencies\": [\"test-dependent-package\", \"another-package\"],"
    "}";
    
    NSError* error = nil;
    PackageMetadata* metadata = [PackageMetadata metadataWithJsonData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                                error:&error];
    
    XCTAssertNil(metadata);
    XCTAssertNotNil(error);
    
    if (error)
    {
        XCTAssertEqual(error.code, OpmError_PackageMetadata_MissingVersion);
    }
}

- (void)testParseJsonFailsForNotBeingAnObject
{
    NSString* json = @"["
    "   \"id\",\"test-package\","
    "   \"name\", \"Test Package\","
    "   \"description\", \"This is just a test package for use with unit tests.\","
    "   \"maintainer\", \"Objective-C Package Manager Team\","
    "   \"authors\", [\"Awesome Guy\", \"Another Awesome Person\"],"
    "   \"version\", \"1.0.15.245\","
    "   \"dependencies\", [\"test-dependent-package\", \"another-package\"],"
    "]";
    
    NSError* error = nil;
    PackageMetadata* metadata = [PackageMetadata metadataWithJsonData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                                error:&error];
    
    XCTAssertNil(metadata);
    XCTAssertNotNil(error);
    
    if (error)
    {
        XCTAssertEqual(error.code, OpmError_PackageMetadata_InvalidJson);
    }
}

- (void)testParseJsonFailsForAuthorsObject
{
    NSString* json = @"{"
    "   \"id\": \"test-package\","
    "   \"name\": \"Test Package\","
    "   \"description\": \"This is just a test package for use with unit tests.\","
    "   \"maintainer\": \"Objective-C Package Manager Team\","
    "   \"authors\": {\"Awesome Guy\": \"Thing\", \"Another Awesome Person\": \"Other Thing\"},"
    "   \"version\": \"1.0.15.245\","
    "   \"dependencies\": [\"test-dependent-package\", \"another-package\"],"
    "}";
    
    NSError* error = nil;
    PackageMetadata* metadata = [PackageMetadata metadataWithJsonData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                                error:&error];
    
    XCTAssertNil(metadata);
    XCTAssertNotNil(error);
    
    if (error)
    {
        XCTAssertEqual(error.code, OpmError_PackageMetadata_InvalidJson);
    }
}

- (void)testParseJsonFailsForDependenciesObject
{
    NSString* json = @"{"
    "   \"id\": \"test-package\","
    "   \"name\": \"Test Package\","
    "   \"description\": \"This is just a test package for use with unit tests.\","
    "   \"maintainer\": \"Objective-C Package Manager Team\","
    "   \"authors\": [\"Awesome Guy\", \"Another Awesome Person\"],"
    "   \"version\": \"1.0.15.245\","
    "   \"dependencies\": {\"test-dependent-package\": \"another-package\"},"
    "}";
    
    NSError* error = nil;
    PackageMetadata* metadata = [PackageMetadata metadataWithJsonData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                                error:&error];
    
    XCTAssertNil(metadata);
    XCTAssertNotNil(error);
    
    if (error)
    {
        XCTAssertEqual(error.code, OpmError_PackageMetadata_InvalidJson);
    }
}

- (void)testParseJsonFailsForNonStringsInAuthors
{
    NSString* json = @"{"
    "   \"id\": \"test-package\","
    "   \"name\": \"Test Package\","
    "   \"description\": \"This is just a test package for use with unit tests.\","
    "   \"maintainer\": \"Objective-C Package Manager Team\","
    "   \"authors\": [[\"Awesome Guy\", \"Another Awesome Person\"], [14, 42]],"
    "   \"version\": \"1.0.15.245\","
    "   \"dependencies\": [\"test-dependent-package\", \"another-package\"],"
    "}";
    
    NSError* error = nil;
    PackageMetadata* metadata = [PackageMetadata metadataWithJsonData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                                error:&error];
    
    XCTAssertNil(metadata);
    XCTAssertNotNil(error);
    
    if (error)
    {
        XCTAssertEqual(error.code, OpmError_PackageMetadata_InvalidJson);
    }
}

- (void)testParseJsonFailsForNonStringsInDependencies
{
    NSString* json = @"{"
    "   \"id\": \"test-package\","
    "   \"name\": \"Test Package\","
    "   \"description\": \"This is just a test package for use with unit tests.\","
    "   \"maintainer\": \"Objective-C Package Manager Team\","
    "   \"authors\": [\"Awesome Guy\", \"Another Awesome Person\"],"
    "   \"version\": \"1.0.15.245\","
    "   \"dependencies\": [[42, 992], \"test-dependent-package\", \"another-package\"],"
    "}";
    
    NSError* error = nil;
    PackageMetadata* metadata = [PackageMetadata metadataWithJsonData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                                error:&error];
    
    XCTAssertNil(metadata);
    XCTAssertNotNil(error);
    
    if (error)
    {
        XCTAssertEqual(error.code, OpmError_PackageMetadata_InvalidJson);
    }
}

@end
