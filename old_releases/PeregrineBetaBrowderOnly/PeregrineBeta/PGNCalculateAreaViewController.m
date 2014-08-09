//
//  PGNCalculateAreaViewController.m
//  PeregrineBeta
//
//  Created by James Tan on 8/7/12.
//  Copyright (c) 2012 Peregrine. All rights reserved.
//

// http://stackoverflow.com/questions/7439273/uiscrollview-prevents-touchesbegan-touchesmoved-touchesended-on-view-controlle


#import "PGNCalculateAreaViewController.h"
#import "PGNFluidShortViewController.h"
#import "PGNSerializeViewViewController.h" //serialize support

#import <MobileCoreServices/UTCoreTypes.h>
#import <QuartzCore/QuartzCore.h>

@interface PGNCalculateAreaViewController (UtilityMethods)
- (void) updateDisplay;
- (void) getMediaFromSource: (UIImagePickerControllerSourceType) sourceType;
@end

@implementation PGNCalculateAreaViewController
@synthesize textFieldReference;
@synthesize measure_imageView;
@synthesize areaValue;
@synthesize areaValueLimb;
@synthesize tbsaValue;

@synthesize delegate;
@synthesize lastChosenMediaType;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        photoTaken = 0;
        
        overlayOnOff = 0; //off by default
        selectedDrawAction = 0; //none by default
        hasBeenSetup = 0; //no by default
    }
    return self;
} 
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    drawImage = [[UIImageView alloc] initWithImage: nil]; // we draw in the drawimage frame. we orient over the measure_image frame.
    drawImage.frame = measure_imageView.frame;
    //[self.view addSubview:drawImage];
    [self.view insertSubview:drawImage aboveSubview:measure_imageView];
    red = 0;
    green = 0;
    blue = 0;
    
    photoTaken = 0;
    
    startDot = 0;
    endDot = 0;
    addDot = 0;
    
    burnArea = 0;
    limbArea = 0;
    degree = 0;
    limb = 1;
    
    points = [[NSMutableArray alloc] init];
    pointsLimb = [[NSMutableArray alloc] init];

    ratio = 0; //this is the cm/pixel ratio!
    //setup image contexts
        
    // Check that we have a camera on board
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //takeImageButton.enabled = NO;
        NSLog(@"This device has no camera!");
    }
    
    /// Instantiate the Annotation Form
    standardForm = [[PGNStandardPatientFormViewController alloc] init];
    standardForm.delegate = self;
    
    //Resource Manager Start
    resourceManager = [[PGNResourceManager alloc] init];
    
    // Instantiate the Fluid Short Form
    NSString *folderName = [[_label_ID.text stringByAppendingString:@" - "] stringByAppendingString:_label_name.text];    
    NSArray *patientData = [resourceManager getPatientData:folderName];
    shortFluid = [[PGNFluidShortViewController alloc] init];
    shortFluid.delegate = self;
    [shortFluid loadPatientData:patientData];
    
    serializeViewCont = [[PGNSerializeViewViewController alloc] init];
    serializeViewCont.delegate = self;
    
    
}
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

-(void) setup {
    if (hasBeenSetup == 0) {
        UIGraphicsEndImageContext();
        UIGraphicsBeginImageContext(drawImage.frame.size);
        currentReference = UIGraphicsGetCurrentContext();
        CGContextSetLineCap(currentReference, kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 7.0);
        CGContextSetRGBStrokeColor(currentReference, red, green, blue, 1.0);
        hasBeenSetup = 1;
    }
    
}

-(void)loadImage: (UIImage*)image {
    measure_imageView.image = image;
    
}

-(void)loadPatientName: (NSString*)patientName loadPatientID: (NSString*)patientID {
    _label_name.text = patientName;
    _label_ID.text = patientID;
    
    _annoLabel_name.text = patientName;
    _annoLabel_ID.text = patientID;
    
    NSString *folderName = [[_label_ID.text stringByAppendingString:@" - "] stringByAppendingString:_label_name.text];
    [serializeViewCont loadData:folderName];

}

