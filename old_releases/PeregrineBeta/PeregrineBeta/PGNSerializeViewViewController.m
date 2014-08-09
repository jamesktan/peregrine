//
//  PGNSerializeViewViewController.m
//  PeregrineBeta
//
//  Created by James Tan on 1/29/13.
//  Copyright (c) 2013 Peregrine. All rights reserved.
//

#import "PGNSerializeViewViewController.h"
#import "PGNResourceManager.h"
@interface PGNSerializeViewViewController ()

@end

@implementation PGNSerializeViewViewController
@synthesize delegate;
@synthesize patientFolderName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        patientFolderName = [[NSMutableString alloc] init];
        _keepPatientName = [[NSMutableString alloc] init];
        resourceManager = [[PGNResourceManager alloc] init];
        limbFolderContents = [[NSMutableArray alloc] init];
        // Do any additional setup after loading the view from its nib.
        
        _tableView.delegate = self;
        
        mode = 1;
        editingMode = 0;

    }
    return self;
}

-(void)loadData: (NSString*)data {
    patientFolderName = [data copy];
    _keepPatientName = [data copy];
    
    NSString *string1 = patientFolderName;
    NSArray *stuff = [resourceManager getContentsOfThisFolder:[string1 copy]];
    
    
    limbFolderContents = [[NSMutableArray alloc] initWithArray: stuff];
    [_tableView reloadData];
    
}

-(void) setupToSelectCase {
    /// setupToSelectCase - Called by MainViewController to setup the popup.
    NSArray *stuff = [resourceManager getContentsOfMain];
    limbFolderContents = [[NSMutableArray alloc] initWithArray:stuff];
    mode = 3;
    _backButton.enabled = NO;
    _backButton.width= 0.01;
    _b_editButton.enabled = YES;
    [_tableView reloadData];
}

- (IBAction)goBack:(id)sender {
    if (mode == 3) {
        return;
    }
    mode =1;
    NSArray *stuff = [resourceManager getContentsOfThisFolder:_keepPatientName];
    limbFolderContents = [[NSMutableArray alloc] initWithArray:stuff];

    [_tableView reloadData];

    
}

- (IBAction)closeForm:(id)sender {
    [self.delegate closeForm];
}

- (IBAction)a_editAction:(id)sender {
    if (mode == 3) {
        if (editingMode == 0) {
            NSLog(@"Editing cases!");
            [_tableView setEditing:YES animated:YES];
            editingMode = 1;
            return;
        }
        else {
            [_tableView setEditing:NO animated:YES];
            editingMode = 0;
            return;
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Edit mode not allowed." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
    }
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
            
            // Reload and check for stuff
            NSArray *stuff = [resourceManager getContentsOfMain];
            limbFolderContents = [[NSMutableArray alloc] initWithArray:stuff];
            
            [_tableView reloadData];
            break;
        }
        default: {
            NSLog(@"Nothing Chosen!");
            break;
            
        }
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Delete!");
    
    NSString *folderToDelete = [limbFolderContents objectAtIndex:indexPath.row];
    deleteFolderName = folderToDelete;
    
    NSString *message = [NSString stringWithFormat:@"Are you sure you want to delete? %@", deleteFolderName];
    [[[UIAlertView alloc] initWithTitle:@"Are you sure?" message:message delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes" , nil] show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadPatientData: (NSArray*)data {
}
#pragma mark Table View Data Source Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int returnValue;
    if (mode == 1) {
        NSArray *stuff = [resourceManager getContentsOfThisFolder:_keepPatientName];
        limbFolderContents = [[NSMutableArray alloc] initWithArray:stuff];
        NSLog(@"NumberOfRows");
        NSLog(@"%d",[limbFolderContents count]);
        returnValue = [limbFolderContents count];
    }
    if (mode==2) {
        NSArray *otherStuff = [resourceManager getContentsOfFolder:_keepPatientName subFolder:patientFolderName];
        returnValue = [otherStuff count];
    }
    if (mode==3) {
        // Case Select
        returnValue = [limbFolderContents count];
    }
    return returnValue;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SimpleTableIdentifier];
    };
    
    NSString *fileName = [limbFolderContents objectAtIndex:indexPath.row];
    UIImage *image2 = [resourceManager getImageInFolder:_keepPatientName subFolder:_keepFolderName imageName:fileName];
    cell.imageView.image = image2;
    cell.textLabel.text = fileName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (mode == 1) {
        NSString *fileName = [limbFolderContents objectAtIndex:indexPath.row];
        if ([fileName hasSuffix:@".plist"]) {
            [[[UIAlertView alloc] initWithTitle: @"Incorrect Selection" message:@"Cannot select a .plist file, please select a .png file." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        } else {
            NSString *name = [limbFolderContents objectAtIndex:indexPath.row];
            NSArray *subArray = [resourceManager getContentsOfFolder:_keepPatientName subFolder:name];

            limbFolderContents = (NSMutableArray*)subArray;
            patientFolderName = name;
            _keepFolderName = name;

            mode = 2;
        }
    }
    else if (mode == 2) {
        NSString *fileName = [limbFolderContents objectAtIndex:indexPath.row];
        if ([fileName hasSuffix:@".plist"]) {
            [[[UIAlertView alloc] initWithTitle: @"Incorrect Selection" message:@"Cannot select a .plist file, please select a .png file." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        } else {
            UIImage *imageRecieved = [resourceManager getImageInFolder:_keepPatientName subFolder:_keepFolderName imageName:fileName];
            [self.delegate setSerialPhoto:imageRecieved];
            [self.delegate closeForm];
        }
        
    }
    else if (mode == 3) {
        //select a case
        NSString *folderName = [limbFolderContents objectAtIndex:indexPath.row];
        [self.delegate setSelectedCase:folderName];
        [self.delegate closeForm];
        
        NSLog(@"Case Selected!");
    }
    else {
        NSLog(@"unknown!");
        
        //resourceManager get
    }

    [_tableView reloadData];
    
    //NSString* patientFolder = [limbFolderContents objectAtIndex:indexPath.row];
    //NSArray *folderArray = [patientFolder componentsSeparatedByString:@" - "];
    //patientName = [folderArray objectAtIndex:1];
    //patientID = [folderArray objectAtIndex:0];
    //[self.delegate savedPatient];
}

@end
