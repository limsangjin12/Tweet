//
//  TimelineController.h
//  Tweet
//
//  Created by 임상진 on 13. 6. 16..
//  Copyright (c) 2013년 임상진. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property NSURL *tweetUrl;
@property NSArray *tweets;

@end