- (UIImage*)getCurrentBlendedImage {
    UIImage *top = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *bottom = measure_imageView.image;
    
    CGSize newSize = CGSizeMake(bottom.size.width, bottom.size.height);
    UIGraphicsBeginImageContext( newSize );
    [bottom drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    [top drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:0.8];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (NSArray*)getCurrentMeasuredValues {
    NSNumber *percentBurn_r = [[NSNumber alloc] initWithFloat:tbsa];
    NSNumber *burnArea_r = [[NSNumber alloc] initWithFloat: [areaValue.text floatValue]];
    NSNumber *limbArea_r = [[NSNumber alloc] initWithFloat: [areaValueLimb.text floatValue]];
    NSArray *dataArray = [[NSArray alloc] initWithObjects:percentBurn_r, burnArea_r, limbArea_r,
                     _label_name.text, _label_ID.text,_annoLabel_POD.text, _annoLabel_Type.text, _annoLabel_location.text, _annoLabel_Graft.text, _annoLabel_Degree.text, nil];

    
    return dataArray;
}

-(void)clearImageOnViewLoad {
    red = 0;
    green = 0;
    blue = 0;
    startDot = 0;
    endDot = 0;
    addDot = 0;
    addDotLimb = 0;
    ratio = 0;
    
    burnArea = 0;
    limbArea = 0;
    degree = 0;
    limb = 1;
    
    textFieldReference.text = nil;
    [textFieldReference setEnabled:YES];
    [textFieldReference setAlpha:1];

    drawImage.image = nil;
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContext(drawImage.frame.size);
    UIGraphicsEndImageContext();
    selectedDrawAction = 0;
    hasBeenSetup = 0;
    
    areaValue.text = [[NSString alloc] initWithFormat:@"%d",0];
    areaValueLimb.text = [[NSString alloc] initWithFormat:@"%d",0];
    tbsaValue.text = [[NSString alloc] initWithFormat:@"%d",0];

    [points removeAllObjects];
    [pointsLimb removeAllObjects];
}

- (float) getLimbBurnPercent {
    if ([tbsaValue.text integerValue]) {
        return tbsa;
    } else {
        return 0;
    }
}

- (void) calculateTBSA {
    burnArea = [areaValue.text intValue];
    limbArea = [areaValueLimb.text intValue];
    tbsa = (float) burnArea/limbArea;
    
    tbsaValue.text = [[NSString alloc] initWithFormat:@"%.1f", 100*tbsa];
    _annoLabel_burnPercent.text = tbsaValue.text;
    
}
- (IBAction)doneEditing:(id)sender {
    [textFieldReference resignFirstResponder];
}
-(void) calculateArea {
    if (ratio == 0) {
        ratio = 1;
    }
    NSMutableArray *calculateAarray;
    if (selectedDrawAction == 3) {
        calculateAarray = [[NSMutableArray alloc] initWithArray:pointsLimb];
    }
    if (selectedDrawAction == 2) {
        calculateAarray = [[NSMutableArray alloc] initWithArray:points];
    }
    
    NSMutableArray *tempTable1 = [[NSMutableArray alloc] init];
    NSMutableArray *tempTable2 = [[NSMutableArray alloc] init];
    
    if ([calculateAarray count] >= 3){
        for (int i = 0; i < [calculateAarray count]; ++i ) {
            [tempTable1 addObject:[NSNumber numberWithFloat:[[calculateAarray objectAtIndex:i] CGPointValue].x]];
            [tempTable2 addObject:[NSNumber numberWithFloat:[[calculateAarray objectAtIndex:i] CGPointValue].y]];
        }
        [tempTable1 addObject:[NSNumber numberWithFloat:[[calculateAarray objectAtIndex:0] CGPointValue].x]];
        [tempTable2 addObject:[NSNumber numberWithFloat:[[calculateAarray objectAtIndex:0] CGPointValue].y]];    }
    
    NSMutableArray *tempTableVal1 = [[NSMutableArray alloc] init];
    NSMutableArray *tempTableVal2 = [[NSMutableArray alloc] init];
// multiply
    for (int i = 0; i < [tempTable1 count] - 1; ++i) {
        [tempTableVal1 addObject: [NSNumber numberWithFloat:[[tempTable1 objectAtIndex:i] floatValue]*[[tempTable2 objectAtIndex:i+1] floatValue]]];
    }
    for (int i = 0; i < [tempTable2 count] - 1; ++i) {
        [tempTableVal2 addObject: [NSNumber numberWithFloat:[[tempTable2 objectAtIndex:i] floatValue]*[[tempTable1 objectAtIndex:i+1] floatValue]]];
    }
    
    float areaPre = 0;
    for (int b = 0; b < [tempTableVal1 count]; ++b) {
        areaPre += [[tempTableVal1 objectAtIndex:b] floatValue] - [[tempTableVal2 objectAtIndex:b] floatValue];
    }

    float area = abs(areaPre/2);
    float area2 = area*ratio*ratio;
    int rounded = (int)(area2+0.5);
    
    if (selectedDrawAction == 3) {
        areaValueLimb.text = [[NSString alloc] initWithFormat:@"%d",rounded];
        _annoLabel_LimbArea.text = areaValueLimb.text;
    }
    if (selectedDrawAction ==2) {
        areaValue.text = [[NSString alloc] initWithFormat:@"%d",rounded];
        _annoLabel_burnArea.text = areaValue.text;
    }
}
-(void) calculateReferenceDistance {
    
    double distance = sqrt(pow((endPoint.x - startPoint.x), 2.0) + pow((endPoint.y - startPoint.y), 2.0));    
    int userInt = [textFieldReference.text intValue];
    ratio = userInt/distance;    
    [textFieldReference setEnabled:FALSE];
    [textFieldReference setAlpha:0.3];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch Began");
    if (selectedDrawAction != 0) {
        
        UITouch *touch = [touches anyObject];
        lastPoint = [touch locationInView:drawImage];
        
        if (selectedDrawAction == 1) {
            startPoint = lastPoint;
        }
    }
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch Moved");
    if (selectedDrawAction != 0) {
        CGContextSetRGBStrokeColor(currentReference, red, green, blue, 1.0); //update the color

        // will want to sample points
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:drawImage];
        
        CGContextBeginPath(currentReference);
        CGContextMoveToPoint(currentReference, lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(currentReference, currentPoint.x, currentPoint.y);
        CGContextStrokePath(currentReference);
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext(); //??
        
        lastPoint = currentPoint;
        
        // this will be dependant on the button pressed.
        switch (selectedDrawAction) {
            case 2:
                [points addObject:[NSValue valueWithCGPoint:lastPoint]];
                break;
            case 3:
                [pointsLimb addObject:[NSValue valueWithCGPoint:lastPoint]];
                break;
            default:
                break;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch End");
    if (selectedDrawAction != 0) {
        NSLog(@"X: %f, Y: %f", lastPoint.x, lastPoint.y);
        
        CGContextMoveToPoint(currentReference, lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(currentReference, lastPoint.x, lastPoint.y);
        CGContextStrokePath(currentReference);
        
        if (selectedDrawAction == 1) {
            endPoint = lastPoint;
            [self calculateReferenceDistance];
        } else {
            [self calculateArea];
            [self calculateTBSA];
        }
    
        CGContextFlush(UIGraphicsGetCurrentContext());
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    }
    
}

- (void)viewDidUnload
{
    [self setMeasure_imageView:nil];
    [self setTextFieldReference:nil];
    [self setAreaValue:nil];
    [self setAreaValueLimb:nil];
    [self setTbsaValue:nil];
    [super viewDidUnload];
}

- (IBAction)a_DispatchCenter:(id)sender {
    // a_DispatchCenter
    // Input: ID of a button
    // Output: None
    // Notes: This is the main method that handles navigation and behavior on the image capture page.
    
    UIButton *button = (UIButton*) sender;
    int buttonTag = button.tag;
    switch (buttonTag) {
        case 0: //go home
            
            // Check if the photo changed, if so then prompt to save, otherwise go home
            if ([self check_CaptureImage]) {
                NSLog(@"TM - Going Home");
                [self.delegate goHome]; // going home
            }
            break;
            
        case 1: //take photo
            NSLog(@"TM - Taking Photo");
            [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
            break;
            
        case 2: //import photo
            NSLog(@"TM - Importing Photo");
            if (![_popover isPopoverVisible]) {
                [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
            } else {
                [_popover dismissPopoverAnimated:YES];
            }
            break;
        case 3: //annotate photo
            NSLog(@"TM - Annotating Photo");
            _annotationPopover = [[UIPopoverController alloc]initWithContentViewController:standardForm];
            [_annotationPopover setPopoverContentSize:standardForm.view.frame.size];
            [_annotationPopover presentPopoverFromRect:CGRectMake(0, 0, 500, 768) inView:self.view permittedArrowDirections:0 animated:YES];
            _annotationPopover.delegate = self;
            
            break;
        case 4: // save photo
            
            // Jtan Note 3/27/13
            // We no longer have a save button, going back to 'home' will prompt
            [self saveAnnotatedPhoto];
            //[self.delegate saveImage];
            
            
            [[[UIAlertView alloc] initWithTitle:@"Save!" message:@"Your image was saved!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
            
            // JTan Note 3/27/13, We no longer check whether the annotations were entered anymore.
            // Check that Annotations have been entered, if not, prompt.
            //if ([self check_Annotation]) {
            //    [self saveAnnotatedPhoto];
            //    NSLog(@"TM - Saving Photo");
            //    [self.delegate saveImage];
            //}
            break;
            
        case 10:
            NSLog(@"TM - Burn Area");
            [self setup];
            red = 1; green = 0; blue = 0;
            selectedDrawAction = 2;
            break;
        case 11:
            NSLog(@"TM - Scale");
            red = 0; green = 0; blue = 1;
            [self setup];
            selectedDrawAction = 1;            
            break;
        case 12:
            NSLog(@"TM - Limb Area");
            [self setup];
            red = 1; green = 0; blue = 1;
            selectedDrawAction = 3;
            break;
        
        case 20:
            NSLog(@"TM - Reset");
            [self clearImageOnViewLoad];
            break;
        case 21:
            NSLog(@"TM - Fluids");
            _fluidPopover = [[UIPopoverController alloc]initWithContentViewController:shortFluid];
            [_fluidPopover setPopoverContentSize:shortFluid.view.frame.size];
            [_fluidPopover presentPopoverFromRect:CGRectMake(265, 0, 600, 500) inView:self.view permittedArrowDirections:0 animated:YES];
            _fluidPopover.delegate = self;
            
            break;
        case 22:
            NSLog(@"TM - Serialize");
            [self loadSerialization];
            break;
            
        default:
            break;
    }
    NSString *folderName = [[_label_ID.text stringByAppendingString:@" - "] stringByAppendingString:_label_name.text];
    NSArray *patientData = [resourceManager getPatientData:folderName];
    [shortFluid loadPatientData:patientData];
    
}

-(BOOL) check_Annotation {
    // check_Annotation
    // Input: None
    // Output: Bool, YES/No
    // Notes: This function is executed in a_DispatchCenter. This function is executed then the user hits "Save". We do a check to decide whether or not we're supposed save based on weather there are annotations present. If there are missing annotations for burn degree, appearance, graft, POD or location we will NOT save.
    // Notes 2: The text for comparison comes out of PGNStandardViewController.m form. These appear in the xib file there.
    
    // Notes 3/27/13 - This function is now disabled. This is because we found that prohibiting nurses from being able to take photos was a hindrance to workflow
    
    UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Annotation for Degree, Graft, Appearance, POD or Location is missing. Please add them." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];

    if ([_annoLabel_Degree.text isEqualToString:@"Burn Type: None"]) { [warning show]; return NO;}
    if ([_annoLabel_Graft.text isEqualToString:@"Graft: None"]) { [warning show]; return NO;}
    if ([_annoLabel_Type.text isEqualToString:@"Appearance: None"]) {[warning show]; return NO;}
    if ([_annoLabel_location.text isEqualToString:@"Location: None"]) {[warning show]; return NO;}
    
    if ([_annoLabel_POD.text isEqualToString:@"Pod #: None"]) { [warning show]; return NO;}
    if ([_annoLabel_POD.text isEqualToString:@""]) { [warning show]; return NO;} // can also be empty string, will cause premature save if we don't have this.
    
    return YES;
}

-(BOOL) check_CaptureImage {
    // check_CaptureImage
    // Input: None
    // Output: Bool, YES/NO
    // Notes: This function is executed in a_DispatchCenter. This function is executed when the user hits "Home". We do a check to decide whether or not to go back based on whether we've taken a photo or not.
    
    if (photoTaken) { //Photo was Taken but was not saved, 0 if no photo taken or photo has been saved
        [[[UIAlertView alloc] initWithTitle:@"Save or discard?" message:@"Do you want to save your photo?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", @"Don't Save", nil] show];
        return NO;
    }
    return YES;
}

-(void)loadSerialization {
    // Find the current patient and the folder contents
    
    // Launch the popover
    _serializationPopover = [[UIPopoverController alloc] initWithContentViewController:serializeViewCont];
    [_serializationPopover setPopoverContentSize:serializeViewCont.view.frame.size];
    [_serializationPopover presentPopoverFromRect:CGRectMake(265, 0, 600, 300) inView:self.view permittedArrowDirections:0 animated:YES];
    _serializationPopover.delegate = self;

    // Display this is the dialog that im supposed to type
    
    
    return;
}

- (UIImage*)screenshot
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


-(void)saveAnnotatedPhoto {
    
    photoTaken = 0;
    
    // Save the photo by populating the appropriate fields and making the appropriate things visible.
    
    NSString *patientName = [[_label_ID.text stringByAppendingString: @" - "] stringByAppendingString:_label_name.text];
    NSString *folderName = _label_location.text;
    NSArray *imageData = [self getCurrentMeasuredValues];
    
    //save the original
    //[resourceManager savePhotoToLibrary:measure_imageView.image]; //save the original photo
    //don't save to the app, only save a new photo to the photo library
    //[resourceManager savePhoto:patientName data:imageData imageToSave:measure_imageView.image folderName:folderName];
        
    [_interfaceLayer setHidden:YES]; //hide the navigation
    [_annotationLayer setHidden:NO]; //launch the annotation
    
    _annoLabel_dateTime.text = [resourceManager getTime];
        
    //capture the screenshot
    [resourceManager savePhotoToLibrary:[self screenshot]]; // save the annotated photo
    [resourceManager savePhoto:patientName data:imageData imageToSave:[self screenshot] folderName:folderName];

    // Save an MRN Free version
    _annoLabel_name.text = @" ";
    _annoLabel_ID.text = @" ";
    [resourceManager savePhotoToLibrary:[self screenshot]];
    
    [_interfaceLayer setHidden:NO];
    [_annotationLayer setHidden:YES];

    
    
}
-(void) getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    //taking photos
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0)
    {
        //NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType]; //removed to only support camera and not any video.
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        picker.delegate = self;
        picker.allowsEditing = NO;//yes works, no breaks this?
        picker.sourceType = sourceType;
        
        if (sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIView *overlayView = [[UIView alloc] initWithFrame:picker.view.frame];
            
            UIImage *tempImage = [UIImage imageWithCGImage:measure_imageView.image.CGImage scale:1.0 orientation:measure_imageView.image.imageOrientation];
            
            UIImageView *viewer= [[UIImageView alloc] initWithImage:tempImage];
            
            [viewer setFrame:CGRectMake(0, 0, 1024, 768)];
            
            //overlay stuff
            if (!overlayOnOff) {
                //[overlayView addSubview:viewer];
                //overlayOnOff = 1; // may want to remove this
                
            }
            overlayView.alpha = .35;
            if (overlayOnOff == 1) {
                [overlayView addSubview:viewer];
                NSLog(@"The overlay is on!");
                picker.cameraOverlayView = overlayView; //- ,,,,,,,
                [picker.view.window addSubview:overlayView];
                [picker.view.window insertSubview:overlayView atIndex:1];

            }
            
            [self presentViewController:picker animated:YES completion:nil];
            
        } else
        {
            _popover = [[UIPopoverController alloc] initWithContentViewController:picker];
            [_popover presentPopoverFromRect:CGRectMake(100, 150, 100, 500) inView:self.view permittedArrowDirections:0 animated:YES];
        }
        
        
        
    } else
    {
        [[[UIAlertView alloc]
                              initWithTitle: @"Error accessing media"
                              message:@"Device doesn't support that media source"
                              delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
    }
}

-(void)updateDisplay
{
    // updateDisplay
    // Input: None
    // Output: None
    // Notes: This function is executed after we capture an image or a video loop or when we select a photo from the library. This will update the imageview with the respective image.
    
    photoTaken = 1;
    
    //taking photos
    if ([lastChosenMediaType isEqual:(__bridge NSString *)kUTTypeImage])
    {
        measure_imageView.image = [self imagePickerImage:_image];
        measure_imageView.hidden = NO;
        _moviePlayerController.view.hidden = YES;
    } // might want to comment out the below stuff
    else if ([lastChosenMediaType isEqual: (__bridge NSString *)kUTTypeMovie]) {
        [self.moviePlayerController.view removeFromSuperview];
        self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:_movieURL];
        _moviePlayerController.view.frame = _imageFrame;
        _moviePlayerController.view.clipsToBounds = YES;
        [self.view addSubview:_moviePlayerController.view];
        measure_imageView.hidden = NO;
    }
}

-(void) updateAnnotationText {
    NSArray *arrayTemp = [standardForm getAnnotationValues];
    if ([arrayTemp count]) {
        _annoLabel_POD.text = [arrayTemp objectAtIndex:0];
        _annoLabel_Degree.text = [arrayTemp objectAtIndex:1];
        _annoLabel_Graft.text = [arrayTemp objectAtIndex:2];
        _annoLabel_Type.text = [arrayTemp objectAtIndex:3];
        _annoLabel_location.text = [arrayTemp objectAtIndex:4];
    }
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self updateAnnotationText]; // Update the annotation fields for the screenshot
}

-(void)setSerialPhoto:(UIImage *)image  {
    measure_imageView.image = image;
    overlayOnOff = 1; 
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];     
}

-(void)setSelectedCase:(NSString *)folderName {
    //do nothing!
}

#pragma mark UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    NSLog(@"Title: %@", title);
    
    if ([title isEqualToString:@"Don't Save"]) { [self.delegate goHome];} //going home, no saving
    if ([title isEqualToString:@"Save"]) { 
        //if ([self check_Annotation]) { //jtan Note 3/27/13, changed to fix workflow.
        [self saveAnnotatedPhoto];
        [self.delegate saveImage];
        [self.delegate goHome];
        //}
    }
}

#pragma mark PGNPhotoAnnotate delegate methods
-(void)closeForm {
    [self updateAnnotationText]; // Update the annotation fields for the screenshot
    [_annotationPopover dismissPopoverAnimated:YES];
    [_fluidPopover dismissPopoverAnimated:YES];
    [_serializationPopover dismissPopoverAnimated:YES];
}

#pragma mark UIImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.lastChosenMediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([lastChosenMediaType isEqual: (__bridge NSString *)kUTTypeImage]) {
        UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        //UIImage *shrunkenImage = shrinkImage(chosenImage, imageFrame.size);
        self.image = chosenImage;
    } else if ([lastChosenMediaType isEqual:(__bridge NSString *)kUTTypeMovie]) {
        self.movieURL = [info objectForKey:UIImagePickerControllerMediaURL];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_popover dismissPopoverAnimated:YES];
    
    
    [self updateDisplay];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_popover dismissPopoverAnimated:YES];
    
}


#pragma mark ImagePickerDetection
- (UIImage*) imagePickerImage:(UIImage*)image
{
    UIImage *converted = [UIImage alloc];
    if (image.imageOrientation == UIImageOrientationUp ) { converted = image; }
    else if (image.imageOrientation == UIImageOrientationDown) { converted = image; }
    else {
        converted = [[UIImage alloc] initWithCGImage: image.CGImage
                                               scale: 1.0
                                         orientation: UIImageOrientationUp];
    }

    return converted;
    
}

@end
