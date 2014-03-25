//
//  PGNCameraViewController.m
//  PeregrineBeta
//
//  Created by James Tan on 4/23/13.
//  Copyright (c) 2013 Peregrine. All rights reserved.
//

#import "PGNCameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <QuartzCore/QuartzCore.h>
#import "PGNResourceManager.h"

@interface PGNCameraViewController (UtilityMethods)
- (void) updateDisplay;
- (void) getMediaFromSource: (UIImagePickerControllerSourceType) sourceType;
@end

@implementation PGNCameraViewController

@synthesize delegate;

-(void)loadPatientName: (NSString*)patientName loadPatientID: (NSString*)patientID {
    _label_patientName.text = patientName;
    _label_patientID.text = patientID;
    
    _anno_name.text = patientName;
    _anno_id.text = patientID;
    
    folderName = [[_anno_id.text stringByAppendingString:@" - "] stringByAppendingString:_anno_name.text];    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    if (first == 0) {
        [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
        first = 1;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    first = 0;
    resourceManager = [[PGNResourceManager alloc] init];
    
    [self startTimer];

    // Launch the camera at startup.
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)action_userChoice:(id)sender {
    UIButton *button = (UIButton*)sender;
    int t = [button tag];
    switch (t) {
        case 1:
            [self.delegate goHome];
            break;
        case 0:
            [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
            [self startTimer];
            
            break;
        default:
            break;
    }
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
        
        apickerPointer = picker;
        
        if (sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIView *overlayView = [[UIView alloc] initWithFrame:picker.view.frame];
            
            UIImage *tempImage = [UIImage imageWithCGImage:_anno_image.image.CGImage scale:1.0 orientation:_anno_image.image.imageOrientation];
            
            UIImageView *viewer= [[UIImageView alloc] initWithImage:tempImage];
            
            [viewer setFrame:CGRectMake(0, 0, 1024, 768)];
            
            int overlayOnOff = 0;
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
        [_alertTimer invalidate];
    }
}

-(void)updateDisplay
{
    // Save Photo

    _anno_time.text = [resourceManager getTime];
    NSLog(@"Display");
    _anno_image.image = [self imagePickerImage:_image];
    //_imageView_picture.image = [self imagePickerImage:_image];
    
    if ([self imagePickerImage:_image] == NULL) {
        NSLog(@"something broke!");
    }

    //NSString *folderName = [[patientID stringByAppendingString:@" - "] stringByAppendingString:patientName];
    NSArray *dataArray = [[NSArray alloc] initWithObjects:_label_patientName, @"temp", @"n", @"n", @"n", @"Temp", nil];
    
    // Take the offscreen screenshot
    UIGraphicsBeginImageContext(_anno_view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_anno_view.layer renderInContext:context];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _imageView_picture.image = screenShot;
    
    // Saving Stuff
    [resourceManager savePhoto:folderName data:dataArray imageToSave:screenShot folderName:@"Scrap Folder"];
    [resourceManager savePhotoToLibrary:screenShot]; // with annotation
    //[resourceManager savePhotoToLibrary:[self imagePickerImage:_image]]; //original


}

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


#pragma mark UIImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.lastChosenMediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([_lastChosenMediaType isEqual: (__bridge NSString *)kUTTypeImage]) {
        UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        //UIImage *shrunkenImage = shrinkImage(chosenImage, imageFrame.size);
        self.image = chosenImage;
    } else if ([_lastChosenMediaType isEqual:(__bridge NSString *)kUTTypeMovie]) {
        self.movieURL = [info objectForKey:UIImagePickerControllerMediaURL];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_popover dismissPopoverAnimated:YES];
    
    [self updateDisplay];

    // Reset the time if canceled
    [_alertTimer invalidate];
    currentTime = 0;
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // Reset the time if canceled
    [_alertTimer invalidate];
    currentTime = 0;
    
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


// timer stuff
- (void) startTimer {
    currentTime = 0;
    _alertTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(tick:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void) tick:(NSTimer *) timer {
    //do something here..
    NSLog(@"Time time time");
    currentTime += 1;
    if (currentTime >= 180) {
        [timer invalidate];
        [apickerPointer dismissViewControllerAnimated:YES completion:nil];
        [[[UIAlertView alloc] initWithTitle:@"Idle Alert!" message:@"You have been idle for three minutes, would you like to continue?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil] show];
        currentTime = 0;

    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //Cancel
            [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
            [self startTimer];
            break;
        case 1:
            [self.delegate goHome];
            break;
        default:
            break;
    }
}
@end
