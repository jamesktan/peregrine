//
//  PGNViewController.h
//  PeregrineBeta
//
//  Created by James Tan on 8/7/12.
//  Copyright (c) 2012 Peregrine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGNDashViewController.h"
#import "PGNAddSelectViewController.h"
#import "PGNCalculateAreaViewController.h"
#import "PGNBrowderViewController.h"
#import "PGNFluidCalculatorViewController.h"
#import "PGNTutorialViewController.h"
#import "PGNResourceManager.h"
#import "PGNCameraViewController.h"

//#import <MediaPlayer/MediaPlayer.h> //photo support


@class PGNCalculateAreaViewController;
@class PGNBrowderViewController;
@class PGNCameraViewController;
@class PGNDashViewController;
@class PGNFluidCalculatorViewController;
@class PGNAddSelectViewController;
@class PGNTutorialViewController;

@protocol PGNViewDelegate <NSObject>

-(void)returnToMain;

@end

@interface PGNViewController : UIViewController <UIPopoverControllerDelegate, PGNSelectOrAddPatient, PGNImageMeasureDelegate, PGNFluidDelegate, PGNDashDelegate, PGNTutorialDelegate, PGNBrowderDelegate, PGNCameraDelegate> {
//, UIImagePickerControllerDelegate, UINavigationControllerDelegate> { //camera stuff remove
        
    NSString*patientName, *patientID;
    NSMutableArray *currentPatientData;
    PGNResourceManager *resourceManager;
    
    int currentTime; //starts at zero, extends for 180 seconds
}

- (IBAction)action_quick_camera:(id)sender;

@property (nonatomic, weak) id<PGNViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

//@property (strong, nonatomic) PGNMainPageViewController *mainViewCont;
@property (strong, nonatomic) PGNCalculateAreaViewController *imageCalculateCont;
@property (strong, nonatomic) PGNBrowderViewController *browderCont;
@property (strong, nonatomic) PGNDashViewController *dashCont;
@property (strong, nonatomic) PGNFluidCalculatorViewController *fluidCont;
@property (strong, nonatomic) PGNAddSelectViewController *addSelectPatientCont;
@property (strong, nonatomic) PGNTutorialViewController *tutorCont;
@property (strong, nonatomic) PGNCameraViewController *cameraCont;

@property (nonatomic, retain) UIPopoverController *patientListPopover;




// Camera Stuff, removing.
/////
//@property (strong, nonatomic) UIPopoverController *popover;
//@property (strong, nonatomic) NSURL *movieURL;
//@property (copy, nonatomic) NSString *lastChosenMediaType;
//@property (strong, nonatomic) UIImage *image;

/////

@property (strong, nonatomic) IBOutlet UIButton *camera_quick;

@property (weak, nonatomic) IBOutlet UIButton *w_dash;
@property (weak, nonatomic) IBOutlet UIButton *w_browder;
@property (weak, nonatomic) IBOutlet UIButton *w_fluid;
@property (weak, nonatomic) IBOutlet UIButton *w_camera;

@property (strong, nonatomic) IBOutlet UILabel *label_patientID;
@property (strong, nonatomic) IBOutlet UILabel *label_patientName;

- (IBAction)returnHome:(id)sender;

-(IBAction)switchViews:(id)sender;
-(void)startNewPatient;
-(void)loadExistingPatient: (NSString*)patient_id pathentName:(NSString*)patient_name;
@property (weak, nonatomic) IBOutlet UIImageView *measure_imageView;

@end
