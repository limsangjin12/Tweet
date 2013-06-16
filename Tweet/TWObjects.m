//
//  TWObjects.m
//  Tweet
//
//  Created by 임상진 on 13. 6. 16..
//  Copyright (c) 2013년 임상진. All rights reserved.
//

#import "TWObjects.h"

@implementation TWObject
- (NSString*)type {
    return [self objectForKey:@"__type__"];
}
- (NSString*)createdAt {
    return [self objectForKey:@"createdAt"];
}
@end

@implementation Tweet
- (NSString*)description {
    return [self objectForKey:@"description"];
}
- (NSString*)username {
    return [self objectForKey:@"username"];
}
- (NSURL*)profileImageURL {
    return [NSURL URLWithString:[self objectForKey:@"profileImageUrl"]];
}
@end