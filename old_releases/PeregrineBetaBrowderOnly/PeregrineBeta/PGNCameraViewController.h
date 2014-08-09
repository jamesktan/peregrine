//
//  PGNCameraViewController.h
//  PeregrineBeta
//
//  Created by James Tan on 4/23/13.
//  Copyright (c) 2013 Peregrine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGNResourceManager.h"
#import <MediaPlayer/MediaPlayer.h> //photo support

@protocol PGNCameraDelegate <NSObject>
-(void)goHome;
-(void)fireNotice;
@end

@interface PGNCameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate> {
    PGNResourceManager *resourceManager;
    NSString *folderName;
    int first;
    
    int currentTime; //starts at zero, extends for 180 seconds
    
    UIImagePickerController *apickerPointer;

}

@property (nonatomic, weak) id<PGNCameraDelegate> delegate;

-(void)loadPatientName: (NSString*)patientName loadPatientID: (NSString*)patientID;

//timer
@property (strong, nonatomic) NSTimer* alertTimer;

//
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) NSURL *movieURL;
@property (copy, nonatomic) NSString *lastChosenMediaType;
@property (strong, nonatomic) UIImage *image;
//

- (IBAction)action_userChoice:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imageView_picture;

@property (strong, nonatomic) IBOutlet UIView *anno_view;

@property (strong, nonatomic) IBOutlet UILabel *anno_time;
@property (strong, nonatomic) IBOutlet UILabel *anno_id;
@property (strong, nonatomic) IBOutlet UILabel *anno_name;
@property (strong, nonatomic) IBOutlet UIImageView *anno_image;

@property (strong, nonatomic) IBOutlet UIButton *button_continue;
@property (strong, nonatomic) IBOutlet UIButton *button_done;
@property (strong, nonatomic) IBOutlet UILabel *label_patientName;
@property (strong, nonatomic) IBOutlet UILabel *label_patientID;
@end
