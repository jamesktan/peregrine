//
//  PGNViewController.m
//  PeregrineBeta
//
//  Created by James Tan on 8/7/12.
//  Copyright (c) 2012 Peregrine. All rights reserved.
//

#import "PGNViewController.h"

//#import <MobileCoreServices/UTCoreTypes.h>
//#import <QuartzCore/QuartzCore.h>


@interface PGNViewController ()//(UtilityMethods)
//- (void) updateDisplay;
//- (void) getMediaFromSource: (UIImagePickerControllerSourceType) sourceType;

@end

@implementation PGNViewController

//@synthesize mainViewCont;
@synthesize imageCalculateCont;
@synthesize browderCont;
@synthesize dashCont;
@synthesize fluidCont;
@synthesize addSelectPatientCont;
@synthesize tutorCont;
@synthesize cameraCont;
@synthesize patientListPopover;
@synthesize delegate;


- (void)viewDidLoad
{    
    resourceManager = [[PGNResourceManager alloc] init];

    currentPatientData = [[NSMutableArray alloc]init];

    _label_patientID.text = patientName;
    _label_patientName.text = patientID;
    
    // This is the code for gesture recognition, we don't use it anymore
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
//    [doubleTap setNumberOfTapsRequired:2];
//    [doubleTap setDelaysTouchesBegan:NO];
//    [_selectButton addGestureRecognizer:doubleTap];
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}
////////////////\\\\\\\\\\\\\\\\\\\\\\\\\
/// Start Support for Double Tab Quick Start
//- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
//    // double tap zooms in
//    NSLog(@"ViewController: handlerDoubltTap: QuickMode ON!");
//    
//    [[[UIAlertView alloc] initWithTitle:@"Quick Start!" message:@"Starting with a default case" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
//    patientName = @"Default";
//    patientID = @"0000000";
//    
//    _label_patientID.text = patientName;
//    _label_patientName.text = patientID;
//    
//    [self.browderCont loadPatientName: patientName loadPatientID: patientID];
//    [self.imageCalculateCont loadPatientName: patientName loadPatientID: patientID];
//    [self.fluidCont loadPatientName: patientName loadPatientID: patientID];
//
//}
//////////////
//END

////////////////\\\\\\\\\\\\\\\\\\\\\\\\\
/// Start Suport for Orientation
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

