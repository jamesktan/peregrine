//
//  PGNAddSelectViewController.m
//  PeregrineBeta
//
//  Created by James Tan on 10/7/12.
//  Copyright (c) 2012 Peregrine. All rights reserved.
//

#import "PGNAddSelectViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "PMCalendar.h"

@interface PGNAddSelectViewController ()
@end


@implementation PGNAddSelectViewController;
 
@synthesize delegate; //lesson learned, DELEGATE is a keyword.
@synthesize formScroll;

-(void) loadPatientName: (NSString*)patient_name loadPatientID:(NSString*)patient_id {
    NSLog(@"Add/Edit Patient, loading a patient Name");
    
    // prepopilate fields with known data
    // set a flag for saving
    // if this flag is on
        // copy the contents of the old folder to the new folder and
        // notify the user of the change
    //change the current patient information to reflech the new data and return
    
    NSString *folderName = [[patient_id stringByAppendingString:@" - "] stringByAppendingString:patient_name];
    NSArray *contents = [resourceManager getPatientData:folderName];
    
    loadedFolderName = folderName;
    
    // contents is 16 but we only have 15
    for (int a = 0; a < [patientDetailsVector count]; a++) {
        UITextField *temp = [patientDetailsVector objectAtIndex:a];
        
        if ([[contents objectAtIndex:a] isEqualToString:@" "]){
            temp.text = @"";
        } else {
            temp.text = [contents objectAtIndex:a];
        }
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    //UIInterfaceOrientationMaskPortrait
    [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)UIInterfaceOrientationMaskPortrait];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Calendar Stuff Setup
    calCont = [[PMCalendarController alloc] initWithSize:CGSizeMake(700, 400)];
    calCont.delegate = self;

    
    UIView *selectionSubView = _view_addPatientView;
    int offSetVal = 0; //this is so that we can scroll up, in case we have a keyboard out.
    formScroll.contentSize = CGSizeMake(selectionSubView.frame.size.width, selectionSubView.frame.size.height + offSetVal);
    [formScroll addSubview:selectionSubView];
    
    resourceManager = [[PGNResourceManager alloc]init];

    
    selectedPatientInfo = [[NSMutableArray alloc] init];
    
    // Add Patient Workflow Support:
    patientFieldContainer = [[NSMutableArray alloc] init];
    [patientFieldContainer addObject:_tf_firstName];
    [patientFieldContainer addObject:_tf_middleName];
    [patientFieldContainer addObject:_tf_lastName];
    [patientFieldContainer addObject:_tf_gender];
    [patientFieldContainer addObject:_tf_patientID];
    [patientFieldContainer addObject:_tf_age]; //5
    [patientFieldContainer addObject:_tf_weight]; //6
    [patientFieldContainer addObject:_tf_height]; //7
    [patientFieldContainer addObject:_tv_notes];
    [patientFieldContainer addObject:_tf_dateTimeBurn];
    [patientFieldContainer addObject:_tf_dateTimeAdmission];
    [patientFieldContainer addObject:_tf_city];
    [patientFieldContainer addObject:_tf_state];
    [patientFieldContainer addObject:_tf_referralSource];
    [patientFieldContainer addObject:_tf_circumstance];
    [patientFieldContainer addObject:_tf_typeBurn];
    
    // For Ease in Saving and Releasing
    patientDetailsVector = [[NSMutableArray alloc] initWithArray:patientFieldContainer];
    [patientDetailsVector addObject:_tv_preInjuryDetails];
    
    // CompositeView
    compositeArray = [[NSArray alloc] initWithObjects:_c_name, _c_middle_name, _c_last_name,
                               _c_gender, _c_patentID, _c_age, _c_weight, _c_height, _c_datetimeburn,
                               _c_datetimeadmission, _c_city, _c_state, _c_referaalsource, _c_circumstance,
                               _c_typeofburn, _c_notes, _c_preinjurydetails, _c_thetime, nil];
    
    // Added Next/Previous to Keyboard
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
    
    for (int b = 0; b < [patientFieldContainer count]; b++) {
        UITextField *field = [patientFieldContainer objectAtIndex:b];
        field.inputAccessoryView = av;
    }

    // Add Patient - Support for PreInjury Slider
    NSString *preInjuryPath = [[NSBundle mainBundle] pathForResource:@"preInjuryConditions" ofType:@"plist"];
    preInjuryList = [[NSMutableArray alloc] initWithContentsOfFile:preInjuryPath];
    preInjuryDetailsString = [[NSMutableString alloc]initWithFormat:@"PreInjury Details:\n\n"];

    self.patientFolderList = [resourceManager getContentsOfMain];

    
}
// Support for Add Patient - CLEAR ALL
- (IBAction)a_clearPatient:(id)sender {
    //reset the patient information fields to nil
    UITextView *temp2 = [patientDetailsVector lastObject];
    temp2.text = nil;
    
    for (int i = 0; i < [patientFieldContainer count] - 1; i++) {
        UITextField *temp = [patientFieldContainer objectAtIndex:i];
        temp.text = nil;
    }
    UITextView *temp = [patientFieldContainer lastObject];
    temp.text = nil;

    _b_preInjury.titleLabel.text = @"Pre-Injury Condition";
    
}
// Support for Return on Keyboard
- (IBAction)doneEditing:(id)sender {
    //this method is responsible for releasing the keyboard
    [(UITextField*)sender resignFirstResponder];
}

