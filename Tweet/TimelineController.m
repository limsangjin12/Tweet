//
//  TimelineController.m
//  Tweet
//
//  Created by 임상진 on 13. 6. 16..
//  Copyright (c) 2013년 임상진. All rights reserved.
//

#import "TimelineController.h"
#import "TWObjects.h"
#import "TweetController.h"
#import "UIImageView+AFNetworking.h"

@implementation TimelineController

- (id)initWithTimelineCacheKey:(NSString*)key loadOnlyCache:(BOOL)cache{
    self = [super init];
    if(self){
        self.timelineCacheKey = key;
        self.loadOnlyCache = cache;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!self.loadOnlyCache)
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                               target:self
                                                                                               action:@selector(postTweet)];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    self.tweets = [[CacheObject sharedObject] objectForkey:self.timelineCacheKey];
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.loadOnlyCache)
        [self refresh];
}

#pragma mark - Custom Methods

- (void)refresh{
    if(!self.loadOnlyCache){
        [self.refreshControl beginRefreshing];
        AFHTTPClient *client = [NetworkObject sharedClient];
        [client getPath:@"4/r"
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id JSON) {
                    NSLog(@"%@", JSON);
                    [[CacheObject sharedObject] setObject:JSON forkey:self.timelineCacheKey];
                    self.tweets = JSON;
                    [self.tableView reloadData];
                    [self.refreshControl endRefreshing];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"error");
                    [self.refreshControl endRefreshing];
                }
        ];
    }
    else{
        self.tweets = [[CacheObject sharedObject] objectForkey:self.timelineCacheKey];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }
}

- (void)postTweet{
    PostTweetController *postTweet = [[PostTweetController alloc] init];
    postTweet.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postTweet];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - PostTweetControllerDelegate

- (void)didFinishPosting{
    [self refresh];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"TweetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    Tweet *tweet = (Tweet*)[self.tweets objectAtIndex:indexPath.row];
    NSString *body = [Tweet body:tweet];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        
        UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 32, 32)];
        profileImageView.backgroundColor = [UIColor grayColor];
        profileImageView.tag = 1;
        [cell addSubview:profileImageView];
        
        UITextView *bodyView = [[UITextView alloc] init];
        bodyView.font = [UIFont systemFontOfSize:12];
        bodyView.userInteractionEnabled = NO;
        bodyView.tag = 2;
        [cell addSubview:bodyView];
        
        UILabel *usernameView = [[UILabel alloc] initWithFrame:CGRectMake(58, 8, 153, 20)];
        usernameView.tag = 3;
        [cell addSubview:usernameView];
    }
    UIImageView *profileImageView = (UIImageView*)[cell viewWithTag:1];
    UITextView *bodyView = (UITextView*)[cell viewWithTag:2];
    UILabel *usernameView = (UILabel*)[cell viewWithTag:3];
    CGSize size = [body sizeWithFont:[UIFont systemFontOfSize:12]
                   constrainedToSize:CGSizeMake(250, 200)
                       lineBreakMode:NSLineBreakByWordWrapping];
    bodyView.frame = CGRectMake(54, 25, 253, size.height + 10);
    bodyView.text = [Tweet body:tweet];
    
    CacheObject *cache = [CacheObject sharedObject];
    __block User *user = [cache cachedUserForId:[Tweet userId:tweet]];
    if(user == nil){
        AFHTTPClient *client = [NetworkObject sharedClient];
        [client getPath:[NSString stringWithFormat:@"3/r/%d", [Tweet userId:tweet]]
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id JSON) {
                    NSLog(@"%@", JSON);
                    user = JSON;
                    [cache cacheUser:user];
                    [profileImageView setImageWithURL:[User profilePictureURL:user]];
                    usernameView.text = [User username:user];
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
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    CGSize size = [[Tweet body:tweet] sizeWithFont:[UIFont systemFontOfSize:12]
                                 constrainedToSize:CGSizeMake(250, 200)
                                     lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + 40;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    TweetController *tweetController = [[TweetController alloc] initWithTweet:tweet];
    [self.navigationController pushViewController:tweetController animated:YES];
}

@end