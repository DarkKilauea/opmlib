//
//  AsyncOperation.h
//  opmlib
//
//  Created by Joshua Jones on 11/22/14.
//  Copyright (c) 2014 Joshua Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Base class for operations that are asynchronous.
 *
 *  Handles all of the work needed to implement asynchronous NSOperations.  
 *  Just override main and put you logic in there, calling markFinished when your work is done.
 *
 *  markFinished must also be called if your operation reacts to a cancellation.
 */
@interface AsyncOperation : NSOperation

/**
 *  This method marks the operation as done.  This method must be called once all of the work has been done.
 *
 *  It must also be called in the case of a cancellation.
 */
- (void)markFinished;

@end
