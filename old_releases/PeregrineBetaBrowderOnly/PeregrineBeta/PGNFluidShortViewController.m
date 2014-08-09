//
//  PGNFluidShortViewController.m
//  PeregrineBeta
//
//  Created by James Tan on 1/29/13.
//  Copyright (c) 2013 Peregrine. All rights reserved.
//

#import "PGNFluidShortViewController.h"

@interface PGNFluidShortViewController ()

@end

@implementation PGNFluidShortViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    UIView *av = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024, 45.0)];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, av.frame.size.width, 45)];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    UIBarButtonItem *but1 = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:(UIBarButtonItemStyle)UIBarButtonSystemItemFastForward target:self action:@selector(goToNextTextfield)];
    
    UIBarButtonItem *but2 = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:(UIBarButtonItemStyle)UIBarButtonSystemItemFastForward target:self action:@selector(goToPreviousTextfield)];
    
    [toolBar setBarStyle:UIBarStyleBlack];
    [items addObject:but1];
    [items addObject:but2];
    
    [toolBar setItems:items animated:NO];
    
    [av addSubview:toolBar];
    
    _t_height.inputAccessoryView = av;
    _t_age.inputAccessoryView = av;
    _t_weight.inputAccessoryView = av;
    _t_tbsa.inputAccessoryView = av;

    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fluids_parklandCalculationDetails" ofType:@"plist"];
    NSArray *parkland_CalculationDetails = [[NSArray alloc] initWithContentsOfFile:path];
    if ([parkland_CalculationDetails count]) {
        _tv_calculationDetails.text = [parkland_CalculationDetails componentsJoinedByString:@"\n"];
        preCalcString = _tv_calculationDetails.text;
    }

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated {
    [self calculateFluid:_t_height];

}
-(void)goToNextTextfield {
    if ([_t_tbsa isFirstResponder]) {
        [_t_age becomeFirstResponder];
    } else if ([_t_age isFirstResponder]) {
        [_t_height becomeFirstResponder];
    } else if ([_t_height isFirstResponder]) {
        [_t_weight becomeFirstResponder];
    } else if ([_t_weight isFirstResponder]) {
        [_t_tbsa becomeFirstResponder];
    } else {
        [_t_tbsa becomeFirstResponder];
    }
}

- (void)loadPatientData: (NSArray*)data {
    NSLog(@"Loading Data");
    
    [_t_age setText:[data objectAtIndex:5]];
    [_t_weight setText:[data objectAtIndex:6]];
    [_t_height setText:[data objectAtIndex:7]];
}

- (void)loadTBSA:(NSString*)value {
    NSLog(@"Loading TBSA into Fluid Calculator");
    [_t_tbsa setText:value];
}
-(void)goToPreviousTextfield {
    if ([_t_tbsa isFirstResponder]) {
        [_t_weight becomeFirstResponder];
    } else if ([_t_weight isFirstResponder]) {
        [_t_height becomeFirstResponder];
    } else if ([_t_height isFirstResponder]) {
        [_t_age becomeFirstResponder];
    } else if ([_t_age isFirstResponder]) {
        [_t_tbsa becomeFirstResponder];
    } else {
        [_t_tbsa becomeFirstResponder];
    }
}

