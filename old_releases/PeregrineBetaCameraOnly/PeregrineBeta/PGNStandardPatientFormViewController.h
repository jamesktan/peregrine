//
//  PGNStandardPatientFormViewController.h
//  PeregrineBeta
//
//  Created by James Tan on 9/26/12.
//  Copyright (c) 2012 Peregrine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"


@protocol PGNPhotoAnnotateDelegate <NSObject>
-(void)closeForm;
@end

@interface PGNStandardPatientFormViewController : UIViewController < NIDropDownDelegate>{
    NSArray *limbName;
    NSArray *limbPercent;
    float limbBurn;
    int pod_base;

    NIDropDown *dropDown;


}

@property (nonatomic, assign) id<PGNPhotoAnnotateDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *t_podDay;
@property (weak, nonatomic) IBOutlet UIStepper *step_podDay;

@property (weak, nonatomic) IBOutlet UIButton *b_type;
@property (weak, nonatomic) IBOutlet UIButton *b_graft;
@property (weak, nonatomic) IBOutlet UIButton *b_appearance;

@property (weak, nonatomic) IBOutlet UILabel *l_burnLocation;
@property (weak, nonatomic) IBOutlet UILabel *l_tbsa;

-(void) setTBSA: (float) number;
-(void) clearFormOnLoad;
-(NSArray*) getAnnotationValues;

- (IBAction)a_pod:(id)sender;
- (IBAction)selectClicked:(id)sender;

- (IBAction)a_browder_extra:(id)sender;
- (IBAction)a_browder:(id)sender;
- (IBAction)a_close:(id)sender;

@end
