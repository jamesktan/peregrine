//
//  PGNMainViewController.h
//  PeregrineBeta
//
//  Created by James Tan on 2/13/13.
//  Copyright (c) 2013 Peregrine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGNViewController.h"
#import "PGNDashViewController.h"
//#import "PGNSerializeViewViewController.h" //for the popover

#import "PGNPatientDetail.h"
#import "PGNResourceManager.h"

#import "PGNAddSelectViewController.h"
@class PGNViewController;

@interface PGNMainViewController : UIViewController <CollectionDetailDelegate, PGNViewDelegate, PGNDashDelegate, PGNSelectOrAddPatient, UIAlertViewDelegate> {
    PGNResourceManager *resourceManager;
    NSString *deleteFolderName;

}
//PGNSerializeDelegate
//UIPopoverControllerDelegate

@property (strong, nonatomic) PGNAddSelectViewController *editManager;
@property (strong, nonatomic) PGNViewController *viewController;
@property (strong, nonatomic) PGNDashViewController *dashViewController;
//@property (strong, nonatomic) PGNSerializeViewViewController *serializeController;

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;


@property (strong, nonatomic) IBOutlet UIImageView *busyOverlay;
@property (strong, nonatomic) UIPopoverController *popover;


//a_workflowSection: selects an appropriate patient workflow to use.
// 1 = New Case
// 2 = Existing Case
// 3 = View Cases
- (IBAction)a_workflowSelection:(id)sender;

@end
