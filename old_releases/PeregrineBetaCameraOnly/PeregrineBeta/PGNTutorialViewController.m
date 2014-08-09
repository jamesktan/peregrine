//
//  PGNTutorialViewController.m
//  PeregrineBeta
//
//  Created by James Tan on 2/4/13.
//  Copyright (c) 2013 Peregrine. All rights reserved.
//

#import "PGNTutorialViewController.h"

@interface PGNTutorialViewController ()

@end

@implementation PGNTutorialViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


// Orientation Control 
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

-(BOOL)shouldAutorotate {
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}
// End Orientation Control

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIView *selectionSubView = _view_contentView;
    int offSetVal = 0; //this is so that we can scroll up, in case we have a keyboard out.
    _scroll_scrollView.contentSize = CGSizeMake(selectionSubView.frame.size.width, selectionSubView.frame.size.height + offSetVal);
    [_scroll_scrollView addSubview:selectionSubView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)action_home:(id)sender {
    [self.delegate goHome];
}
@end
