//
//  PostTweetController.h
//  Tweet
//
//  Created by 임상진 on 13. 6. 16..
//  Copyright (c) 2013년 임상진. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostTweetControllerDelegate <NSObject>
@optional
- (void)didFinishPosting;
@end

@interface PostTweetController : UIViewController

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) id <PostTweetControllerDelegate> delegate;

@end
