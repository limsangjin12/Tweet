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
#import "AFHTTPClient.h"
#import "UIImageView+AFNetworking.h"

#define TIMELINE_TWEETS_CACHE_KEY @"timelineTweets"

@implementation TimelineController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tweets = [[CacheObject sharedObject] objectForkey:TIMELINE_TWEETS_CACHE_KEY];
    [self refresh];
}

#pragma mark - Custom Methods

- (void)refresh{
    AFHTTPClient *client = [NetworkObject sharedClient];
    [client getPath:@"4/r"
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id JSON) {
                NSLog(@"%@", JSON);
                [[CacheObject sharedObject] setObject:JSON forkey:TIMELINE_TWEETS_CACHE_KEY];
                self.tweets = JSON;
                [self.tableView reloadData];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error");
            }
    ];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"TweetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    Tweet *tweet = (Tweet*)[self.tweets objectAtIndex:indexPath.row];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        
        UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 32, 32)];
        profileImageView.backgroundColor = [UIColor grayColor];
        profileImageView.tag = 1;
        [cell addSubview:profileImageView];
        
        NSString *body = [Tweet body:tweet];
        CGSize size = [body sizeWithFont:[UIFont systemFontOfSize:12]
                       constrainedToSize:CGSizeMake(250, 200)
                           lineBreakMode:NSLineBreakByWordWrapping];
        UITextView *bodyView = [[UITextView alloc] initWithFrame:CGRectMake(54, 25, 253, size.height + 10)];
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
    bodyView.text = [Tweet body:tweet];
    
    CacheObject *cache = [CacheObject sharedObject];
    __block User *user = [cache getCachedUserForId:[Tweet userId:tweet]];
    if(user == nil){
        AFHTTPClient *client = [NetworkObject sharedClient];
        [client getPath:[NSString stringWithFormat:@"3/r/%d", [Tweet userId:tweet]]
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id JSON) {
                    NSLog(@"%@", JSON);
                    user = JSON;
                    NSString *cacheKey = [NSString stringWithFormat:@"user_%@", [JSON objectForKey:@"id"]];
                    [[CacheObject sharedObject] setObject:user forkey:cacheKey];
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
;