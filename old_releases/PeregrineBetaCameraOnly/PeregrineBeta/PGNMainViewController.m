//
//  PGNMainViewController.m
//  PeregrineBeta
//
//  Created by James Tan on 2/13/13.
//  Copyright (c) 2013 Peregrine. All rights reserved.
//

#import "PGNMainViewController.h"
#import "PGNViewController.h"
#import "PGNDashViewController.h"
//#import "PGNSerializeViewViewController.h"

#import "PGNPatientDetail.h"
#import "PGNAddSelectViewController.h"
@interface PGNMainViewController ()

@end

@implementation PGNMainViewController

@synthesize viewController;
@synthesize dashViewController;
@synthesize editManager;
//@synthesize serializeController;


-(void)editPatient:(NSString *)folderName {
    editManager = [[PGNAddSelectViewController alloc] init];
    editManager.delegate = self;
    self.editManager.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:self.editManager animated:YES completion:nil];
    NSArray *folderSplit = [folderName componentsSeparatedByString:@" - "];
    [editManager loadPatientName:[folderSplit objectAtIndex:1] loadPatientID:[folderSplit objectAtIndex:0]];
    
    
}
- (void)deletePatient:(NSString *)folderName {
    deleteFolderName = folderName;
    NSString *message = [NSString stringWithFormat:@"Are you sure you want to permanently delete: ' %@ ' and all its contents? This cannot be undone.", folderName];
    [[[UIAlertView alloc] initWithTitle:@"Are you sure?" message:message delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes" , nil] show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Theindex: %d", buttonIndex);
    switch (buttonIndex) {
        case 0: {
            //cancel
            NSLog(@"Deleting aborted");
            break;
        }
        case 1: {
            NSLog(@"The folder to delete is: %@", deleteFolderName);
            [resourceManager deleteFolderNamed: deleteFolderName];
            [_collectionView reloadData];
            break;
        }
        default: {
            NSLog(@"Nothing Chosen!");
            break;
            
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    resourceManager = [[PGNResourceManager alloc] init];
    [self.collectionView registerClass:[PGNPatientDetail class] forCellWithReuseIdentifier:@"PGNPatientDetailCell"];
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wall.png"]];

    
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    // Display this many items in the section
    int number = [[resourceManager getContentsOfMain] count];
    return number;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    // Display this number of sections
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // How to draw every cell
    static NSString *cellIdentifier = @"PGNPatientDetailCell";
    PGNPatientDetail *cell = (PGNPatientDetail *)[self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    // Get the Patient Name
    NSArray *patientFolderNames = [resourceManager getContentsOfMain];
    NSString *folderName = [patientFolderNames objectAtIndex:indexPath.row];
    NSArray *patient = [folderName componentsSeparatedByString:@" - "];

    cell.l_patientID.text = [patient objectAtIndex:0];
    cell.l_patientName.text = [patient objectAtIndex:1];
    
    // Get the Patient Details
    NSArray *patientData = [resourceManager getPatientData:folderName];
    NSString *gender = [patientData objectAtIndex:3];
    NSString *age = [patientData objectAtIndex:5];
    NSString *weight = [patientData objectAtIndex:6];
    NSString *height = [patientData objectAtIndex:7];
    
    cell.l_age.text = age;
    cell.l_gender.text = gender;
    cell.l_height.text = height;
    cell.l_weight.text = weight;
    cell.delegate = self;
    
    return cell;
}
// 4

/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *patientFolderNames = [resourceManager getContentsOfMain];
    NSString *folderName = [patientFolderNames objectAtIndex:indexPath.row];
    
    NSLog(@"And the case is! %@", folderName);
    NSArray *temp = [folderName componentsSeparatedByString:@" - "];
    [viewController loadExistingPatient:[temp objectAtIndex:0] pathentName:[temp objectAtIndex:1]];
    self.viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:self.viewController animated:YES completion:nil];

}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}


#pragma mark – UICollectionViewDelegateFlowLayout

// 1
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    //NSString *searchTerm = self.searches[indexPath.section]; FlickrPhoto *photo =
//    //self.searchResults[searchTerm][indexPath.row];
//    // 2
//    if ((mode == 1) || (mode == 0))  {
//        NSLog(@"A FOLDER!");
//        if (mode == 1) {
//            NSString *temp = [self.patientSubFolderNames objectAtIndex:indexPath.row];
//            if (!([temp rangeOfString:@"plist"].location == NSNotFound)) {
//                return CGSizeMake(1024, 1);
//            }
//            
//        }
//        return CGSizeMake(1024, 100);
//        
//    }
//    if (mode == 2) {
//        NSString *pictureName = [[self.patientSubFolderContents valueForKey: self.subFolderContentsKey] objectAtIndex:indexPath.row];
//        if (!([pictureName rangeOfString:@"plist"].location == NSNotFound))
//        {
//            NSLog(@"A PLIST WAS SELECTED!");
//            return CGSizeMake(768, 1);
//        }
//        
//    }
//    CGSize retval = CGSizeMake(1004, 748);
//    return retval;
//}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


































- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        viewController = [[PGNViewController alloc] init];
        viewController.delegate = self;
        
        dashViewController = [[PGNDashViewController alloc]init];
        dashViewController.delegate = self;
        
//        serializeController = [[PGNSerializeViewViewController alloc] init];
//        serializeController.delegate = self;
        
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////
///////////////
///////////////
///Start Managing Workflow Selection, 0 = New, 1 = Existing, 2 = View
- (IBAction)a_workflowSelection:(id)sender {
    UIButton* button = (UIButton*)sender;
    int buttonTag = button.tag;
    
    
    switch (buttonTag) {
        case 0:
            NSLog(@"Selected New Patient");
            [self.viewController startNewPatient];
            self.viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:self.viewController animated:YES completion:nil];

            break;
        case 1:
//            NSLog(@"Selected Existing Patient");
//            // We need to do something special here.
//            
//            [_busyOverlay setHidden:FALSE];
//
//            [serializeController setupToSelectCase];
//            _popover = [[UIPopoverController alloc] initWithContentViewController:serializeController];
//            [_popover setPopoverContentSize:serializeController.view.frame.size];
//            [_popover presentPopoverFromRect:CGRectMake(265, 250, 600, 300) inView:self.view permittedArrowDirections:0 animated:YES];
//            _popover.delegate = self;
            

//            [self.viewController loadExistingPatient];
//            self.viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//            [self presentViewController:self.viewController animated:YES completion:nil];
            break;
        case 2:
            NSLog(@"Selected View Patients");
            self.dashViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:self.dashViewController animated:YES completion:nil];
            
        default:
            break;
    }
}
/////////////
////////////
//////////
////End Patient Management

