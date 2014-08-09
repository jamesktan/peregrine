//
//  PGNBrowderViewController.h
//  PeregrineBeta
//
//  Created by James Tan on 2/23/13.
//  Copyright (c) 2013 Peregrine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGNBrowderModel.h"
#import "PGNFluidShortViewController.h" // short fluid calc support
#import "PGNResourceManager.h" //filesupport


@protocol PGNBrowderDelegate <NSObject>

- (void) goHome; //return home
- (void) saveImage; //return home

@end

@interface PGNBrowderViewController : UIViewController <UIPopoverControllerDelegate, PGNFluidShortDelegate> {
    
    PGNBrowderModel *browder_model;
    PGNResourceManager *resource_manager;
    PGNFluidShortViewController *fluid_model;
    
    UIImageView *drawImage_rear, *drawImage_front;
    BOOL mouseSwiped;
    CGPoint lastPoint;
    float red, green, blue, pointsize;
    CGContextRef currentReference;
    
    float l_red, l_green, l_blue, l_pointsize; //storage of previous settings
    
    int activeImage;
    UIImageView *activeImageView;
    
    int eraseActive;
    int degree;
    
    int recalculationFlag;
    int saveHomeFlag;
    //NSMutableArray *stackOfGraphicContexts;
        
}

@property (nonatomic, assign) id<PGNBrowderDelegate> delegate;


-(void) loadPatientName: (NSString*)patientName loadPatientID:(NSString*)patientID;

- (IBAction)action_tools:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *button_size_button;
@property (strong, nonatomic) IBOutlet UIButton *button_degree;

@property (strong, nonatomic) IBOutlet UIView *display_view;

@property (strong, nonatomic) IBOutlet UIView *view_drawing_front;
@property (strong, nonatomic) IBOutlet UIView *view_drawing_rear;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_browder;

@property (strong, nonatomic) IBOutlet UILabel *label_patientName;
@property (strong, nonatomic) IBOutlet UILabel *label_patientID;
@property (strong, nonatomic) IBOutlet UITextView *textView_areaCalculations;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *calculation_progress;

@property (strong, nonatomic) UIPopoverController *fluidPopover;
@property (strong, nonatomic) IBOutlet UIButton *button_save;

// outlets for saving.
@property (strong, nonatomic) IBOutlet UIView *browder_save_view;
@property (strong, nonatomic) IBOutlet UILabel *a_patientName;
@property (strong, nonatomic) IBOutlet UILabel *a_patientID;
@property (strong, nonatomic) IBOutlet UITextView *a_textArea;
@property (strong, nonatomic) IBOutlet UIImageView *a_front_image;
@property (strong, nonatomic) IBOutlet UIImageView *a_rear_image;
@property (strong, nonatomic) IBOutlet UILabel *a_time;

@end
