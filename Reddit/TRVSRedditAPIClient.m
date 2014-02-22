//
//  TRVSRedditAPIClient.m
//  Reddit
//
//  Created by Travis Jeffery on 2/13/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import "TRVSRedditAPIClient.h"

#import <TRVSQueryStringSerializer.h>

#import "TRVSSubreddit.h"

@interface TRVSRedditAPIClient () <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *URLSession;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableDictionary *mutableHTTPRequestHeaders;

@end

@implementation TRVSRedditAPIClient

+ (instancetype)sharedClient {
    static dispatch_once_t onceToken;
    static id client = nil;
    dispatch_once(&onceToken, ^{
        client = [self new];
    });
    return client;
}

- (id)init {
    self = [super init];

    if (self) {
        _operationQueue = [NSOperationQueue new];
        _operationQueue.name = @"com.travisjeffery.reddit.api";
        _URLSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:_operationQueue];
        _mutableHTTPRequestHeaders = [NSMutableDictionary new];
    }

    return self;
}

- (void)loginUsingUsername:(NSString *)username password:(NSString *)password block:(void (^)(BOOL , NSError *))block {
    NSError *error = nil;
    NSDictionary *dictionary = @{ @"user": username, @"passwd": password, @"api_type": @"json" };
    NSURLRequest *request = [self requestWithString:@"api/login" dictionary:dictionary method:@"POST" error:&error];

    if (!request) {
        return block(NO, error);
    }

    NSURLSessionDataTask *task = [self.URLSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([response isKindOfClass:NSHTTPURLResponse.class]) {
            NSHTTPURLResponse *HTTPURLResponse = (NSHTTPURLResponse *)response;
            
            if ([[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)] containsIndex:HTTPURLResponse.statusCode]) {
                NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                
                if (JSON) {
                    [self saveSessionUsingDictionary:JSON[@"json"][@"data"]];
                    
                    block(YES, nil);
                } else {
                    block(NO, error);
                }
            } else {
                block(NO, error);
            }
        }
    }];

    [task resume];
}

- (void)fetchSubscribedSubredditsUsingBlock:(TRVSRedditAPIClientArrayBlock)block {
    NSError *error;
    NSURLRequest *request = [self requestWithString:@"subreddits/mine/subscriber.json" dictionary:nil method:@"GET" error:&error];

    if (!request) {
        return block(nil, error);
    }

    NSURLSessionDataTask *task = [self.URLSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if (!JSON) {
                block(nil, error);
            } else {
                NSArray *array = JSON[@"data"][@"children"];
                NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:array.count];
                
                [array enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL *stop) {
                    [result addObject:[[TRVSSubreddit alloc] initWithDictionary:dictionary[@"data"]]];
                }];
                
                block(result, nil);
            }
        }
    }];

    [task resume];
}

- (NSURL *)URLWithString:(NSString *)string {
    return [NSURL URLWithString:string relativeToURL:[NSURL URLWithString:@"https://ssl.reddit.com/"]];
}

- (NSURLRequest *)requestWithString:(NSString *)string dictionary:(NSDictionary *)dictionary method:(NSString *)method error:(NSError * __autoreleasing *)error {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[self URLWithString:string]];
        
    if ([method isEqualToString:@"POST"]) {
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    
    request.HTTPMethod = method;

    if (dictionary) {
        NSData *data = [[TRVSQueryStringSerializer queryStringUsingDictionary:dictionary] dataUsingEncoding:NSUTF8StringEncoding];
    
        if (!data) {
            return nil;
        }
        
        request.HTTPBody = data;
    }
    
    [self.mutableHTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    return request.copy;
}

- (void)saveSessionUsingDictionary:(NSDictionary *)dictionary {
    if (dictionary[@"modhash"])
        self.mutableHTTPRequestHeaders[@"X-Modhash"] = dictionary[@"modhash"];
    
    if (dictionary[@"cookie"]) {
        NSString *cookie = [NSString stringWithFormat:@"reddit_session=%@", [dictionary[@"cookie"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        self.mutableHTTPRequestHeaders[@"Cookie"] = cookie;
    }
}

@end
