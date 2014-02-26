//
//  TRVSKeychain.m
//  Reddit
//
//  Created by Travis Jeffery on 2/23/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import "TRVSKeychain.h"

@import Security;

@interface TRVSKeychainItem : NSObject

@property (nonatomic, copy) NSString *service;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;

- (instancetype)initWithService:(NSString *)service account:(NSString *)account;
- (BOOL)fetch:(NSError * __autoreleasing *)error;
- (BOOL)save:(NSError * __autoreleasing *)error;

@end

@implementation TRVSKeychainItem

#pragma mark - Public

- (instancetype)initWithService:(NSString *)service account:(NSString *)account {
    self = [super init];

    if (self) {
        _service = [service copy];
        _account = [account copy];
        _password = nil;
    }

    return self;
}

- (BOOL)save:(NSError *__autoreleasing *)error {
    OSStatus status;
    CFTypeRef result;

    [self deleteItem:nil];

    NSMutableDictionary *query = [self query];
    query[(__bridge id)kSecValueData] = [self.password dataUsingEncoding:NSUTF8StringEncoding];
    status = SecItemAdd((__bridge CFDictionaryRef)query, &result);

    if (status != errSecSuccess && error != NULL)
        *error = [self.class errorWithCode:status];

    return (status == errSecSuccess);
}

- (BOOL)deleteItem:(NSError *__autoreleasing *)error {
    OSStatus status;

    NSMutableDictionary *query = [self query];
    status = SecItemDelete((__bridge CFDictionaryRef)query);

    if (status != errSecSuccess && error != NULL)
        *error = [self.class errorWithCode:status];

    return (status == errSecSuccess);
}

- (BOOL)fetch:(NSError *__autoreleasing *)error {
    OSStatus status;
    CFTypeRef result = NULL;

    NSMutableDictionary *query = [self query];
    query[(__bridge id)kSecReturnData] = @YES;
    query[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
  
    if (status != errSecSuccess && error != NULL) {
        *error = [self.class errorWithCode:status];
        return NO;
    }

    self.password = [[NSString alloc] initWithData:(__bridge NSData *)(result) encoding:NSUTF8StringEncoding];

    return YES;
}

#pragma mark - Private

- (NSMutableDictionary *)query {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];

    dictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    dictionary[(__bridge id)kSecAttrService] = self.service;
    dictionary[(__bridge id)kSecAttrAccount] = self.account;

    return dictionary;
}

+ (NSError *)errorWithCode:(OSStatus)code {
    return nil;
}

@end

@implementation TRVSKeychain

+ (NSString *)passwordForService:(NSString *)service account:(NSString *)account {
    return [self passwordForService:service account:account error:NULL];
}

+ (NSString *)passwordForService:(NSString *)service account:(NSString *)account error:(NSError * __autoreleasing *)error {
    TRVSKeychainItem *keychainItem = [[TRVSKeychainItem alloc] initWithService:service account:account];
    [keychainItem fetch:error];

    return keychainItem.password;
}

+ (BOOL)setPassword:(NSString *)password service:(NSString *)service account:(NSString *)account {
    TRVSKeychainItem *keychainItem = [[TRVSKeychainItem alloc] initWithService:service account:account];
    keychainItem.password = password;

    return [keychainItem save:NULL];
}


@end
