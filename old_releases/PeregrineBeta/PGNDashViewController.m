//
//  PGNDashViewController.m
//  PeregrineBeta
//
//  Created by James Tan on 11/23/12.
//  Copyright (c) 2012 Peregrine. All rights reserved.
//

#import "PGNDashViewController.h"

@interface PGNDashViewController ()

@end

@implementation PGNDashViewController

@synthesize delegate;
@synthesize mailViewCont;

-(void)passPhotoToPrinter:(UIImage *)image {
    NSLog(@"Pass to printer");
    if ([UIPrintInteractionController isPrintingAvailable])
    {
        // Available
        NSMutableString *printBody = [NSMutableString stringWithFormat:@"Printed from Peregrine"];
        
        UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
        pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"Peregrine Photo";
        pic.printInfo = printInfo;
        
        UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc] initWithText:printBody];
        textFormatter.startPage = 0;
        textFormatter.contentInsets = UIEdgeInsetsMake(36.0, 36.0, 36.0, 36.0); // 1 inch margins
        textFormatter.maximumContentWidth = 6 * 72.0;
        pic.printFormatter = textFormatter;
        pic.printingItem = image;
        pic.showsPageRange = YES;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"Printing could not complete because of error: %@", error);
            } else if (completed){
                [[[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your image has printed!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
            } else {
                NSLog(@"Some Other State!");
            }
        };
        [pic presentFromRect:CGRectMake(50, 50, 200, 200) inView:self.view animated:YES completionHandler:completionHandler];
        //[pic presentAnimated:YES completionHandler:completionHandler];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"A printer is not available!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    }
    
}
-(void)passPhotoToEmail:(UIImage *)image {
    NSLog(@"Passing to EMAIL");
    self.mailViewCont = [[MFMailComposeViewController alloc] init];
    
    self.mailViewCont.mailComposeDelegate = self;
    [self.mailViewCont setSubject:@"Peregrine Burn Image Attachment"];
    
    UIImage *roboPic = image;
    NSData *imageData = UIImageJPEGRepresentation(roboPic, 1);
    [self.mailViewCont addAttachmentData:imageData mimeType:@"image/jpg" fileName:@"burnImage.png"];
    
    NSString *emailBody = @"An image attachment";
    [self.mailViewCont setMessageBody:emailBody isHTML:YES];
    
    [self presentViewController:self.mailViewCont animated:YES completion:^(void) {
    }];
        //[self presentModalViewController:picker animated:YES];
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self.mailViewCont dismissViewControllerAnimated:YES completion:nil];
    if (result == MFMailComposeResultSent) {
        [[[UIAlertView alloc] initWithTitle:@"Sent!" message:@"Your message was sent!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
    } else if (result == MFMailComposeResultSaved)
    {
        [[[UIAlertView alloc] initWithTitle:@"Saved!" message:@"Your message was saved!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];

    } else {
        NSLog(@"Nothing was done to this message");
    }
    
}

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
    
    mailViewCont = [[MFMailComposeViewController alloc] init];
    resourceManager = [[PGNResourceManager alloc] init];

    self.searches = [@[] mutableCopy];
    self.searchResults = [@{} mutableCopy];
        
    // Load the appropriate data
    self.patientSubFolders = [[NSMutableDictionary alloc] init];
    self.patientSubFolderContents = [[NSMutableDictionary alloc] init];

    self.patientFolders = [resourceManager getContentsOfMain];
    
    for (int a = 0; a < [self.patientFolders count]; a++) {
        self.patientFolderName = [self.patientFolders objectAtIndex:a]; //store the patient name
        
        NSArray *SubFolderNames = [resourceManager getContentsOfThisFolder:self.patientFolderName];
        [self.patientSubFolders setValue:SubFolderNames forKey:self.patientFolderName]; // map patient names to subfolder array
        for (int b = 0; b < [SubFolderNames count]; b++) {
            NSArray* subFolderContents = [resourceManager getContentsOfFolder:self.patientFolderName subFolder:[SubFolderNames objectAtIndex:b]];
            NSString *string = [[self.patientFolderName stringByAppendingString: @" - "] stringByAppendingString:[SubFolderNames objectAtIndex: b]];
            [self.patientSubFolderContents setValue:subFolderContents forKey:string]; //mad the patientName+folder name to the folder contents.
        }
        NSLog(@"%@", self.patientSubFolderContents);
    }
    // Load the appropriate data END
    
    //[self.collectionView reloadData]; // reloads data
    
    NSString *ape = @"Search";
    [self.searches addObject:ape];
    NSArray *arr = [[NSArray alloc] initWithObjects:@"Moo1", @"Moo2", @"MOOR#",@"DAWDAW", nil];
    
    [self.searchResults setValue:arr forKey:ape];

    [self.collectionView registerClass:[PGNDashCollectionViewCell class] forCellWithReuseIdentifier:@"PGNCell"];

    mode = 0; // basic

}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    //NSString *searchTerm = self.searches[section];
    if (mode == 0) {
        return [self.patientFolders count];
    }
    if (mode == 1) {
        return [[self.patientSubFolders valueForKey:self.patientFolderName] count];
    }
    if (mode == 2) {
        return [[self.patientSubFolderContents valueForKey:self.subFolderContentsKey] count];
    }
    return 0;
}
// 2

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"PGNCell";
    
    PGNDashCollectionViewCell *cell = (PGNDashCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    if (mode == 0) {
        cell.a_label.text = [self.patientFolders objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"patientDashb3.png"];
        cell.delegate = self;
        cell.b_email.hidden = TRUE;
        cell.b_print.hidden = TRUE;
    }
    if (mode == 1) {
        cell.a_label.text = [[self.patientSubFolders valueForKey: self.patientFolderName] objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"limb.png"];
        cell.delegate = self;
        cell.b_email.hidden = TRUE;
        cell.b_print.hidden = TRUE;


        
    }
    if (mode == 2) {
        NSString *pictureName = [[self.patientSubFolderContents valueForKey: self.subFolderContentsKey] objectAtIndex:indexPath.row];
        NSString *path = [resourceManager formImagePath:self.patientFolderName folderName:self.patientSubFolderName imageName:pictureName];
        cell.imageView.image = [[UIImage alloc] initWithContentsOfFile: path];
        if (!([pictureName rangeOfString:@"plist"].location == NSNotFound))
        {
            cell.imageView.image = [UIImage imageNamed:@"limb.png"];
        }
        cell.a_label.text = pictureName;
        cell.delegate = self;
        cell.b_email.hidden = false;
        cell.b_print.hidden = false;



    }
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
    // TODO: Select Item
        
    // Click1: Patient SubFolder List (patient selected)
    if (mode == 0) { // 0 = at top layer, patient list
        NSLog(@"Patient Selected");
        
        //set current patient name
        self.patientFolderName = [self.patientFolders objectAtIndex:indexPath.row];
        
        //set the subfolder data
        self.patientSubFolderNames = [self.patientSubFolders valueForKey:self.patientFolderName];
        mode = 1; // 1 = middle layer, subfolder list
        
        [self.collectionView reloadData];

    }
    else if (mode == 1) {
        NSLog(@"Folder Selected");
        //[[self.patientSubFolders valueForKey: self.patientSubFolderName] objectAtIndex: indexPath.row];
        
        // set the current selected folder name
        self.patientSubFolderName = [[self.patientSubFolders valueForKey: self.patientFolderName] objectAtIndex:indexPath.row];
        NSLog(@"%@", self.patientSubFolderName);
        
        // set the folder key
        self.subFolderContentsKey = [[self.patientFolderName stringByAppendingString:@" - "] stringByAppendingString:self.patientSubFolderName];
        
        mode = 2; // 2 = bottom layer, subfolder content
        [self.collectionView reloadData];

        
    }
    else if (mode ==2) {
        NSLog(@"File Selected");
        NSArray *new = [self.patientSubFolderContents valueForKey:self.subFolderContentsKey];
        NSString *fileName = [new objectAtIndex:indexPath.row];
        NSLog(@"File Selected: %@", fileName);

        //NSString *path = [resourceManager formImagePath:self.patientFolderName folderName:self.patientSubFolderName imageName:fileName];
        //UIImage *image = [[UIImage alloc] initWithContentsOfFile: path];
        
        

    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}


#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSString *searchTerm = self.searches[indexPath.section]; FlickrPhoto *photo =
    //self.searchResults[searchTerm][indexPath.row];
    // 2
    if ((mode == 1) || (mode == 0))  {
        NSLog(@"A FOLDER!");
        if (mode == 1) {
            NSString *temp = [self.patientSubFolderNames objectAtIndex:indexPath.row];
            if (!([temp rangeOfString:@"plist"].location == NSNotFound)) {
                return CGSizeMake(1024, 1);
            }

        }
        return CGSizeMake(1024, 100);
        
    }
    if (mode == 2) {
        NSString *pictureName = [[self.patientSubFolderContents valueForKey: self.subFolderContentsKey] objectAtIndex:indexPath.row];
        if (!([pictureName rangeOfString:@"plist"].location == NSNotFound))
        {
            NSLog(@"A PLIST WAS SELECTED!");
            return CGSizeMake(768, 1);
        }
        
    }
    CGSize retval = CGSizeMake(1004, 748);
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


////////////////\\\\\\\\\\\\\\\\\\\\\\\\\
/// Start Suport for Orientation
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

-(BOOL)shouldAutorotate {
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
/////////////////
//END

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)executeHome:(id)sender {
    //[resourceManager deleteAllFoldersFiles];
    [self.delegate goHome];
}

- (IBAction)moveBackInTree:(id)sender {
    // Move back in the tree
    
    if (mode == 2) {
        mode = 1;
        [self.collectionView reloadData];
        return;
    }
    if (mode == 1) {
        mode = 0;
        [self.collectionView reloadData];
        return;
    }
    
}
@end
