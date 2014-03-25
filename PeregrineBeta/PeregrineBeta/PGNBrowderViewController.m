//
//  PGNBrowderViewController.m
//  PeregrineBeta
//
//  Created by James Tan on 2/23/13.
//  Copyright (c) 2013 Peregrine. All rights reserved.
//

#import "PGNBrowderViewController.h"
#import "PGNBrowderModel.h"
#import "PGNFluidShortViewController.h" // short fluid calc support
#import "PGNResourceManager.h" //filesupport

#import <QuartzCore/QuartzCore.h>

@interface PGNBrowderViewController ()

@end


@implementation PGNBrowderViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Start our custom managers
    browder_model = [[PGNBrowderModel alloc] init];
    resource_manager = [[PGNResourceManager alloc] init];
    
    fluid_model = [[PGNFluidShortViewController alloc] init];
    fluid_model.delegate = self;
    
    // Set Color Size
    red = 1;
    green = 0;
    blue = 0;
    
    // Set Point Size
    pointsize = 50; //10, 20, or 50
    
    // Set Erase Active
    eraseActive = 0; //0 or 1, 0 not active
    
    // Set initial Degree
    degree = 3; //3 or 2
    
    recalculationFlag = 1; // 0 not needed, 1 needed
    saveHomeFlag = 0; //0 dont save, 1 save
    // Initiate views.
    drawImage_rear = [[UIImageView alloc] initWithImage: nil];
    drawImage_rear.frame = _view_drawing_rear.frame;
    
    drawImage_front = [[UIImageView alloc] initWithImage:nil];
    drawImage_front.frame = _view_drawing_front.frame;
    
    [_view_drawing_front addSubview:drawImage_front];
    [_view_drawing_rear addSubview:drawImage_rear];
    
    // Set the active View
    activeImageView = drawImage_front;
    activeImage = 0;
    
    [self setImageContext:@"front_583_browder_mask.png"];
    [_display_view addSubview:_view_drawing_front];
    [_display_view addSubview:_view_drawing_rear];
    
    [_display_view addSubview:drawImage_front];
    [_display_view addSubview:drawImage_rear];
    
    [drawImage_rear setHidden:YES];
    [_view_drawing_rear setHidden:YES];
    
}

-(void) setImageContext: (NSString*)maskName
{
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContext(activeImageView.frame.size);
    CGImageRef maskRef = [[UIImage imageNamed:maskName] CGImage];
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    currentReference = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(currentReference, kCGLineCapRound); //kCGLineCapSquare, kCGLineCapButt, kCGLineCapRound
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), pointsize); // for size
    CGContextSetRGBStrokeColor(currentReference, red, green, blue, 1.0); //values for R, G, B, and Alpha
    
    CGContextClipToMask(currentReference, CGRectMake(0, 0, activeImageView.frame.size.width, activeImageView.frame.size.height), mask);
}

-(void) updateColorsCapWidth
{
    CGContextSetLineCap(currentReference, kCGLineCapRound); //kCGLineCapSquare, kCGLineCapButt, kCGLineCapRound
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), pointsize); // for size
    CGContextSetRGBStrokeColor(currentReference, red, green, blue, 1.0); //values for R, G, B, and Alpha
}


-(void) loadPatientName: (NSString*)patientName loadPatientID:(NSString*)patientID {
    _label_patientID.text = patientID;
    _label_patientName.text = patientName;
}


