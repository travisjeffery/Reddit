//
//  TRVSRedditAPIClient.h
//  Reddit
//
//  Created by Travis Jeffery on 2/13/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const TRVSRedditAPIClientErrorDomain;

extern NSString *const TRVSRedditAPIClientListingOrderPopular;
extern NSString *const TRVSRedditAPIClientListingOrderHot;
extern NSString *const TRVSRedditAPIClientListingOrderNew;

typedef void (^TRVSRedditAPIClientResponseBlock)(NSURLResponse *, NSError *);
typedef void (^TRVSRedditAPIClientArrayBlock)(NSArray *, NSError *);
typedef void (^TRVSRedditAPIClientDictionaryBlock)(NSDictionary *, NSError *);

@interface TRVSRedditAPIClient : NSObject

+ (instancetype)sharedClient;

- (void)loginUsingUsername:(NSString *)username password:(NSString *)password block:(void (^)(BOOL , NSError *))block;
- (void)fetchSubscribedSubredditsUsingBlock:(TRVSRedditAPIClientArrayBlock)block;
- (void)fetchSubredditListingWithName:(NSString *)name order:(NSString *)order block:(TRVSRedditAPIClientArrayBlock)block;
- (BOOL)isLoggedIn;

@end
