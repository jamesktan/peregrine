//
//  PGNFluidShortViewController.h
//  PeregrineBeta
//
//  Created by James Tan on 1/29/13.
//  Copyright (c) 2013 Peregrine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PGNFluidShortDelegate <NSObject>
-(void)closeForm;
@end

@interface PGNFluidShortViewController : UIViewController {
    NSString *preCalcString;
}

- (IBAction)closeFluidShort:(id)sender;
- (IBAction)calculateFluid:(id)sender;
- (IBAction)doneEditing:(id)sender;
- (void)loadPatientData: (NSArray*)data;
- (void)loadTBSA:(NSString*)value;

@property (nonatomic, assign) id<PGNFluidShortDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *t_age;
@property (strong, nonatomic) IBOutlet UITextField *t_weight;
@property (strong, nonatomic) IBOutlet UITextField *t_height;
@property (strong, nonatomic) IBOutlet UITextField *t_tbsa;
@property (strong, nonatomic) IBOutlet UITextField *t_parkland1;
@property (strong, nonatomic) IBOutlet UITextField *t_parkland2;
@property (strong, nonatomic) IBOutlet UITextField *t_maintenance;

@property (strong, nonatomic) IBOutlet UITextView *tv_calculationDetails;

@end
