//
//  PGNStandardPatientFormViewController.m
//  PeregrineBeta
//
//  Created by James Tan on 9/26/12.
//  Copyright (c) 2012 Peregrine. All rights reserved.
//

#import "PGNStandardPatientFormViewController.h"
#import "NIDropDown.h"


@interface PGNStandardPatientFormViewController ()
@end

@implementation PGNStandardPatientFormViewController

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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"limbNames" ofType:@"plist"];
    NSString *path_percent = [[NSBundle mainBundle] pathForResource:@"limbPercent" ofType:@"plist"];
    limbName = [[NSArray alloc] initWithContentsOfFile:path];
    limbPercent = [[NSArray alloc] initWithContentsOfFile:path_percent];
    
    pod_base = 0;
    limbBurn = 0;
}
-(NSArray*) getAnnotationValues {
    NSArray *returnArray = [[NSArray alloc] initWithObjects: _t_podDay.text, _b_type.titleLabel.text, _b_graft.titleLabel.text, _b_appearance.titleLabel.text, _l_burnLocation.text, _l_tbsa.text, nil];
    return returnArray;
}

-(void) clearFormOnLoad {
        [_t_podDay setText: nil];
        pod_base = 0;
        [_step_podDay setValue:0];

        [_b_type setTitle:@"Burn Type: None" forState:UIControlStateNormal];
        [_b_type setTag:0];
    
        [_b_graft setTitle:@"Graft: None" forState:UIControlStateNormal];
        [_b_graft setTag:0];
    
        [_b_appearance setTitle:@"Appearance: None" forState:UIControlStateNormal];
        [_b_appearance setTag:0];
    
        //step 3
        [_l_burnLocation setText:@"Location: None"];
        
        [_l_tbsa setText:@"0"];
}

-(void) setTBSA: (float) number {
    limbBurn = number;
    NSLog (@"%f is the limbBurn area", number);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)a_pod:(id)sender {
    int value = [(UIStepper*)sender value] + pod_base;
    NSString *stringUse = [[NSString alloc] initWithFormat:@"POD#: %d", value ];
    _t_podDay.text = stringUse;
    
}
- (IBAction)doneEditing:(id)sender {
    [(UITextField*)sender resignFirstResponder];
    
    pod_base = [_t_podDay.text intValue];
}

- (IBAction)selectClicked:(id)sender {
    NSArray * arr = [[NSArray alloc] init];
    switch ([(UIButton*)sender tag]) {
        case 0:
            arr = [NSArray arrayWithObjects:
                   @"Burn Type: First", @"Burn Type: Second", @"Burn Type: Third", @"Burn Type: Necotizing Fasciitis", @"Burn Type: TENS/SJS", @"Burn Type: N/A",nil];
            break;
        case 1:
            arr = [NSArray arrayWithObjects:
                   @"Appearance: Solid Eschar", @"Appearance: Separating Eschar", @"Appearance: Pink/Moist",
                   @"Appearance: Skin Buds", @"Appearance: Graft-pink/adherent", @"Appearance: Graft-fragile/spotty",
                   @"Appearance: Re-Epithelialized",@"Appearance: Granualation", @"Appearance: N/A",
                   nil];
            break;
        case 2:
            arr = [NSArray arrayWithObjects:@"Graft: Autograft", @"Graft: Homograph", @"Graft: Donor", @"Graft: Healed", @"Graft: Cadaver", @"Graft: Pig Skin", @"Graft: Flap", @"Graft: TENS", @"Graft: N/A", nil];
            break;
        default:
            break;
    }
    UIButton *button = (UIButton*)sender;
    NSString *tempTitle = [sender title];
    if (![tempTitle isEqualToString:@"Select"]) {
        NSString *myFile = [[NSBundle mainBundle] pathForResource:@"gold_light_box" ofType:@"png"];
        
        UIImage *anImage = [UIImage imageWithContentsOfFile:myFile];
        [button setBackgroundImage:anImage forState:UIControlStateNormal];
    }
    
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender height:&f array:arr];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
}
-(void)rel{
    dropDown = nil;
}

- (IBAction)a_browder:(id)sender {
    UIButton *button = (UIButton*)sender;
    int tag = [button tag];
    [_l_burnLocation setText:[limbName objectAtIndex:tag]];
    
    //float limb = [[limbPercent objectAtIndex:tag] floatValue];
    //NSLog(@"Limb Selected area: %f", limb);
    
    //float final = 0.5*limb*limbBurn;
    //NSLog(@"Final area: %f", final);
    //NSString *temp = [[NSString alloc] initWithFormat:@"%.2f",final];
    //[_l_tbsa setText:temp];
}

- (IBAction)a_browder_extra:(id)sender {
    UIButton *button = (UIButton*)sender;
    NSString *text = button.titleLabel.text;
    
    [_l_burnLocation setText:text];
}

- (IBAction)a_close:(id)sender {
    [self.delegate closeForm];
}

@end
