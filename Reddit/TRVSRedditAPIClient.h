//
//  TRVSRedditAPIClient.h
//  Reddit
//
//  Created by Travis Jeffery on 2/13/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TRVSRedditAPIClientResponseBlock)(NSURLResponse *, NSError *);
typedef void (^TRVSRedditAPIClientArrayBlock)(NSArray *, NSError *);
typedef void (^TRVSRedditAPIClientDictionaryBlock)(NSDictionary *, NSError *);

@interface TRVSRedditAPIClient : NSObject

+ (instancetype)sharedClient;

- (void)loginUsingUsername:(NSString *)username password:(NSString *)password block:(void (^)(BOOL , NSError *))block;
- (void)fetchSubscribedSubredditsUsingBlock:(TRVSRedditAPIClientDictionaryBlock)block;

@end
