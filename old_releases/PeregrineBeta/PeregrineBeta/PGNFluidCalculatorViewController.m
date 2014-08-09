//
//  PGNFluidCalculatorViewController.m
//  PeregrineBeta
//
//  Created by James Tan on 9/2/12.
//  Copyright (c) 2012 Peregrine. All rights reserved.
//

#import "PGNFluidCalculatorViewController.h"
//#import "PGNSerializeViewViewController.h"
//#import "PGNimageHandler.h"

@interface PGNFluidCalculatorViewController ()

@end

@implementation PGNFluidCalculatorViewController
@synthesize backImage;
@synthesize t_name;
@synthesize t_patientId;
@synthesize t_age;
@synthesize t_weight;
@synthesize t_height;
@synthesize t_gender;
@synthesize t_tbsa;
@synthesize tv_tbsaDetails;
@synthesize t_parkland1;
@synthesize t_parkland2;
@synthesize t_maintenance;
@synthesize frontImage;
@synthesize browderListPopover;

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;

}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)UIInterfaceOrientationMaskPortrait];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    patientLoaded = 1; //no = 0
    defaultBrowder1 = frontImage.image;
    defaultBrowder2 = backImage.image;
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES );
    mainPath = [paths objectAtIndex:0];
    
    
    UIView *av = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 768.0, 45.0)];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, av.frame.size.width, 45)];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    UIBarButtonItem *but1 = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:(UIBarButtonItemStyle)UIBarButtonSystemItemFastForward target:self action:@selector(goToNextTextfield)];
    
    UIBarButtonItem *but2 = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:(UIBarButtonItemStyle)UIBarButtonSystemItemFastForward target:self action:@selector(goToPreviousTextfield)];

    [toolBar setBarStyle:UIBarStyleBlack];
    [items addObject:but1];
    [items addObject:but2];
    
    [toolBar setItems:items animated:NO];

    [av addSubview:toolBar];
    
    t_height.inputAccessoryView = av;
    t_age.inputAccessoryView = av;
    t_weight.inputAccessoryView = av;
    t_tbsa.inputAccessoryView = av;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fluids_parklandCalculationDetails" ofType:@"plist"];
    parkland_CalculationDetails = [[NSArray alloc] initWithContentsOfFile:path];
    
    if ([parkland_CalculationDetails count]) {
        _tv_calculationDetails.text = [parkland_CalculationDetails componentsJoinedByString:@"\n"];

    }
    
    // start resource manager
    resourceManager = [[PGNResourceManager alloc] init];
}

