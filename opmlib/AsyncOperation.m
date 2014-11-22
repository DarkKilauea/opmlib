//
//  AsyncOperation.m
//  opmlib
//
//  Created by Joshua Jones on 11/22/14.
//  Copyright (c) 2014 Joshua Jones. All rights reserved.
//

#import "AsyncOperation.h"

@interface AsyncOperation ()
{
    BOOL _isExecuting;
    BOOL _isFinished;
}

@end

@implementation AsyncOperation

- (BOOL)isAsynchronous
{
    return YES;
}

- (BOOL)isExecuting
{
    @synchronized (self)
    {
        return _isExecuting;
    }
}

- (BOOL)isFinished
{
    @synchronized (self)
    {
        return _isFinished;
    }
}

- (void)start
{
    @synchronized (self)
    {
        [self willChangeValueForKey:@"isExecuting"];
        _isExecuting = YES;
        [self didChangeValueForKey:@"isExecuting"];
    }
    
    if (self.cancelled)
    {
        [self markFinished];
        return;
    }
    
    if (self.finished)
        return;
    
    [self main];
}

- (void)markFinished
{
    @synchronized (self)
    {
        if (_isFinished)
            return;
        
        [self willChangeValueForKey:@"isExecuting"];
        _isExecuting = NO;
        [self didChangeValueForKey:@"isExecuting"];
        
        [self willChangeValueForKey:@"isFinished"];
        _isFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
    }
}

@end