// Support for Next Button
-(void)goToNextTextfield {
    if ([[patientFieldContainer objectAtIndex:[patientFieldContainer count] - 1] isFirstResponder]) {
        [[patientFieldContainer objectAtIndex:0] becomeFirstResponder];
        return;
    }
    for (int a = 0; a < [patientFieldContainer count]; a++) {
        UITextField *field = [patientFieldContainer objectAtIndex:a];
        if ([field isFirstResponder]) {
            NSLog(@"HAT");
            [[patientFieldContainer objectAtIndex:a + 1] becomeFirstResponder];
            break;
        }
    }
}
//Support for Back Button
-(void)goToPreviousTextfield
{
    if ([[patientFieldContainer objectAtIndex:0] isFirstResponder]) {
        [[patientFieldContainer objectAtIndex:[patientFieldContainer count] - 1] becomeFirstResponder];
        return;
    }
    for (int a = 0; a < [patientFieldContainer count]; a++) {
        UITextField *field = [patientFieldContainer objectAtIndex:a];
        if ([field isFirstResponder]) {
            NSLog(@"HAT");
            [[patientFieldContainer objectAtIndex:a - 1] becomeFirstResponder];
            break;
        }
    }
}

// Support for Age Unit Change:
- (IBAction)a_changeAge:(id)sender {
    
    UIButton *type = (UIButton*)sender;
    int tag = [type tag];
    NSString *ageString;
    switch (tag) {
        case 1:
            ageString = [[NSString alloc] initWithFormat:@"yrs"];
            [type setTag:0];
            break;
        default:
            ageString = [[NSString alloc] initWithFormat:@"mnth"];
            [type setTag:1];
            break;
    }
    [type setTitle:ageString forState:UIControlStateNormal];
}

// Support for Weight Unit Change:
- (IBAction)a_changeWeight:(id)sender {
    UIButton *type = (UIButton*)sender;
    int tag = [type tag];
    NSString *weightString;
    switch (tag) {
        case 1:
            weightString = [[NSString alloc] initWithFormat:@"kg"];
            [type setTag:0];
            break;
        default:
            weightString = [[NSString alloc] initWithFormat:@"lbs"];
            [type setTag:1];
            break;
    }
    [type setTitle:weightString forState:UIControlStateNormal];
}

// Support for Height Unit Change:
- (IBAction)a_changeHeight:(id)sender {
    UIButton *type = (UIButton*)sender;
    int tag = [type tag];
    NSString *heightString;
    switch (tag) {
        case 1:
            heightString = [[NSString alloc] initWithFormat:@"cm"];
            [type setTag:0];
            break;
        default:
            heightString = [[NSString alloc] initWithFormat:@"in"];
            [type setTag:1];
            break;
    }
    [type setTitle:heightString forState:UIControlStateNormal];
}