- (IBAction)doneEditing:(id)sender {
    [(UITextField*)sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)calculateFluid:(id)sender {
    //calculate the fluid administration values
    
    //convert, since we do everything in british
    float weightkg = [_t_weight.text floatValue] / 2.2046 ;
    float heightcm = [_t_height.text floatValue] * 2.54 ;
    
    int ageSwitch = 0; //0 is adult, 1 is child, 2 is infant
    int age = [_t_age.text intValue];
    
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
            prklnd = 4*[_t_tbsa.text floatValue]*weightkg;
            
            //Calculate maintenance rate in mL/hour. The goal in fluid resuscitation is
            // to titrate the fluid rate down from Parkland rate to maintenance rate! (while
            // keeping uriane output btwn 30-60 mL/hour).
            evap = (25 + [_t_tbsa.text floatValue]) * bsa_val; //evaporative rate in mL/hour
            basal = (1500 * bsa_val)/24; //basal rate in mL/hour
            maint = evap + basal;  //maintenance rate in mL/hour
            
            _t_parkland1.text = [NSString stringWithFormat:@"%.1f mL/hour", prklnd/2/8];
            _t_parkland2.text = [NSString stringWithFormat:@"%.1f mL/hour", prklnd/2/16];
            _t_maintenance.text =[NSString stringWithFormat:@"%.1f mL/hour", maint];
            
            break;
        case 1://child
            //Calculate BSA using Dubois-Dubois Eqn (weightkg^0.425 x heightcm^0.725)/139.2).
            bsa_val = (powf(weightkg,0.425) * powf(heightcm,0.725))/139.2;
            
            //Calculate total volume for Parkland Fluids in mL (4 mL * weightkg * %TBSA).
            //NB Give half over first 8 hours, other half over second 16 hours.
            prklnd = 4*[_t_tbsa.text floatValue]*weightkg;
            
            //Calculate maintenance rate in mL/hour. The goal in fluid resuscitation is
            // to titrate the fluid rate down from Parkland rate to maintenance rate! (while
            // keeping uriane output btwn 30-60 mL/hour).
            evap = (25 + [_t_tbsa.text floatValue]) * bsa_val; //evaporative rate in mL/hour
            basal = (1500 * bsa_val)/24; //basal rate in mL/hour
            maint = evap + basal;  //maintenance rate in mL/hour
            
            _t_parkland1.text = [NSString stringWithFormat:@"%.1f mL/hour", prklnd/2/8];
            _t_parkland2.text = [NSString stringWithFormat:@"%.1f mL/hour", prklnd/2/16];
            _t_maintenance.text =[NSString stringWithFormat:@"%.1f mL/hour", maint];
            //totalFluids.text = [NSString stringWithFormat:@"%.1f mL", prklnd/2];
            break;
        case 2: //infant
            //Calculate BSA using Dubois-Dubois Eqn (weightkg^0.425 x heightcm^0.725)/139.2).
            bsa_val = (pow(weightkg,0.425) * pow(heightcm,0.725))/139.2;
            
            //Calculate total volume for Parkland Fluids in mL (4 mL * weightkg * %TBSA).
            //NB Give half over first 8 hours, other half over second 16 hours.
            prklnd = 4*[_t_tbsa.text floatValue]*weightkg;
            
            //Calculate maintenance rate in mL/hour. The goal in fluid resuscitation is
            // to titrate the fluid rate down from Parkland rate to maintenance rate! (while
            // keeping uriane output btwn 30-60 mL/hour).
            evap = (35 + [_t_tbsa.text floatValue]) * bsa_val; //evaporative rate in mL/hour
            basal = (2000 * bsa_val)/24; //basal rate in mL/hour
            maint = evap + basal;  //maintenance rate in mL/hour
            
            _t_parkland1.text = [NSString stringWithFormat:@"%.1f mL/hour", prklnd/2/8];
            _t_parkland2.text = [NSString stringWithFormat:@"%.1f mL/hour", prklnd/2/16];
            _t_maintenance.text =[NSString stringWithFormat:@"%.1f mL/hour", maint];
            //totalFluids.text = [NSString stringWithFormat:@"%.1f mL", prklnd/2];
            break;
            
        default:
            break;
    }
    
    //
        NSString *bsaValText = [[NSNumber numberWithFloat:bsa_val] stringValue];
        NSString *parklandText = [[NSNumber numberWithFloat:prklnd] stringValue];
        NSString *evapText = [[NSNumber numberWithFloat:evap] stringValue];
        NSString *basalText = [[NSNumber numberWithFloat:basal] stringValue];
        NSString *maintenanceText = [[NSNumber numberWithFloat:maint] stringValue];
    
        NSString *tbsaText = _t_tbsa.text;
    
        NSMutableString* tempText = [[NSMutableString alloc] initWithString: preCalcString];
        NSString* modified = [[[[[[[[[[tempText stringByReplacingOccurrencesOfString:@"weight1" withString:_t_weight.text] stringByReplacingOccurrencesOfString:@"height1" withString:_t_height.text] stringByReplacingOccurrencesOfString:@"tbsa1" withString:tbsaText] stringByReplacingOccurrencesOfString:@"bsa1" withString:bsaValText] stringByReplacingOccurrencesOfString:@"park1" withString:parklandText] stringByReplacingOccurrencesOfString:@"park1_8hours" withString:_t_parkland1.text] stringByReplacingOccurrencesOfString:@"park1_16hours" withString:_t_parkland2.text] stringByReplacingOccurrencesOfString:@"evap1" withString:evapText] stringByReplacingOccurrencesOfString:@"basal1" withString:basalText] stringByReplacingOccurrencesOfString:@"maint1" withString:maintenanceText];

    _tv_calculationDetails.text = modified;
    [_tv_calculationDetails flashScrollIndicators];

    
}
- (IBAction)closeFluidShort:(id)sender {
    [self.delegate closeForm];
}
@end
