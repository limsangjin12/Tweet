//
//  TWObjects.h
//  Tweet
//
//  Created by 임상진 on 13. 6. 16..
//  Copyright (c) 2013년 임상진. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWObject : NSDictionary
- (NSString*)type;
- (NSString*)createdAt;
@end

@interface Tweet : TWObject
- (NSString*)username;
- (NSString*)description;
- (NSURL*)profileImageURL;
@end