// Support for PreInjurySlider

// Support for Add PreInjury
- (IBAction)a_addPreInjury:(id)sender {
    preInjuryDetailsString = (NSMutableString*)_tv_preInjuryDetails.text;
    if (_b_preInjury.titleLabel.text != nil) {
        [preInjuryDetailsString appendString: _b_preInjury.titleLabel.text];
        [preInjuryDetailsString appendString:@"\nDetails: "];
        if (_tv_preInjuryDetails.text != nil) {
            [preInjuryDetailsString appendString: _tf_preInjuryField.text];
        }
        [preInjuryDetailsString appendString:@"\n\n"];
        
        _tv_preInjuryDetails.text = preInjuryDetailsString;
        
        [_tv_preInjuryDetails flashScrollIndicators];
        
    }
}

// Support for Orientations
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

// Support for Orientations
-(BOOL)shouldAutorotate {
    return YES;
}

//Support for Orientations
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray*)getSelectedPatientInfo {
    return selectedPatientInfo;
}
-(NSString*)getSelectedPatient {
    return patientFolderName;
}

#pragma PGNSelectSubViewController

#pragma PGNPatient
-(void)didSelectRow { // Patient was selected, so go home
    //getselectedPatient
    //NSString *patient = [patientListViewController getSelectedPatient];
    //patientFolderName = patient;
    
    //Set the internal name and ID (to return to parent)
    //NSArray *temp =  [patient componentsSeparatedByString:@" - "];
    //patientName = [temp objectAtIndex:0];
    //patientID = [temp objectAtIndex:1];
    
    [self.delegate savedPatient];
}

