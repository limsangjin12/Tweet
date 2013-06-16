//
//  TimelineController.h
//  Tweet
//
//  Created by 임상진 on 13. 6. 16..
//  Copyright (c) 2013년 임상진. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostTweetController.h"

@interface TimelineController : UITableViewController <UITableViewDataSource, UITableViewDelegate, PostTweetControllerDelegate>

@property (assign) BOOL loadOnlyCache;
@property (nonatomic, strong) NSString *timelineCacheKey;
@property (nonatomic, strong) NSURL *dataURL;
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (id)initWithTimelineCacheKey:(NSString*)key loadOnlyCache:(BOOL)cache;
@end
