//
//  PGNFluidCalculatorViewController.h
//  PeregrineBeta
//
//  Created by James Tan on 9/2/12.
//  Copyright (c) 2012 Peregrine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGNResourceManager.h"
//#import "PGNSerializeViewViewController.h"
@protocol PGNFluidDelegate <NSObject>

- (void) goHome; //return home
- (void) saveImage; //save image

@end

@interface PGNFluidCalculatorViewController : UIViewController <UIPopoverControllerDelegate>{
    int patientLoaded;
    
    NSArray *parkland_CalculationDetails;

    NSArray *paths;
    NSArray *patientFolderContents;
    NSString *mainPath;
    NSString *selectedPatient;
    
    NSString *selectedBrowder;

    UIPopoverController *browderListPopover;
    
    UIImage *defaultBrowder1, *defaultBrowder2;
    
    NSMutableArray *selectedPatientData;
    int positive;
    
    PGNResourceManager *resourceManager;
    
    UIPopoverController *popCont;
        
}
-(void)loadPatientName: (NSString*)patientName loadPatientID: (NSString*)patientID;

@property (nonatomic, assign) id<PGNFluidDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *calculationContainerView;

- (IBAction)executeHome:(id)sender;
//- (IBAction)executeSave:(id)sender;

-(void)setPatientInfo: (NSString*)currentPatient;
-(void)setPatientInfoData: (NSMutableArray*)currentPatientData;

- (IBAction)doneEditing:(id)sender;
//- (IBAction)selectBrowderDiagram:(id)sender;
- (IBAction)clearPatientInfo:(id)sender;
- (IBAction)calculateFluid:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *label_name;

@property (weak, nonatomic) IBOutlet UILabel *label_ID;
@property (weak, nonatomic) IBOutlet UITextView *tv_calculationDetails;

@property (weak, nonatomic) IBOutlet UIImageView *frontImage;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (strong, nonatomic) UIPopoverController *browderListPopover;

@property (weak, nonatomic) IBOutlet UITextField *t_name;
@property (weak, nonatomic) IBOutlet UITextField *t_patientId;
@property (weak, nonatomic) IBOutlet UITextField *t_age;
@property (weak, nonatomic) IBOutlet UITextField *t_weight;
@property (weak, nonatomic) IBOutlet UITextField *t_height;
@property (weak, nonatomic) IBOutlet UITextField *t_gender;
@property (weak, nonatomic) IBOutlet UITextField *t_tbsa;
@property (strong, nonatomic) IBOutlet UITextView *tv_tbsaDetails;

@property (weak, nonatomic) IBOutlet UITextField *t_parkland1;
@property (weak, nonatomic) IBOutlet UITextField *t_parkland2;
@property (weak, nonatomic) IBOutlet UITextField *t_maintenance;

@property (weak, nonatomic) IBOutlet UILabel *l_tbsa;
@property (weak, nonatomic) IBOutlet UILabel *l_age;
@property (weak, nonatomic) IBOutlet UILabel *l_height;
@property (weak, nonatomic) IBOutlet UILabel *l_weight;

@property (weak, nonatomic) IBOutlet UIButton *b_home;
@property (weak, nonatomic) IBOutlet UIButton *b_parkland;
@property (weak, nonatomic) IBOutlet UIButton *b_brooke;
@property (weak, nonatomic) IBOutlet UIButton *b_evans;
@property (weak, nonatomic) IBOutlet UIButton *b_galveston;
@property (weak, nonatomic) IBOutlet UIButton *b_save;
@property (weak, nonatomic) IBOutlet UIButton *b_select;
@property (weak, nonatomic) IBOutlet UIButton *b_reset;

@end
