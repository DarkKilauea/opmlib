//
//  NSError+OpmLib.m
//  opmlib
//
//  Created by Joshua Jones on 11/21/14.
//  Copyright (c) 2014 Joshua Jones. All rights reserved.
//

#import "NSError+OpmLib.h"

@implementation NSError (OpmLib)

+ (NSError*)opmLibLocalizedErrorWithCode:(NSInteger)code key:(NSString*)key, ...
{
    NSString* message = NSLocalizedStringFromTableInBundle(key,
                                                           @"Errors",
                                                           [NSBundle bundleWithIdentifier:@"net.darkkilauea.opmlib"],
                                                           nil);
    
    va_list args;
    va_start(args, key);
    NSError* localError = [self opmLibErrorWithCode:code message:message arguments:args];
    va_end(args);
    
    return localError;
}

+ (BOOL)opmLibFillLocalizedError:(NSError**)error code:(NSInteger)code key:(NSString*)key, ...
{
    if (error)
    {
        NSString* message = NSLocalizedStringFromTableInBundle(key,
                                                               @"Errors",
                                                               [NSBundle bundleWithIdentifier:@"net.darkkilauea.opmlib"],
                                                               nil);
        
        va_list args;
        va_start(args, key);
        NSError* localError = [self opmLibErrorWithCode:code message:message arguments:args];
        va_end(args);
        
        *error = localError;
    }
    
    return NO;
}

+ (NSError*)opmLibErrorWithCode:(NSInteger)code message:(NSString*)message arguments:(va_list)args
{
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    
    if (message)
    {
        NSString* fullMessage = [[NSString alloc] initWithFormat:message arguments:args];
        [userInfo setObject:fullMessage forKey:NSLocalizedDescriptionKey];
    }
    
    return [NSError errorWithDomain:OpmLibErrorDomain code:code userInfo:userInfo];
}

@end
