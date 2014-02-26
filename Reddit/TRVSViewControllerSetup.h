//
//  TRVSViewControllerSetup.h
//  Reddit
//
//  Created by Travis Jeffery on 2/25/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TRVSViewControllerSetup <NSObject>

- (void)setupWithCompletionHandler:(TRVSCompletionHandler)completionHandler;
    
@end