////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
// Drawing Support (motion)

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    saveHomeFlag = 1;
    mouseSwiped = YES;
    recalculationFlag = 1;

    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:activeImageView];
    
    [activeImageView.image drawInRect:CGRectMake(0, 0, activeImageView.frame.size.width, activeImageView.frame.size.height)];
    
    CGContextBeginPath(currentReference);
    CGContextMoveToPoint(currentReference, lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(currentReference, currentPoint.x, currentPoint.y);
    CGContextStrokePath(currentReference);
    
    activeImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    lastPoint = currentPoint;
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    saveHomeFlag = 1;
    
    mouseSwiped = NO;
    recalculationFlag = 1;
    
    [self updateColorsCapWidth];
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:activeImageView];
    
    NSLog(@"Point: X: %0.2f :%0.2f", lastPoint.x, lastPoint.y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!mouseSwiped) {
        recalculationFlag = 1;
        saveHomeFlag = 1;
        
        //[drawImage.image drawInRect:CGRectMake(0, 0, drawImage.frame.size.width, drawImage.frame.size.height)];
        
        CGContextMoveToPoint(currentReference, lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(currentReference, lastPoint.x, lastPoint.y);
        CGContextStrokePath(currentReference);
        
        CGContextFlush(UIGraphicsGetCurrentContext());
        activeImageView.image = UIGraphicsGetImageFromCurrentImageContext();

    }
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
// Action Support
- (IBAction)action_tools:(id)sender {
    //[limb_model_controller handleBrowderImage:drawImage.image backImage:drawImage.image];
    UIButton *button = (UIButton*)sender;
    int tag = [button tag];
    
    switch (tag) {
        case 0: {
            // Front vs back
            NSLog(@"Changing Front Vs Back");
            if (!activeImage) {
                activeImage = 1;
                activeImageView = drawImage_rear;
                [self setImageContext:@"back_583_browder_mask.png"];
                [_view_drawing_rear setHidden:NO];
                [_view_drawing_front setHidden:YES];
                
                [drawImage_rear setHidden:NO];                
                [drawImage_front setHidden:YES];
                
                [button setImage:[UIImage imageNamed:@"backb3.png"] forState:UIControlStateNormal];
            } else {
                activeImage = 0;
                activeImageView = drawImage_front;
                [self setImageContext:@"front_583_browder_mask.png"];
                [_view_drawing_rear setHidden:YES];
                [_view_drawing_front setHidden:NO];
                
                [drawImage_rear setHidden:YES];
                [drawImage_front setHidden:NO];
                
                [button setImage:[UIImage imageNamed:@"frontb3"] forState:UIControlStateNormal];

            }
            break;
        }
        case 1: {
            // Size
            NSLog(@"Changing Drawing Size");
            if (pointsize == 10) {
                pointsize = 30;
                [button setImage:[UIImage imageNamed:@"brushSizeMedium.png"] forState:UIControlStateNormal];
                return;
            }
            if (pointsize == 30) {
                pointsize = 50;
                [button setImage: [UIImage imageNamed:@"brushSizeBig.png"] forState:UIControlStateNormal];
                return;
            }
            if (pointsize == 50) {
                pointsize = 10;
                [button setImage:[UIImage imageNamed:@"brushSizeSmall"] forState:UIControlStateNormal];
                return;
            }
            break;
        }
        case 2: {
            saveHomeFlag = 1;
            
            NSLog(@"Calculating");
            [_calculation_progress startAnimating];
            [_calculation_progress setHidden:NO];
            [self calculateBrowder];
            
            [[[UIAlertView alloc] initWithTitle:@"Complete!" message:@"The calculation is complete!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];

            //[_calculation_progress stopAnimating];
            //[self performSelector:@selector(calculateBrowder) withObject:nil afterDelay:0.01];
            //[_calculation_progress stopAnimating];

            //[self calculateBrowder];
            break;
        }
        case 3: {
            NSLog(@"Changing Degree");
            if (degree == 3) {
                degree = 2;
                red = 0;
                blue = 10;
                green = 7;
                [button setImage: [UIImage imageNamed:@"degree2b3.png"] forState:UIControlStateNormal];
            } else {
                degree = 3;
                red = 1;
                blue = 0;
                green = 0;
                [button setImage: [UIImage imageNamed:@"degree3b3.png"] forState:UIControlStateNormal];
            }
            break;
        }
        case 4: {
            NSLog(@"Turing Erase Mode On/Off");
            if (!eraseActive) {
                NSLog(@"EraseActive");
                // Store the previous color settings
                l_red = red; l_blue = blue; l_green = green; l_pointsize = pointsize;
                red = 255; green = 255; blue = 255; pointsize = 100;
                eraseActive = 1; // active erase
                [button setImage: [UIImage imageNamed:@"eraseb3_on.png"] forState:UIControlStateNormal];
                [_button_size_button setEnabled:NO];
                [_button_size_button setAlpha:0.5];
                
                [_button_degree setEnabled:NO];
                [_button_degree setAlpha:0.5];
            } else {
                NSLog(@"EraseInactive");
                eraseActive = 0;
                // Restore the previous color settings
                red = l_red; blue = l_blue; green = l_green; pointsize = l_pointsize;
                [button setImage: [UIImage imageNamed:@"eraseb3_off.png"] forState:UIControlStateNormal];
                [_button_size_button setEnabled:YES];
                [_button_size_button setAlpha:1.0];
                
                [_button_degree setEnabled:YES];
                [_button_degree setAlpha:1.0];

            }
            // Erase
            break;
        }
        case 5: {
            NSLog(@"Launching fluids");
            
            // Recalculate if needed
            if (recalculationFlag) {
                [self calculateBrowder];
                [[[UIAlertView alloc] initWithTitle:@"Updated!" message:@"Updated calculations!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];

            }
            
            // Get the patient Data
            NSString *folderName = [[_label_patientID.text stringByAppendingString:@" - "] stringByAppendingString:_label_patientName.text];
            NSArray *patientData = [resource_manager getPatientData:folderName];
                        
            //Display the popover
            _fluidPopover = [[UIPopoverController alloc]initWithContentViewController:fluid_model];
            [_fluidPopover setPopoverContentSize:fluid_model.view.frame.size];
            [_fluidPopover presentPopoverFromRect:CGRectMake(265, 0, 600, 500) inView:self.view permittedArrowDirections:0 animated:YES];
            _fluidPopover.delegate = self;

            // Load the popover
            [fluid_model loadPatientData:patientData]; // NOTE: due to the order of operations, this must be done after the view is loaded            
            [fluid_model loadTBSA:[browder_model getTBSA]];

            
            break;
        }
        case 6: {
            NSLog(@"Saving Image!");
            saveHomeFlag = 0;
            // Recalculate if needed
            if (recalculationFlag) {
                [self calculateBrowder];
            }
            
            
            // Setup the View
            _a_front_image.image = [self getBrowderFrontCollapsed ];
            _a_rear_image.image = [self getBrowderBackCollapsed ];
            _a_textArea.text = _textView_areaCalculations.text;
            _a_patientID.text = _label_patientID.text;
            _a_patientName.text = _label_patientName.text;
            _a_time.text = [resource_manager getTime];
            
            // Take the offscreen screenshot
            UIGraphicsBeginImageContext(_browder_save_view.frame.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            [_browder_save_view.layer renderInContext:context];
            UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            // Save to library
            NSString *patientName = [[_label_patientID.text stringByAppendingString: @" - "] stringByAppendingString:_label_patientName.text];
            NSArray *dataArray = [[NSArray alloc] initWithObjects:patientName, _textView_areaCalculations.text, @"n", @"n", @"n", @"Browder", nil];
            [resource_manager savePhoto: patientName data:dataArray imageToSave:screenShot folderName:@"Browder"];
            [resource_manager savePhotoToLibrary:screenShot];
            
            [[[UIAlertView alloc] initWithTitle:@"Saved!" message:@"Browder Saved!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];

            break;
            
        }
        case 7:
            NSLog(@"Going Home");
            [self decideSaveActionHome];
            
        default:
            break;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

-(void)decideSaveActionHome {
    if (saveHomeFlag) {
        [[[UIAlertView alloc] initWithTitle:@"Save or discard?" message:@"Do you want to save the Browder Diagrams?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", @"Don't Save", nil] show];
    } else {
        [self.delegate goHome];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    NSLog(@"Title: %@", title);
    
    if ([title isEqualToString:@"Don't Save"]) { [self.delegate goHome];} //going home, no saving
    if ([title isEqualToString:@"Save"]) {
        
        if (recalculationFlag) {
            [self calculateBrowder];
        }
    
        // Setup the View
        _a_front_image.image = [self getBrowderFrontCollapsed ];
        _a_rear_image.image = [self getBrowderBackCollapsed ];
        _a_textArea.text = _textView_areaCalculations.text;
        _a_patientID.text = _label_patientID.text;
        _a_patientName.text = _label_patientName.text;
        _a_time.text = [resource_manager getTime];
        
        // Take the offscreen screenshot
        UIGraphicsBeginImageContext(_browder_save_view.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [_browder_save_view.layer renderInContext:context];
        UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // Save to library
        NSString *patientName = [[_label_patientID.text stringByAppendingString: @" - "] stringByAppendingString:_label_patientName.text];
        NSArray *dataArray = [[NSArray alloc] initWithObjects:patientName, _textView_areaCalculations.text, @"n", @"n", @"n", @"Browder", nil];
        [resource_manager savePhoto: patientName data:dataArray imageToSave:screenShot folderName:@"Browder"];
        [resource_manager savePhotoToLibrary:screenShot];
        
        [self.delegate saveImage];
        //}
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
// Calculation
- (void) calculateBrowder {
    
    if (recalculationFlag == 1) {

        UIImage *imageFront = drawImage_front.image;
        UIImage *imageBack = drawImage_rear.image;
        //int age = 22;

        [browder_model calculate_area:imageFront back:imageBack];
        NSString *finalString = [browder_model calculate_area_totals];
        _textView_areaCalculations.text = finalString;
        recalculationFlag = 0;
        
    }

    [_calculation_progress stopAnimating];

    // Below is commented out, used for debugging purposes.
//    NSString *filePath3 = @"/Users/jamestan/Desktop/browder_";
//    NSString *final = [[filePath3 stringByAppendingString:@"front"] stringByAppendingString:@".png"];
//    NSData *image = UIImagePNGRepresentation(imageFront);
//    [image writeToFile:final atomically:YES];
//    
//    NSString *final2 = [[filePath3 stringByAppendingString:@"back"] stringByAppendingString:@".png"];
//    NSData *image2 = UIImagePNGRepresentation(imageBack);
//    [image2 writeToFile:final2 atomically:YES];


}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
// Orientation Support

// Support for Orientations
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

// Support for Orientations
-(BOOL)shouldAutorotate {
    return YES;
}

//Support for Orientations
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

- (UIImage*)getBrowderFrontCollapsed {
    // SPECIAL OFFSETS
    UIImage *top = drawImage_front.image;
    UIImage *bottom = [UIImage imageNamed:@"front_583_browder.png"];
    
    CGSize newSize = CGSizeMake(bottom.size.width, bottom.size.height);
    UIGraphicsBeginImageContext( newSize );
    [bottom drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    [top drawInRect:CGRectMake(0,-17,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:0.8];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)getBrowderBackCollapsed {
    // SPECIAL OFFSETS

    UIImage *top = drawImage_rear.image;
    UIImage *bottom = [UIImage imageNamed:@"back_583_browder.png"];
    
    CGSize newSize = CGSizeMake(bottom.size.width, bottom.size.height);
    UIGraphicsBeginImageContext( newSize );
    [bottom drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    [top drawInRect:CGRectMake(0,16,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:0.8];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

////

-(void)closeForm {
    [_fluidPopover dismissPopoverAnimated:YES];

}

@end