-(void)loadPatientName: (NSString*)patientName loadPatientID: (NSString*)patientID {
    _label_name.text = patientName;
    _label_ID.text = patientID;
    
    NSString* folderName = [[patientID stringByAppendingString:@" - "] stringByAppendingString:patientName];
    NSArray *patientData = [resourceManager getPatientData:folderName];
    NSLog(@"patient load for fluid calculator   ");
    NSLog(@"%@", patientData);
    t_age.text = [patientData objectAtIndex:5];
    t_weight.text = [patientData objectAtIndex:6];
    t_height.text = [patientData objectAtIndex:7];
    
    [self calculateFluid:t_age];
    
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

-(BOOL)shouldAutorotate {
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (IBAction)doneEditing:(id)sender {
    [(UITextField*)sender resignFirstResponder];
}

-(void)goToNextTextfield {
    if ([t_tbsa isFirstResponder]) {
        [t_age becomeFirstResponder];
    } else if ([t_age isFirstResponder]) {
        [t_height becomeFirstResponder];
    } else if ([t_height isFirstResponder]) {
        [t_weight becomeFirstResponder];
    } else if ([t_weight isFirstResponder]) {
        [t_tbsa becomeFirstResponder];
    } else {
        [t_tbsa becomeFirstResponder];
    }
}

-(void)goToPreviousTextfield {
    if ([t_tbsa isFirstResponder]) {
        [t_weight becomeFirstResponder];
    } else if ([t_weight isFirstResponder]) {
        [t_height becomeFirstResponder];
    } else if ([t_height isFirstResponder]) {
        [t_age becomeFirstResponder];
    } else if ([t_age isFirstResponder]) {
        [t_tbsa becomeFirstResponder];
    } else {
        [t_tbsa becomeFirstResponder];
    }
}

-(void)closeForm {
    [popCont dismissPopoverAnimated:YES];
}
- (IBAction)selectBrowderDiagram:(id)sender {
//    /// Selecting a Browder
//    NSLog(@"Select a Browder Diagram");
//    
//    PGNSerializeViewViewController *serializeCont = [[PGNSerializeViewViewController alloc] init];
//    NSString* folderName = [[_label_ID.text stringByAppendingString:@" - "] stringByAppendingString:_label_name.text];
//    [serializeCont loadData:folderName];
//    serializeCont.delegate = self;
//    
//    popCont = [[UIPopoverController alloc] initWithContentViewController:serializeCont];
//    [popCont setPopoverContentSize:serializeCont.view.frame.size];
//    [popCont presentPopoverFromRect:CGRectMake(265, 0, 600, 300) inView:self.view permittedArrowDirections:0 animated:YES];
//    popCont.delegate = self;

    
    //    [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationPortrait];

    //t_name.text = [selectedPatientData objectAtIndex:0];
    //t_age.text = [selectedPatientData objectAtIndex:4];
    //t_weight.text = [selectedPatientData objectAtIndex:5];
    //t_height.text = [selectedPatientData objectAtIndex:6];
    //t_gender.text = [selectedPatientData objectAtIndex:7];
    
    //browderListController = [[PGNPatientListViewController alloc] initWithNibName:@"PGNPatientListViewController" bundle:nil];

//    if (patientLoaded) {
//        NSString *patientFolder = [mainPath stringByAppendingPathComponent: selectedPatient];
//        
//        PGNimageHandler *handler = [[PGNimageHandler alloc] init];
//        patientFolderContents = [handler getFolderContents:patientFolder];
//        NSLog(@"%@", patientFolder);
//        
//        NSMutableArray *parsedFileList = [[NSMutableArray alloc] init];
//        for ( NSString * filename in patientFolderContents )
//        {
//            if ( [[filename lastPathComponent] hasSuffix: @".plist"] &&  [filename rangeOfString:@"browder_data"].location != NSNotFound) {
//                [parsedFileList addObject:filename];
//            }
//        }
    
//        [browderListController setData:parsedFileList];
//        
//        browderListPopover = [[UIPopoverController alloc] initWithContentViewController:browderListController];
//        browderListPopover.delegate = self;
//        [browderListPopover setPopoverContentSize:browderListController.view.frame.size];
//        [browderListPopover presentPopoverFromRect:CGRectMake(0, 200, 500, browderListController.view.frame.size.height + 100) inView:self.view permittedArrowDirections:0 animated:YES];
//        [browderListController setDelegate:self];
        
//    }
    
}

- (IBAction)clearPatientInfo:(id)sender {
    patientLoaded = 0;
    
    t_patientId.text = nil;
    t_name.text = nil;
    t_weight.text = nil;
    t_height.text = nil;
    t_gender.text = nil;
    t_age.text = nil;
    t_tbsa.text = nil;
    tv_tbsaDetails.text = nil;
    
    t_maintenance.text = nil;
    t_parkland1.text = nil;
    t_parkland2.text = nil;
    
    frontImage.image = defaultBrowder1;
    backImage.image = defaultBrowder2;
    
    
}

- (IBAction)calculateFluid:(id)sender {
    //calculate the fluid administration values
    
    //convert, since we do everything in british
    float weightkg = [t_weight.text floatValue] / 2.2046 ;
    float heightcm = [t_height.text floatValue] * 2.54 ;
    
    int ageSwitch = 0; //0 is adult, 1 is child, 2 is infant
    int age = [t_age.text intValue];
    
    if (age < 3) { ageSwitch = 2; }
    if ((age < 15) && (age > 3)) { ageSwitch = 1; }
    if (age > 15) { ageSwitch = 0; }
    
    float bsa_val = 0;
    float prklnd = 0;
    float evap = 0;
    float basal = 0;
    float maint = 0;
    
    switch (ageSwitch) {
        case 0://adult
            //Calculate BSA using Dubois-Dubois Eqn (weightkg^0.425 x heightcm^0.725)/139.2).
            bsa_val = ((powf(weightkg,0.425) * powf(heightcm,0.725))/139.2);
            
            //Calculate total volume for Parkland Fluids in mL (4 mL * weightkg * %TBSA).
            //NB Give half over first 8 hours, other half over second 16 hours.
            prklnd = 4*[t_tbsa.text floatValue]*weightkg;
            
            //Calculate maintenance rate in mL/hour. The goal in fluid resuscitation is
            // to titrate the fluid rate down from Parkland rate to maintenance rate! (while
            // keeping uriane output btwn 30-60 mL/hour).
            evap = (25 + [t_tbsa.text floatValue]) * bsa_val; //evaporative rate in mL/hour
            basal = (1500 * bsa_val)/24; //basal rate in mL/hour
            maint = evap + basal;  //maintenance rate in mL/hour
            
            t_parkland1.text = [NSString stringWithFormat:@"%.1f mL/hour", prklnd/2/8];
            t_parkland2.text = [NSString stringWithFormat:@"%.1f mL/hour", prklnd/2/16];
            t_maintenance.text =[NSString stringWithFormat:@"%.1f mL/hour", maint];

            break;
        case 1://child
            //Calculate BSA using Dubois-Dubois Eqn (weightkg^0.425 x heightcm^0.725)/139.2).
            bsa_val = (powf(weightkg,0.425) * powf(heightcm,0.725))/139.2;
            
            //Calculate total volume for Parkland Fluids in mL (4 mL * weightkg * %TBSA).
            //NB Give half over first 8 hours, other half over second 16 hours.
            prklnd = 4*[t_tbsa.text floatValue]*weightkg;
            
            //Calculate maintenance rate in mL/hour. The goal in fluid resuscitation is
            // to titrate the fluid rate down from Parkland rate to maintenance rate! (while
            // keeping uriane output btwn 30-60 mL/hour).
            evap = (25 + [t_tbsa.text floatValue]) * bsa_val; //evaporative rate in mL/hour
            basal = (1500 * bsa_val)/24; //basal rate in mL/hour
            maint = evap + basal;  //maintenance rate in mL/hour
            
            t_parkland1.text = [NSString stringWithFormat:@"%.1f mL/hour", prklnd/2/8];
            t_parkland2.text = [NSString stringWithFormat:@"%.1f mL/hour", prklnd/2/16];
            t_maintenance.text =[NSString stringWithFormat:@"%.1f mL/hour", maint];
            //totalFluids.text = [NSString stringWithFormat:@"%.1f mL", prklnd/2];
            break;
        case 2: //infant
            //Calculate BSA using Dubois-Dubois Eqn (weightkg^0.425 x heightcm^0.725)/139.2).
            bsa_val = (pow(weightkg,0.425) * pow(heightcm,0.725))/139.2;
            
            //Calculate total volume for Parkland Fluids in mL (4 mL * weightkg * %TBSA).
            //NB Give half over first 8 hours, other half over second 16 hours.
            prklnd = 4*[t_tbsa.text floatValue]*weightkg;
            
            //Calculate maintenance rate in mL/hour. The goal in fluid resuscitation is
            // to titrate the fluid rate down from Parkland rate to maintenance rate! (while
            // keeping uriane output btwn 30-60 mL/hour).
            evap = (35 + [t_tbsa.text floatValue]) * bsa_val; //evaporative rate in mL/hour
            basal = (2000 * bsa_val)/24; //basal rate in mL/hour
            maint = evap + basal;  //maintenance rate in mL/hour
            
            t_parkland1.text = [NSString stringWithFormat:@"%.1f mL/hour", prklnd/2/8];
            t_parkland2.text = [NSString stringWithFormat:@"%.1f mL/hour", prklnd/2/16];
            t_maintenance.text =[NSString stringWithFormat:@"%.1f mL/hour", maint];
            //totalFluids.text = [NSString stringWithFormat:@"%.1f mL", prklnd/2];
            break;
            
        default:
            break;
    }
    
    // update the calculation details
    // this stuff isnt quite working yet...
//    
//    NSString *bsaValText = [[NSNumber numberWithFloat:bsa_val] stringValue];
//    NSString *parklandText = [[NSNumber numberWithFloat:prklnd] stringValue];
//    NSString *evapText = [[NSNumber numberWithFloat:evap] stringValue];
//    NSString *basalText = [[NSNumber numberWithFloat:basal] stringValue];
//    NSString *maintenanceText = [[NSNumber numberWithFloat:maint] stringValue];
//    NSString *tbsaText = t_tbsa.text;
//
//    NSMutableString* tempText = [[NSMutableString alloc] initWithString: _tv_calculationDetails.text];
//    NSString* modified = [[[[[[[[[[tempText stringByReplacingOccurrencesOfString:@"weight1" withString:t_weight.text] stringByReplacingOccurrencesOfString:@"height1" withString:t_height.text] stringByReplacingOccurrencesOfString:@"tbsa1" withString:tbsaText] stringByReplacingOccurrencesOfString:@"bsa1" withString:bsaValText] stringByReplacingOccurrencesOfString:@"park1" withString:parklandText] stringByReplacingOccurrencesOfString:@"park1_8hours" withString:t_parkland1.text] stringByReplacingOccurrencesOfString:@"park1_16hours" withString:t_parkland2.text] stringByReplacingOccurrencesOfString:@"evap1" withString:evapText] stringByReplacingOccurrencesOfString:@"basal1" withString:basalText] stringByReplacingOccurrencesOfString:@"maint1" withString:maintenanceText];
//    [_tv_calculationDetails setText: modified];


}

-(void)setPatientInfoData: (NSMutableArray*)currentPatientData
{
    selectedPatientData = currentPatientData;
}

- (IBAction)executeHome:(id)sender {
    [self.delegate goHome];
}

- (IBAction)executeSave:(id)sender {
    // no saving!
//    NSString *patientName = [[_label_ID.text stringByAppendingString: @" - "] stringByAppendingString:_label_name.text];
//    NSArray *dataArray = [[NSArray alloc] initWithObjects:@"Fluids", t_parkland1.text, t_parkland2.text, t_maintenance.text, t_age.text, t_gender.text, t_height.text, t_name.text,nil];
//    
//    [resourceManager saveFluids:patientName data:dataArray];
//    [self.delegate saveImage];
}

-(void)setPatientInfo: (NSString*)currentPatient {
    //[self clearPatientInfo:currentPatient]; // clear all patient info when loading a new patient.
    patientLoaded = 1; // no patient is loaded

    selectedPatient = currentPatient;
    //[browderListController resetData];
    
}

-(void) loadBrowderData {
    NSString *pathToPlist = [[mainPath stringByAppendingPathComponent:selectedPatient] stringByAppendingPathComponent:selectedBrowder];
    NSArray *plistDataArray = [[NSArray alloc] initWithContentsOfFile:pathToPlist];
    
    //calculated last values
    NSString *calculatedValues = [plistDataArray lastObject];
    tv_tbsaDetails.text = calculatedValues;
    
    //get tbsa values
    NSArray *someRows = [calculatedValues componentsSeparatedByString:@"\n"];
    if ([someRows count] < 6) {
        UIAlertView *alerter = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot load the selected browder data file" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alerter show];
        
        [browderListPopover dismissPopoverAnimated:YES];
        return;
    }
    NSString*tbsaRow = [someRows objectAtIndex:4];
    NSString *tbsaVal = [[[tbsaRow componentsSeparatedByString:@":\t"] objectAtIndex:1] stringByReplacingOccurrencesOfString:@"%" withString:@""];
    t_tbsa.text = tbsaVal;
    
    //get the browderDiagrams!
    NSString *theTime = [[selectedBrowder componentsSeparatedByString:@" - "] objectAtIndex:0];
    NSMutableArray *matchedBrowder = [[NSMutableArray alloc] init];
    for ( NSString * filename in patientFolderContents ) {
        if ( [[filename lastPathComponent] hasSuffix: @".png"] &&  ([filename rangeOfString:@"Browder"].location != NSNotFound) && ([filename rangeOfString:theTime].location != NSNotFound))
        {
            [matchedBrowder addObject:filename];
        }
    }
    
    if ([matchedBrowder count] == 2) {
        NSString *back = [[mainPath stringByAppendingPathComponent:selectedPatient] stringByAppendingPathComponent:[matchedBrowder objectAtIndex:0]];
        NSString *front = [[mainPath stringByAppendingPathComponent:selectedPatient] stringByAppendingPathComponent:[matchedBrowder objectAtIndex:1]];
        UIImage *backImagePre = [[UIImage alloc] initWithContentsOfFile:back];
        UIImage *frontImagePre = [[UIImage alloc] initWithContentsOfFile:front];
        backImage.image = backImagePre;
        frontImage.image = frontImagePre;
        
    }
    
    
    
    [browderListPopover dismissPopoverAnimated:YES];
    
}


- (void)viewDidUnload
{
    [self setT_name:nil];
    [self setT_patientId:nil];
    [self setT_age:nil];
    [self setT_weight:nil];
    [self setT_height:nil];
    [self setT_gender:nil];
    [self setT_tbsa:nil];
    [self setTv_tbsaDetails:nil];
    [self setT_parkland1:nil];
    [self setT_parkland2:nil];
    [self setT_maintenance:nil];
    [self setFrontImage:nil];
    [self setBackImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



#pragma mark -
#pragma mark PGNPatientListDelegate delegate

-(void)didSelectRow {

    //selectedBrowder = [browderListController getSelectedPatient];
    //NSLog(@"%@", selectedBrowder);
    
    //[self loadBrowderData];
}
@end
