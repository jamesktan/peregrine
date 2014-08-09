//
//  PGNTutorialViewController.h
//  PeregrineBeta
//
//  Created by James Tan on 2/4/13.
//  Copyright (c) 2013 Peregrine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PGNTutorialDelegate <NSObject>
-(void)goHome;
@end

@interface PGNTutorialViewController : UIViewController

- (IBAction)action_home:(id)sender;
@property (nonatomic, assign) id<PGNTutorialDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll_scrollView;
@property (strong, nonatomic) IBOutlet UIView *view_contentView;

@end