-(BOOL)shouldAutorotate {
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
/////////////////
//END

-(void) startCameraWorkflow {
    self.cameraCont = [[PGNCameraViewController alloc] initWithNibName:@"PGNCameraViewController" bundle:nil];
    self.cameraCont.delegate = self;
}
-(void) startMeasureWorkflow {
    self.imageCalculateCont = [[PGNCalculateAreaViewController alloc] initWithNibName:@"PGNCalculateAreaViewController" bundle:nil];
    self.imageCalculateCont.delegate = self;
}

-(void) startBrowderDiagramWorkflow {
    self.browderCont = [[PGNBrowderViewController alloc] initWithNibName:@"PGNBrowderViewController" bundle:nil];
    self.browderCont.delegate = self; //WIP
}

-(void) startDashboardWorkflow {
    self.dashCont = [[PGNDashViewController alloc] initWithNibName:@"PGNDashViewController" bundle:nil];
    self.dashCont.delegate = self; //not yet
}

-(void) startFluidWorkflow {
    self.fluidCont = [[PGNFluidCalculatorViewController alloc] initWithNibName:@"PGNFluidCalculatorViewController" bundle:nil];
    fluidCont.delegate = self;
}

-(void) startAddSelectPatientWorkflow {
    self.addSelectPatientCont = [[PGNAddSelectViewController alloc] initWithNibName:@"PGNAddSelectViewController" bundle:nil];
    addSelectPatientCont.delegate = self;
}

-(void) startTutorial {
    self.tutorCont = [[PGNTutorialViewController alloc] initWithNibName:@"PGNTutorialViewController" bundle:nil];
    tutorCont.delegate = self;
}
-(void) endWorkflows {
    self.addSelectPatientCont = NULL;
    self.fluidCont = NULL;
    self.dashCont = NULL;
    self.browderCont = NULL;
    self.imageCalculateCont = NULL;
    self.tutorCont = NULL;
    self.cameraCont = NULL;
}
///// END

- (IBAction)returnHome:(id)sender {
    NSLog(@"Returning to Home");
    [self.delegate returnToMain];
}

- (IBAction)switchViews:(id)sender {
    
    NSString *buttontTitle = [sender currentTitle];
    NSLog(@"Workflow: %@ Selected",buttontTitle);
    
    [self startDashboardWorkflow];
    [self startAddSelectPatientWorkflow];
    [self startBrowderDiagramWorkflow];
    [self startMeasureWorkflow];
    [self startFluidWorkflow];
    [self startTutorial];
    
    if ( [buttontTitle isEqualToString:@"Dashboard"]) {
        NSLog(@"Loading Dashboard...");
        
        self.dashCont.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:self.dashCont animated:YES completion:nil];
        
    }
    if ([buttontTitle isEqualToString: @"Browder"]){
        NSLog(@"Loading Browder Workflow...");       

        self.browderCont.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:self.browderCont animated:YES completion:nil];
        [self.browderCont loadPatientName: patientName loadPatientID: patientID]; 

    }
    if([buttontTitle isEqualToString: @"Fluids"]) {
        NSLog(@"Loading Fluids Workflow...");
        
        self.fluidCont.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:self.fluidCont animated:YES completion:nil];
        [self.fluidCont loadPatientName: patientName loadPatientID:patientID];

        
    }
    if([buttontTitle isEqualToString: @"AddSelectPatient"]) {
        NSLog(@"Edit");
        
        self.addSelectPatientCont.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:self.addSelectPatientCont animated:YES completion:nil];
        [self.addSelectPatientCont loadPatientName: patientName loadPatientID:patientID];
    }
    
    if ([buttontTitle isEqualToString:@"Measure"]) {
        NSLog(@"Loaging Measure Workflow...");

        self.imageCalculateCont.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:self.imageCalculateCont animated:YES completion:nil];
        [self.imageCalculateCont loadPatientName: patientName loadPatientID:patientID];
        
        
    }
    if ([buttontTitle isEqualToString:@"Tutorial"]) {
        self.tutorCont.modalTransitionStyle =UIModalTransitionStyleCoverVertical;
        [self presentViewController:self.tutorCont animated:YES completion:nil];
    }
    
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark PGNPatientListDelegate delegate

-(void)didSelectRow {

//    patientName = [patientListController getSelectedPatient];
//    
//    NSLog(@"The current patient is: %@", patientName);
//    
//    //[imageAnnotateCont setPatientInfo: currentPatient];
//    [fluidCont setPatientInfo: patientName];
//    
//    [patientListPopover dismissPopoverAnimated:YES];
}

#pragma mark -
#pragma mark PGNDashDelegate delegate
//-(void)serializeImage {
//    //initiate the image capture workflow
//    
//    NSString *storeImage = [self.dashboardCont getSelectedImage];
//    NSLog(@"The current %@", storeImage);
//
//    [UIView beginAnimations:@"View Flip" context:nil];
//    [UIView setAnimationDuration:0.50];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
//
//    [UIView commitAnimations];
//}

#pragma mark PGNImageSomething delegate
- (void) executeHome {
    //end take picture with home
    [self.browderCont dismissViewControllerAnimated:YES completion:nil];
    [self.fluidCont dismissViewControllerAnimated:YES completion:nil];
    [self.imageCalculateCont dismissViewControllerAnimated:YES completion:nil];
    [self.addSelectPatientCont dismissViewControllerAnimated:YES completion:nil];
    [self.dashCont dismissViewControllerAnimated:YES completion:nil];
    [self.tutorCont dismissViewControllerAnimated:YES completion:nil];
    [self endWorkflows];
}
-(void) saveImage {
    //end take picture with save
    NSLog(@"saveimage!");
    [[[UIAlertView alloc] initWithTitle:@"Saved!" message:@"Your data was saved!" delegate:nil cancelButtonTitle:@"Continue" otherButtonTitles: nil] show];
    [self.browderCont dismissViewControllerAnimated:YES completion:nil];
    [self.fluidCont dismissViewControllerAnimated:YES completion:nil];
    [self.imageCalculateCont dismissViewControllerAnimated:YES completion:nil];
    [self.addSelectPatientCont dismissViewControllerAnimated:YES completion:nil];
    [self.dashCont dismissViewControllerAnimated:YES completion:nil];
    [self endWorkflows];
}

