//
//  PGNAddSelectViewController.h
//  PeregrineBeta
//
//  Created by James Tan on 10/7/12.
//  Copyright (c) 2012 Peregrine. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PGNResourceManager.h"
#import "NIDropDown.h"

#import "PMCalendar.h"

@protocol PGNSelectOrAddPatient <NSObject>

-(void)goHome;
-(void)saveImage;
-(void)savedPatient;

@end


@interface PGNAddSelectViewController : UIViewController <UITableViewDataSource, NIDropDownDelegate, PMCalendarControllerDelegate>
{
    NSMutableArray *selectedPatientInfo;
    
    PGNResourceManager *resourceManager;
    
    NSString*patientFolderName, *loadedFolderName;
    
    NSMutableArray *patientDetailsVector; // contains all fields
    NSArray *compositeArray; // contains all composite values
    
    // Add Patient Support Variables
    NSMutableArray *patientFieldContainer, *preInjuryList;
    NSMutableString *preInjuryDetailsString;
    NSString *patientName, *patientID; //return to main
    
    NIDropDown *dropDownMenu;
    PMCalendarController *calCont;
    
    int tf_used; //determine datetime stuff
    
}

@property (nonatomic, weak) id<PGNSelectOrAddPatient> delegate;

@property (strong, nonatomic) NSArray *patientFolderList;
@property (nonatomic, retain) IBOutlet UIScrollView *formScroll;
@property (weak, nonatomic) IBOutlet UITableView *patientListTable;


// Properties of Adding a Patient
// Transitional!
@property (strong, nonatomic) IBOutlet UIView *view_addPatientView;

@property (weak, nonatomic) IBOutlet UITextField *tf_firstName;
@property (weak, nonatomic) IBOutlet UITextField *tf_middleName;
@property (weak, nonatomic) IBOutlet UITextField *tf_lastName;
@property (weak, nonatomic) IBOutlet UITextField *tf_gender;
@property (weak, nonatomic) IBOutlet UITextField *tf_patientID;
@property (weak, nonatomic) IBOutlet UITextField *tf_age;
@property (weak, nonatomic) IBOutlet UITextField *tf_weight;
@property (weak, nonatomic) IBOutlet UITextField *tf_height;

@property (weak, nonatomic) IBOutlet UIButton *b_years;
@property (weak, nonatomic) IBOutlet UIButton *b_weight;
@property (weak, nonatomic) IBOutlet UIButton *b_height;

@property (weak, nonatomic) IBOutlet UITextField *tf_dateTimeBurn;
@property (weak, nonatomic) IBOutlet UITextField *tf_dateTimeAdmission;
@property (weak, nonatomic) IBOutlet UITextField *tf_city;
@property (weak, nonatomic) IBOutlet UITextField *tf_state;
@property (weak, nonatomic) IBOutlet UITextField *tf_referralSource;
@property (weak, nonatomic) IBOutlet UITextField *tf_circumstance;
@property (weak, nonatomic) IBOutlet UITextField *tf_typeBurn;

@property (weak, nonatomic) IBOutlet UITextField *tf_preInjuryField;
@property (weak, nonatomic) IBOutlet UITextView *tv_preInjuryDetails;
@property (weak, nonatomic) IBOutlet UIButton *b_addPreInjury;

@property (strong, nonatomic) IBOutlet UITextView *tv_notes;

// END Properties of Adding a Patient
@property (strong, nonatomic) IBOutlet UIButton *b_preInjury;

- (IBAction)a_savePatient:(id)sender;
- (IBAction)a_clearPatient:(id)sender;
- (IBAction)a_back:(id)sender;
- (IBAction)a_preInjury:(id)sender;

-(void) loadPatientName: (NSString*)patient_name loadPatientID:(NSString*)patient_id;

//Return the patient
-(NSArray*) returnPatientDetails;

-(NSMutableArray*)getSelectedPatientInfo;
-(NSString*)getSelectedPatient;

// Start composite Properties of Adding a Patient

@property (strong, nonatomic) IBOutlet UIView *composite_view;
@property (strong, nonatomic) IBOutlet UILabel *c_name;
@property (strong, nonatomic) IBOutlet UILabel *c_middle_name;
@property (strong, nonatomic) IBOutlet UILabel *c_last_name;
@property (strong, nonatomic) IBOutlet UILabel *c_gender;
@property (strong, nonatomic) IBOutlet UILabel *c_patentID;
@property (strong, nonatomic) IBOutlet UILabel *c_age;
@property (strong, nonatomic) IBOutlet UILabel *c_weight;
@property (strong, nonatomic) IBOutlet UILabel *c_height;
@property (strong, nonatomic) IBOutlet UILabel *c_datetimeburn;
@property (strong, nonatomic) IBOutlet UILabel *c_datetimeadmission;
@property (strong, nonatomic) IBOutlet UILabel *c_city;
@property (strong, nonatomic) IBOutlet UILabel *c_state;
@property (strong, nonatomic) IBOutlet UILabel *c_referaalsource;
@property (strong, nonatomic) IBOutlet UILabel *c_circumstance;
@property (strong, nonatomic) IBOutlet UILabel *c_typeofburn;
@property (strong, nonatomic) IBOutlet UITextView *c_notes;
@property (strong, nonatomic) IBOutlet UITextView *c_preinjurydetails;
@property (strong, nonatomic) IBOutlet UILabel *c_thetime;



// New Buttons
@property (strong, nonatomic) IBOutlet UIButton *b_burn_dateTime;
@property (strong, nonatomic) IBOutlet UIButton *b_admission_dateTime;
- (IBAction)select_date_time_burn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *b_burnAgent_type;
- (IBAction)select_burn_agent:(id)sender;


@end