////////////////\\\\\\\\\\\\\\\\\\\\\\\\\
/// Start Suport for Orientation
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
    //return UIInterfaceOrientationMaskLandscape;
    //return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

-(BOOL)shouldAutorotate {
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}
//////

////////////
//////////
///////
/////Return to Main
-(void)returnToMain {
    NSLog(@"Removing view controller from view...killing and restarting the view");
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    viewController = NULL;
    viewController = [[PGNViewController alloc] init];
    viewController.delegate = self;
    
    [_collectionView reloadData];

}


// Used by dash AND add/select
-(void)goHome {
    NSLog(@"Removing dash controller from view...but not killing it!");
    [self.dashViewController dismissViewControllerAnimated:YES completion:nil];
    dashViewController = NULL;
    dashViewController = [[PGNDashViewController alloc] init];
    dashViewController.delegate = self;
    
    [self.editManager dismissViewControllerAnimated:YES completion:nil];
    editManager = NULL;
    editManager = [[PGNAddSelectViewController alloc] init];
    editManager.delegate = self;
    
    [_collectionView reloadData];

}
-(void)saveImage {
    NSLog(@"HUH?");
}

-(void)savedPatient {
    [self.editManager dismissViewControllerAnimated:YES completion:nil];
    editManager = NULL;
    editManager = [[PGNAddSelectViewController alloc] init];
    editManager.delegate = self;
    [_collectionView reloadData];
}


/////delegate methods
//-(void) closeForm {
//    [_popover dismissPopoverAnimated:YES];
//    serializeController = NULL;
//    serializeController = [[PGNSerializeViewViewController alloc] init];
//    serializeController.delegate = self;
//
//    [_busyOverlay setHidden:TRUE];
//
//}

-(void)setSelectedCase:(NSString *)folderName {
    NSLog(@"And the case is! %@", folderName);
    NSArray *temp = [folderName componentsSeparatedByString:@" - "];
    [viewController loadExistingPatient:[temp objectAtIndex:0] pathentName:[temp objectAtIndex:1]];
    self.viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:self.viewController animated:YES completion:nil];

}
-(void)setSerialPhoto:(UIImage *)image {
    // Do nothing!
}

//-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
//{
//    [_busyOverlay setHidden:TRUE];
//
//    [_popover dismissPopoverAnimated:YES];
//    serializeController = NULL;
//    serializeController = [[PGNSerializeViewViewController alloc] init];
//    serializeController.delegate = self;
//
//    
//}

@end
