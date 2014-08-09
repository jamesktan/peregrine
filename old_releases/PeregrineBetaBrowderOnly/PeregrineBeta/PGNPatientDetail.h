//
//  PGNPatientDetail.h
//  PeregrineBeta
//
//  Created by James Tan on 4/15/13.
//  Copyright (c) 2013 Peregrine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionDetailDelegate <NSObject>
-(void)editPatient: (NSString*)folderName;
-(void)deletePatient:(NSString *)folderName;
@end

@interface PGNPatientDetail : UICollectionViewCell

@property (strong, nonatomic) id<CollectionDetailDelegate> delegate;


@property (strong, nonatomic) IBOutlet UILabel *l_age;
@property (strong, nonatomic) IBOutlet UILabel *l_weight;
@property (strong, nonatomic) IBOutlet UILabel *l_height;
@property (strong, nonatomic) IBOutlet UILabel *l_gender;
@property (strong, nonatomic) IBOutlet UILabel *l_patientName;
@property (strong, nonatomic) IBOutlet UILabel *l_patientID;


@property (strong, nonatomic) IBOutlet UIButton *b_edit;
@property (strong, nonatomic) IBOutlet UIButton *b_delete;

-(IBAction)a_edit:(id)sender;
-(IBAction)a_delete:(id)sender;

@end
