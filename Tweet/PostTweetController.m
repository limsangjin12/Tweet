//
//  PostTweetController.m
//  Tweet
//
//  Created by 임상진 on 13. 6. 16..
//  Copyright (c) 2013년 임상진. All rights reserved.
//

#import "PostTweetController.h"
#import "TWObjects.h"

@implementation PostTweetController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Tweet!";
    self.view.backgroundColor = [UIColor whiteColor];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - 44)];
    self.textView.contentSize = CGSizeMake(320, self.view.bounds.size.height - 44);
    [self.view addSubview:self.textView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(dismissViewController)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(postTweet)];
}

#pragma makr - Custom Methods

- (void)dismissViewController{
    [self.delegate didFinishPosting];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)postTweet{
    AFHTTPClient *client = [NetworkObject sharedClient];
    [client putPath:@"4/r"
         parameters:@{@"body": self.textView.text,
                      @"user_id": @7}
            success:^(AFHTTPRequestOperation *operation, id JSON) {
                NSLog(@"%@", JSON);
                [self dismissViewController];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error");
            }
    ];
}

@end
