//
//  PGNDashCollectionViewCell.h
//  PeregrineBeta
//
//  Created by James Tan on 12/3/12.
//  Copyright (c) 2012 Peregrine. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MessageUI/MessageUI.h>
//#import <MessageUI/MFMailComposeViewController.h>

@protocol TheDelegate <NSObject>
-(void)passPhotoToEmail: (UIImage*)image;
-(void)passPhotoToPrinter:(UIImage *)image;
@end

@interface PGNDashCollectionViewCell : UICollectionViewCell {
    //MFMailComposeViewController *mailViewCont;
}
@property (strong, nonatomic) id<TheDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *a_label;
@property (nonatomic, strong) UIImage *photo;
//@property (strong, nonatomic) MFMailComposeViewController *mailViewCont;
- (IBAction)a_email:(id)sender;
- (IBAction)a_print:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *b_email;
@property (strong, nonatomic) IBOutlet UIButton *b_print;

@end