#pragma mark PGNCalculateArea delegate
- (void) goHome {
    //end take picture with home
    [self.browderCont dismissViewControllerAnimated:YES completion:nil];
    [self.fluidCont dismissViewControllerAnimated:YES completion:nil];
    [self.imageCalculateCont dismissViewControllerAnimated:YES completion:nil];
    [self.addSelectPatientCont dismissViewControllerAnimated:YES completion:nil];
    [self.dashCont dismissViewControllerAnimated:YES completion:nil];
    [self.tutorCont dismissViewControllerAnimated:YES completion:nil];
    [self.cameraCont dismissViewControllerAnimated:YES completion:nil];

    [self endWorkflows];
}

-(void)startNewPatient {    
    NSLog(@"A new patient is being created.");

    // Start the resource manager
    // Create a new case name
    // Assign the patient name and ID
    // Create an empty text field
    // Create a temp array
    // Create a new patient folder
    
    resourceManager = [[PGNResourceManager alloc] init];
    NSString *caseTime = [resourceManager getTime];
    NSString *base = [@"None - " stringByAppendingString: caseTime];
    
    patientID = @"None";
    patientName = caseTime;
    
    _label_patientID.text = patientID;
    _label_patientName.text = patientName;
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int a=0 ; a < 17; a++) {
        UITextField *emptyTextField = [[UITextField alloc] init];
        emptyTextField.text = @" ";
        [temp addObject:emptyTextField];
    }
    
    [resourceManager savePatient:base data:temp];

    
    return;
}
-(void)loadExistingPatient: (NSString*)patient_id pathentName:(NSString*)patient_name {
    NSLog(@"Loading existing patient!");
    // set the current patient name to the above
    patientName = patient_name;
    patientID = patient_id;
    
    _label_patientID.text = patientName;
    _label_patientName.text = patientID;
    
    return;
}

-(void) savedPatient {
    NSLog(@"ViewController: savedPatient: Saved or Selected a Patient!");
    NSArray *temp = [self.addSelectPatientCont returnPatientDetails];
    patientName = [temp objectAtIndex:0];
    patientID = [temp objectAtIndex:1];

    _label_patientID.text = patientName;
    _label_patientName.text = patientID;
        
    [self goHome];
}

////////
////////
////////
////////
////////
////////

- (IBAction)action_quick_camera:(id)sender {
    [self startTimer];
    [self startCameraWorkflow];
    self.cameraCont.modalTransitionStyle =UIModalTransitionStyleCoverVertical;
    [self presentViewController:self.cameraCont animated:YES completion:nil];
    [self.cameraCont loadPatientName: patientName loadPatientID:patientID];

    
    //[self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    //[self startMeasureWorkflow];
    //[self presentViewController:self.imageCalculateCont animated:YES completion:nil];
    //[self.imageCalculateCont loadPatientName: patientName loadPatientID:patientID];
    //[self.imageCalculateCont a_DispatchCenter:_camera_quick];
    
}

