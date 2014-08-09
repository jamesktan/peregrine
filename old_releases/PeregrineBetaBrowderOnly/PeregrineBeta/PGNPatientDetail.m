//
//  PGNPatientDetail.m
//  PeregrineBeta
//
//  Created by James Tan on 4/15/13.
//  Copyright (c) 2013 Peregrine. All rights reserved.
//

#import "PGNPatientDetail.h"

@implementation PGNPatientDetail

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { // Initialization code
        //self.mailViewCont = [[MFMailComposeViewController alloc] init];
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PGNPatientDetailCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) { return nil; }
        
        self = [arrayOfViews objectAtIndex:0];
        
    }
    
    return self;
    
}

-(IBAction)a_edit:(id)sender {
    NSString *folderName = [[_l_patientID.text stringByAppendingString:@" - "] stringByAppendingString:_l_patientName.text];
    [self.delegate editPatient:folderName];
}

-(IBAction)a_delete:(id)sender {
    NSString *folderName = [[_l_patientID.text stringByAppendingString:@" - "] stringByAppendingString:_l_patientName.text];
    [self.delegate deletePatient:folderName];
}
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
