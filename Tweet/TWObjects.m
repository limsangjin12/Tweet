//
//  TWObjects.m
//  Tweet
//
//  Created by 임상진 on 13. 6. 16..
//  Copyright (c) 2013년 임상진. All rights reserved.
//

#import "TWObjects.h"
#import "AFJSONRequestOperation.h"

#define ServerBaseURL @"http://54.250.145.45/a/3/t/"

@implementation TWObject
+ (NSInteger)objectId:(NSDictionary*)object{
    return [[object valueForKey:@"id"] intValue];
}
+ (NSString*)createdAt:(NSDictionary*)object{
    return [object objectForKey:@"createdAt"];
}
@end

@implementation Tweet
+ (NSInteger)userId:(NSDictionary*)object{
    return [[object valueForKey:@"userId"] intValue];
}
+ (NSString*)body:(NSDictionary*)object{
    return [object objectForKey:@"body"];
}
@end

@implementation User
+ (NSURL*)profilePictureURL:(NSDictionary*)object{
    return [NSURL URLWithString:[object objectForKey:@"profilepictureurl"]];
}
+ (NSString*)username:(NSDictionary*)object{
    return [object objectForKey:@"username"];
}
@end

@implementation NetworkObject
+ (AFHTTPClient*)sharedClient{
    static AFHTTPClient *client = nil;
    if(client == nil){
        client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:ServerBaseURL]];
        [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [client setDefaultHeader:@"X-SS-User-Id" value:@"4"];
        [client setDefaultHeader:@"Accept" value:@"application/json"];
        [client setDefaultHeader:@"Content-Type" value:@"application/json"];
        [client setParameterEncoding:AFJSONParameterEncoding];
    }
    return client;
}
@end

@implementation CacheObject
+ (CacheObject *)sharedObject{
    static CacheObject *cache = nil;
    if(cache == nil){
        cache = [[CacheObject alloc] init];
    }
    return cache;
}
- (id)objectForkey:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}
- (void)setObject:(id)object forkey:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}
- (void)setValue:(id)value forkey:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
    [defaults synchronize];
}
- (void)cacheUser:(User*)user{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"user_%d", [User objectId:user]];
    [defaults setObject:user forKey:key];
    [defaults synchronize];
}
- (id)cachedUserForId:(NSInteger)userId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"user_%d", userId];
    return [defaults objectForKey:key];
}
- (NSMutableArray*)cachedFavorites{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [NSMutableArray arrayWithArray:[defaults objectForKey:FAVORITES_TWEETS_CACHE_KEY]];
}
@end