//
//  TRVSKeychain.h
//  Reddit
//
//  Created by Travis Jeffery on 2/23/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRVSKeychain : NSObject

+ (NSString *)passwordForService:(NSString *)service account:(NSString *)account;
+ (NSString *)passwordForService:(NSString *)service account:(NSString *)account error:(NSError **)error;
+ (BOOL)setPassword:(NSString *)password service:(NSString *)service account:(NSString *)account;

@end
