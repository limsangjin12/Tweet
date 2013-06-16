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

@implementation TimelineController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tweets = @[@{@"description": @"요 나는 데니 거리 여자들 나만 쳐다봐 1",
                      @"username": @"DannyJin 1"},
                    @{@"description": @"요 나는 데니 거리 여자들 나만 쳐다봐 2",
                      @"username": @"DannyJin 2"},
                    @{@"description": @"요 나는 데니 거리 여자들 나만 쳐다봐 3",
                      @"username": @"DannyJin 3"},
                    @{@"description": @"요 나는 데니 거리 여자들 나만 쳐다봐 4 요 나는 데니 거리 여자들 나만 쳐다봐 4 요 나는 데니 거리 여자들 나만 쳐다봐 4",
                      @"username": @"DannyJin 4"}];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"TweetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        
        UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 32, 32)];
        profileImageView.backgroundColor = [UIColor grayColor];
        [cell addSubview:profileImageView];
        
        NSString *description = [tweet objectForKey:@"description"];
        CGSize size = [description sizeWithFont:[UIFont systemFontOfSize:12]
                             constrainedToSize:CGSizeMake(250, 200)
                                 lineBreakMode:NSLineBreakByWordWrapping];
        UITextView *descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(54, 25, 253, size.height + 10)];
        descriptionView.font = [UIFont systemFontOfSize:12];
        descriptionView.userInteractionEnabled = NO;
        descriptionView.text = description;
        [cell addSubview:descriptionView];
        
        UILabel *usernameView = [[UILabel alloc] initWithFrame:CGRectMake(58, 8, 153, 20)];
        usernameView.text = [tweet objectForKey:@"username"];
        [cell addSubview:usernameView];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    CGSize size = [[tweet objectForKey:@"description"] sizeWithFont:[UIFont systemFontOfSize:12]
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
