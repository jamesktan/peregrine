//
//  PGNCalculateAreaViewController.h
//  PeregrineBeta
//
//  Created by James Tan on 8/7/12.
//  Copyright (c) 2012 Peregrine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGNStandardPatientFormViewController.h" //annotation support
#import "PGNFluidShortViewController.h" // short fluid calc support
#import "PGNResourceManager.h" //filesupport
#import "PGNSerializeViewViewController.h" //serialize support
#import <MediaPlayer/MediaPlayer.h> //photo support

@protocol PGNImageMeasureDelegate <NSObject>

- (void) goHome; //return home
- (void) saveImage; //save image

@end


@interface PGNCalculateAreaViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, PGNPhotoAnnotateDelegate, PGNFluidShortDelegate, PGNSerializeDelegate>
{
    int photoTaken;
    
    int selectedDrawAction; //0 none, 1 scale, 2 burn, 3 limb
    int hasBeenSetup;
    UIImageView *drawImage;
    CGPoint lastPoint;
    CGPoint startPoint, endPoint;

    CGContextRef currentReference;
    float red, green, blue;
    float startDot, endDot, addDot, addDotLimb,ratio;
    NSMutableArray *points, *pointsLimb;
    UIColor *defaultColor;
    
    int burnArea;
    int limbArea;
    int degree;
    int limb;
    float tbsa;
    
    int overlayOnOff;
    
    PGNStandardPatientFormViewController *standardForm;
    PGNFluidShortViewController *shortFluid;
    PGNSerializeViewViewController *serializeViewCont;
    
    PGNResourceManager *resourceManager;
    UIImage *screenCapture;
}


@property (weak, nonatomic) IBOutlet UIView *annotationLayer;
@property (weak, nonatomic) IBOutlet UIView *interfaceLayer;


@property (weak, nonatomic) IBOutlet UITextField *textFieldReference;

@property (weak, nonatomic) IBOutlet UIImageView *measure_imageView;

@property (weak, nonatomic) IBOutlet UILabel *areaValue;
@property (weak, nonatomic) IBOutlet UILabel *areaValueLimb;
@property (weak, nonatomic) IBOutlet UILabel *tbsaValue;

@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UILabel *label_ID;
@property (weak, nonatomic) IBOutlet UILabel *label_degree;
@property (weak, nonatomic) IBOutlet UILabel *label_type;
@property (weak, nonatomic) IBOutlet UILabel *label_location;
@property (weak, nonatomic) IBOutlet UILabel *label_date;

@property (weak, nonatomic) IBOutlet UILabel *annoLabel_name;
@property (weak, nonatomic) IBOutlet UILabel *annoLabel_ID;
@property (weak, nonatomic) IBOutlet UILabel *annoLabel_Degree;
@property (weak, nonatomic) IBOutlet UILabel *annoLabel_Type;
@property (weak, nonatomic) IBOutlet UILabel *annoLabel_burnArea;
@property (weak, nonatomic) IBOutlet UILabel *annoLabel_LimbArea;
@property (weak, nonatomic) IBOutlet UILabel *annoLabel_burnPercent;
@property (weak, nonatomic) IBOutlet UILabel *annoLabel_location;
@property (weak, nonatomic) IBOutlet UILabel *annoLabel_dateTime;
@property (weak, nonatomic) IBOutlet UILabel *annoLabel_POD;
@property (weak, nonatomic) IBOutlet UILabel *annoLabel_Graft;

-(void)loadImage: (UIImage*)image;

-(void)loadPatientName: (NSString*)patientName loadPatientID: (NSString*)patientID;

-(void)clearImageOnViewLoad;
- (float) getLimbBurnPercent;

- (IBAction)doneEditing:(id)sender;

- (UIImage*)getCurrentBlendedImage;
- (NSArray*)getCurrentMeasuredValues;

//the properties below are new!
//for delegation
@property (nonatomic, assign) id<PGNImageMeasureDelegate> delegate;
@property (strong, nonatomic) UIPopoverController *annotationPopover;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) UIPopoverController *serializationPopover;
@property (strong, nonatomic) UIPopoverController *fluidPopover;


@property (strong, nonatomic) MPMoviePlayerController *moviePlayerController;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *movieURL;
@property (copy, nonatomic) NSString *lastChosenMediaType;
@property (assign, nonatomic) CGRect imageFrame;

// the methods below are used for the new buttons
- (IBAction)a_DispatchCenter:(id)sender;


@end
