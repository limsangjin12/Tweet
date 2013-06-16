//
//  TWObjects.h
//  Tweet
//
//  Created by 임상진 on 13. 6. 16..
//  Copyright (c) 2013년 임상진. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface TWObject : NSDictionary
+ (NSInteger)objectId:(NSDictionary*)object;
+ (NSString*)createdAt:(NSDictionary*)object;
@end

@interface Tweet : TWObject
+ (NSInteger)userId:(NSDictionary*)object;
+ (NSString*)body:(NSDictionary*)object;
@end

@interface User : TWObject
+ (NSURL*)profilePictureURL:(NSDictionary*)object;
+ (NSString*)username:(NSDictionary*)object;
@end

@interface NetworkObject : NSObject
+ (AFHTTPClient*)sharedClient;
@end

@interface CacheObject : NSObject
+ (CacheObject *)sharedObject;
- (id)objectForkey:(NSString*)key;
- (void)setObject:(id)object forkey:(NSString*)key;
- (void)cacheUser:(User*)user;
- (id)cachedUserForId:(NSInteger)userId;
- (NSMutableArray*)cachedFavorites;
@end