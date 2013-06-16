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
    UITextView *bodyView = [[UITextView alloc] initWithFrame:CGRectMake(5, 42, 275, size.height + 10)];
    bodyView.font = [UIFont systemFontOfSize:12];
    bodyView.userInteractionEnabled = NO;
    bodyView.text = body;
    [self.contentView addSubview:bodyView];
    
    UILabel *usernameView = [[UILabel alloc] initWithFrame:CGRectMake(48, 3, 163, 20)];
    [self.contentView addSubview:usernameView];
    
    UIButton *likeButton = [[UIButton alloc] initWithFrame:CGRectMake(285, 5, 30, 30)];
    [likeButton setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    [likeButton setImage:[UIImage imageNamed:@"heart-selected"] forState:UIControlStateSelected];
    [likeButton addTarget:self action:@selector(likeButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:likeButton];
    
    CacheObject *cache = [CacheObject sharedObject];
    __block User *user = [cache cachedUserForId:[Tweet userId:self.tweet]];
    if(user == nil){
        AFHTTPClient *client = [NetworkObject sharedClient];
        [client getPath:[NSString stringWithFormat:@"3/r/%d", [Tweet userId:self.tweet]]
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id JSON) {
                    NSLog(@"%@", JSON);
                    user = JSON;
                    [cache cacheUser:user];
                    [profileImageView setImageWithURL:[User profilePictureURL:user]];
                    usernameView.text = [User username:user];
                    self.title = [User username:user];
                    user = JSON;
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"error");
                }
         ];
    }
    else{
        [profileImageView setImageWithURL:[User profilePictureURL:user]];
        usernameView.text = [User username:user];
        self.title = [User username:user];
    }
}

#pragma mark - Custom Methods

- (void)likeButtonTouched:(UIButton*)button{
    if(!button.selected){
        CacheObject *cache = [CacheObject sharedObject];
        NSMutableArray *favorites = [cache cachedFavorites];
        [favorites addObject:self.tweet];
        [cache setObject:favorites forkey:FAVORITES_TWEETS_CACHE_KEY];
        button.selected = YES;
    }
}

@end