//-(void) getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
//{
//    //taking photos
//    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
//    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0)
//    {
//        //NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType]; //removed to only support camera and not any video.
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
//        picker.delegate = self;
//        picker.allowsEditing = NO;//yes works, no breaks this?
//        picker.sourceType = sourceType;
//        
//        if (sourceType == UIImagePickerControllerSourceTypeCamera)
//        {
//            UIView *overlayView = [[UIView alloc] initWithFrame:picker.view.frame];
//            
//            UIImage *tempImage = [UIImage imageWithCGImage:_measure_imageView.image.CGImage scale:1.0 orientation:_measure_imageView.image.imageOrientation];
//            
//            UIImageView *viewer= [[UIImageView alloc] initWithImage:tempImage];
//            
//            [viewer setFrame:CGRectMake(0, 0, 1024, 768)];
//            
//            int overlayOnOff = 0;
//            //overlay stuff
//            if (!overlayOnOff) {
//                //[overlayView addSubview:viewer];
//                //overlayOnOff = 1; // may want to remove this
//                
//            }
//            overlayView.alpha = .35;
//            if (overlayOnOff == 1) {
//                [overlayView addSubview:viewer];
//                NSLog(@"The overlay is on!");
//                picker.cameraOverlayView = overlayView; //- ,,,,,,,
//                [picker.view.window addSubview:overlayView];
//                [picker.view.window insertSubview:overlayView atIndex:1];
//                
//            }
//            
//            [self presentViewController:picker animated:YES completion:nil];
//            
//        } else
//        {
//            _popover = [[UIPopoverController alloc] initWithContentViewController:picker];
//            [_popover presentPopoverFromRect:CGRectMake(100, 150, 100, 500) inView:self.view permittedArrowDirections:0 animated:YES];
//        }
//        
//        
//    } else
//    {
//        [[[UIAlertView alloc]
//          initWithTitle: @"Error accessing media"
//          message:@"Device doesn't support that media source"
//          delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
//    }
//}
//
//-(void)updateDisplay
//{
//    // Save Photo
//    //resourceManager
//    NSLog(@"Display");
//    _measure_imageView.image = [self imagePickerImage:_image];
//
//    if ([self imagePickerImage:_image] == NULL) {
//        NSLog(@"something broke!");
//    }
//    [resourceManager savePhotoToLibrary:[self imagePickerImage:_image]];
//    
//    NSString *folderName = [[patientID stringByAppendingString:@" - "] stringByAppendingString:patientName];
//    NSArray *dataArray = [[NSArray alloc] initWithObjects:patientName, @"temp", @"n", @"n", @"n", @"Temp", nil];
//
//    
//    [resourceManager savePhoto:folderName data:dataArray imageToSave:[self imagePickerImage:_image] folderName:@"Scrap Folder"];
//    
//}
//
//#pragma mark UIImagePickerController delegate methods
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    self.lastChosenMediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    if ([_lastChosenMediaType isEqual: (__bridge NSString *)kUTTypeImage]) {
//        UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//        //UIImage *shrunkenImage = shrinkImage(chosenImage, imageFrame.size);
//        self.image = chosenImage;
//    } else if ([_lastChosenMediaType isEqual:(__bridge NSString *)kUTTypeMovie]) {
//        self.movieURL = [info objectForKey:UIImagePickerControllerMediaURL];
//    }
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    [_popover dismissPopoverAnimated:YES];
//    
//    
//    [self updateDisplay];
//}
//-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    [_popover dismissPopoverAnimated:YES];
//    
//}
//
//
//#pragma mark ImagePickerDetection
//- (UIImage*) imagePickerImage:(UIImage*)image
//{
//    UIImage *converted = [UIImage alloc];
//    if (image.imageOrientation == UIImageOrientationUp ) { converted = image; }
//    else if (image.imageOrientation == UIImageOrientationDown) { converted = image; }
//    else {
//        converted = [[UIImage alloc] initWithCGImage: image.CGImage
//                                               scale: 1.0
//                                         orientation: UIImageOrientationUp];
//    }
//    
//    return converted;
//    
//}


// timer stuff

-(void)fireNotice {
    [[[UIAlertView alloc] initWithTitle:@"Exited Case!" message:@"You were inactive for 5 minutes. " delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
}


- (void) startTimer {
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(tick:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void) tick:(NSTimer *) timer {
    //do something here..
    //NSLog(@"Time time time");
    //currentTime += 1;
    //if (currentTime >= 5) {
     //   currentTime = 0;
        //[timer invalidate];
        //[self.cameraCont dismissViewControllerAnimated:YES completion:nil];
        //[self.cameraCont dismissViewControllerAnimated:YES completion:nil];

        //[apickerPointer dismissViewControllerAnimated:YES completion:nil];
        //[self.delegate goHome];
        //[self.delegate fireNotice];
    //}
}
@end

