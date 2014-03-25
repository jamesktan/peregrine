//
//  PGNDashCollectionViewCell.m
//  PeregrineBeta
//
//  Created by James Tan on 12/3/12.
//  Copyright (c) 2012 Peregrine. All rights reserved.
//

#import "PGNDashCollectionViewCell.h"
//#import <MessageUI/MFMailComposeViewController.h>

@implementation PGNDashCollectionViewCell

//@synthesize mailViewCont;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { // Initialization code
    //self.mailViewCont = [[MFMailComposeViewController alloc] init];
    
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PGNCell" owner:self options:nil];
    
    if ([arrayOfViews count] < 1) {
        return nil;
    }
    
    if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) { return nil; }
    
    self = [arrayOfViews objectAtIndex:0];
    
    }
    
    return self;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)a_email:(id)sender {
    
    UIImage *anImage = _imageView.image;
    [self.delegate passPhotoToEmail:anImage];
    
//    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//    
//    NSLog(@"EMail");
//    
//    picker.mailComposeDelegate = self;
//    [picker setSubject:@"I have a pencil for you"];
//    
//    UIImage *roboPic = [UIImage imageNamed:@"RobotWithPencil.jpg"];
//    NSData *imageData = UIImageJPEGRepresentation(roboPic, 1);
//    [picker addAttachmentData:imageData mimeType:@"image/jpg" fileName:@"RobotWithPencil.jpg"];
//    
//    NSString *emailBody = @"This is a cool image of a robot I found.  Check it out!";
//    [picker setMessageBody:emailBody isHTML:YES];
//    
//    //[self presentModalViewController:picker animated:YES];
    
}

- (IBAction)a_print:(id)sender {
    [self.delegate passPhotoToPrinter:_imageView.image];
}


//-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
//{
////    [mailViewCont dismissViewControllerAnimated:YES completion:nil];
//}

@end
