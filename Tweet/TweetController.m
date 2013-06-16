//
//  TweetController.m
//  Tweet
//
//  Created by 임상진 on 13. 6. 16..
//  Copyright (c) 2013년 임상진. All rights reserved.
//

#import "TweetController.h"
#import "UIImageView+AFNetworking.h"

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
    
    NSString *body = [Tweet body:self.tweet];
    CGSize size = [body sizeWithFont:[UIFont systemFontOfSize:12]
                   constrainedToSize:CGSizeMake(250, 200)
                       lineBreakMode:NSLineBreakByWordWrapping];
    UITextView *bodyView = [[UITextView alloc] initWithFrame:CGRectMake(5, 42, 310, size.height + 10)];
    bodyView.font = [UIFont systemFontOfSize:12];
    bodyView.userInteractionEnabled = NO;
    bodyView.text = body;
    [self.contentView addSubview:bodyView];
    
    UILabel *usernameView = [[UILabel alloc] initWithFrame:CGRectMake(48, 3, 163, 20)];
    [self.contentView addSubview:usernameView];
    
    CacheObject *cache = [CacheObject sharedObject];
    __block User *user = [cache getCachedUserForId:[Tweet userId:self.tweet]];
    if(user == nil){
        AFHTTPClient *client = [NetworkObject sharedClient];
        [client getPath:[NSString stringWithFormat:@"3/r/%d", [Tweet userId:self.tweet]]
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id JSON) {
                    NSLog(@"%@", JSON);
                    user = JSON;
                    NSString *cacheKey = [NSString stringWithFormat:@"user_%@", [JSON objectForKey:@"id"]];
                    [[CacheObject sharedObject] setObject:user
                                                   forkey:cacheKey];
                    [profileImageView setImageWithURL:[User profileImageURL:user]];
                    usernameView.text = [User username:user];
                    user = JSON;
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"error");
                }
         ];
    }
    else{
        [profileImageView setImageWithURL:[User profileImageURL:user]];
        usernameView.text = [User username:user];
    }
}

@end
