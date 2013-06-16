//
//  TweetController.m
//  Tweet
//
//  Created by 임상진 on 13. 6. 16..
//  Copyright (c) 2013년 임상진. All rights reserved.
//

#import "TweetController.h"

@implementation TweetController

- (id)initWithTweet:(Tweet*)tweet{
    self = [super init];
    if(self){
        self.tweet = tweet;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.contentView.contentSize = CGSizeMake(self.view.bounds.size.width,
                                              self.view.bounds.size.height - 120);
    [self.view addSubview:self.contentView];
    
    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 32, 32)];
    profileImageView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:profileImageView];
    
    NSString *description = [self.tweet objectForKey:@"description"];
    CGSize size = [description sizeWithFont:[UIFont systemFontOfSize:12]
                          constrainedToSize:CGSizeMake(250, 200)
                              lineBreakMode:NSLineBreakByWordWrapping];
    UITextView *descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(5, 42, 310, size.height + 10)];
    descriptionView.font = [UIFont systemFontOfSize:12];
    descriptionView.userInteractionEnabled = NO;
    descriptionView.text = description;
    [self.contentView addSubview:descriptionView];
    
    UILabel *usernameView = [[UILabel alloc] initWithFrame:CGRectMake(48, 3, 163, 20)];
    usernameView.text = [self.tweet objectForKey:@"username"];
    [self.contentView addSubview:usernameView];
}

@end
