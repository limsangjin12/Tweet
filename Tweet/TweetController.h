//
//  TweetController.h
//  Tweet
//
//  Created by 임상진 on 13. 6. 16..
//  Copyright (c) 2013년 임상진. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWObjects.h"

@interface TweetController : UIViewController

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) Tweet *tweet;

- (id)initWithTweet:(Tweet*)tweet;
@end