- (IBAction)a_savePatient:(id)sender { // Patient was saved, so go home
    NSLog(@"Start Save");
    
    UITextField *firstName = [patientDetailsVector objectAtIndex:0];
    UITextField *middleName = [patientDetailsVector objectAtIndex:1];
    if ([middleName.text isEqualToString:@""]) {
        middleName.text = @".";
    }
    UITextField *lastName = [patientDetailsVector objectAtIndex:2];
    UITextField *patientID_temp = [patientDetailsVector objectAtIndex:4];

    for (int i =0; i < 8; i++) {
        UITextField *temp  = [patientDetailsVector objectAtIndex:i];
        if ([temp.text isEqualToString:@""]) {
            NSLog(@"Error, field not complete");
            [[[UIAlertView alloc] initWithTitle:@"Incomplete Form!" message:@"You must, at minimum, fill out First, last, age, weight, gender, height, and patient ID." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            return;
        }
    }
    //Set the internal name and ID (to return to parent)
    patientName = [[[[firstName.text stringByAppendingString:@" "]stringByAppendingString:middleName.text]stringByAppendingString:@" "] stringByAppendingString:lastName.text];
    patientID = patientID_temp.text;
    
    // Convert the weight and height and age according to:
    if ([_b_weight.titleLabel.text isEqualToString:@"lbs"]) {
        _tf_weight.text = [[[NSNumber alloc] initWithFloat:_tf_weight.text.intValue * 0.453592] stringValue];
    } 
    if ([_b_height.titleLabel.text isEqualToString:@"in"]) {
        _tf_height.text = [[[NSNumber alloc] initWithFloat:_tf_height.text.intValue * 2.54] stringValue];
    }

    
    
    // Save the patient
    patientFolderName = [[patientID stringByAppendingString:@" - "]stringByAppendingString:patientName];
    
    //Saving the patient
    if (![loadedFolderName isEqualToString:patientFolderName]) {
        [resourceManager copyPatientFolder:loadedFolderName newFolder:patientFolderName];
        [[[UIAlertView alloc] initWithTitle:@"Patient Renamed" message:@"The patient folder was renamed!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
    [resourceManager savePatient:patientFolderName data:patientDetailsVector];
    
    /// create the composite view and save it!
    NSLog(@"something broke");
    for (int a = 0; a < [patientDetailsVector count]; a++) {
        ((UILabel*)[compositeArray objectAtIndex:a]).text = ((UITextField*)[patientDetailsVector objectAtIndex:a]).text;
    }
    UIGraphicsBeginImageContext(_composite_view.frame.size);
    [_composite_view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [resourceManager savePhotoToLibrary:viewImage];
    NSString *folderName = @"Patient Information";
    NSArray *dataArray = [[NSArray alloc] initWithObjects:patientName, patientDetailsVector, @"n", @"n", @"n", @"PatientInfo", nil];
    [resourceManager savePhoto:patientFolderName data: dataArray imageToSave:viewImage folderName:folderName];
    //end save composite view
    
    
    [self.delegate savedPatient];
    
}
-(NSArray*) returnPatientDetails {
    NSArray *temp = [[NSArray alloc] initWithObjects:patientName, patientID, nil];
    return temp;
}

- (IBAction)a_back:(id)sender {
    [self.delegate goHome];
}

- (IBAction)a_preInjury:(id)sender {
    
    if(dropDownMenu == nil) {
        NSArray *arr = [NSArray arrayWithArray:preInjuryList];
        CGFloat f = 300;

        dropDownMenu = [[NIDropDown alloc]showDropDown:sender height:&f array:arr];
        dropDownMenu.delegate = self;
    }
    else {
        [dropDownMenu hideDropDown:sender];
        [self rel];
    }
}

#pragma mark Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d", [self.patientFolderList count]);
    return [self.patientFolderList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SimpleTableIdentifier];
    };
    
    UIImage *image2 = [UIImage imageNamed:@"burn_2.jpg"];
    cell.imageView.image = image2;
        
    cell.textLabel.text = [self.patientFolderList objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* patientFolder = [self.patientFolderList objectAtIndex:indexPath.row];
    NSArray *folderArray = [patientFolder componentsSeparatedByString:@" - "];
    patientName = [folderArray objectAtIndex:1];
    patientID = [folderArray objectAtIndex:0];
    [self.delegate savedPatient];
}

# pragma mark NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    if (![_b_burnAgent_type.titleLabel.text isEqualToString:@"Set"]) {
        _tf_typeBurn.text = _b_burnAgent_type.titleLabel.text;
        _b_burnAgent_type.titleLabel.text = @"Set";
        _b_burnAgent_type.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    [self rel];
}
-(void)rel{
    dropDownMenu = nil;
}

/// Other Stuff..
- (IBAction)select_date_time_burn:(id)sender {
    [calCont presentCalendarFromView:(UIButton*)sender
                       permittedArrowDirections:PMCalendarArrowDirectionUp | PMCalendarArrowDirectionLeft
                                      isPopover:YES
                                       animated:YES];
    
    tf_used = [(UIButton*)sender tag];
}


#pragma mark PMCalendarControllerDelegate methods
- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    if (tf_used == 1) {
        _tf_dateTimeBurn.text = [NSString stringWithFormat:@"%@", [newPeriod.endDate dateStringWithFormat:@"MM-dd-yyyy"]];
    }
    if (tf_used == 2) {
        _tf_dateTimeAdmission.text = [NSString stringWithFormat:@"%@", [newPeriod.endDate dateStringWithFormat:@"MM-dd-yyyy"]];
    }
}

- (void)calendarControllerDidDismissCalendar:(PMCalendarController *)calendarController {
    calCont = nil;
    calCont = [[PMCalendarController alloc] initWithSize:CGSizeMake(700, 400)];
    calCont.delegate = self;

}


- (IBAction)select_burn_agent:(id)sender {
    if(dropDownMenu == nil) {
        NSArray *arr = [[NSArray alloc] initWithObjects:
                        @"Chemical", @"Flame", @"Flash", @"Electrical",
                        @"Friction", @"Scald", @"Other", nil];
        CGFloat f = 300;
        
        dropDownMenu = [[NIDropDown alloc]showDropDown:sender height:&f array:arr];
        dropDownMenu.delegate = self;
                
    }
    else {
        [dropDownMenu hideDropDown:sender];
        [self rel];
    }
}
@end
