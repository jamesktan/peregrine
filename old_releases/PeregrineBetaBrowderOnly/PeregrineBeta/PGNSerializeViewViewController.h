//
//  PGNSerializeViewViewController.h
//  PeregrineBeta
//
//  Created by James Tan on 1/29/13.
//  Copyright (c) 2013 Peregrine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGNResourceManager.h"

@protocol PGNSerializeDelegate <NSObject>

-(void)closeForm;
-(void)setSerialPhoto:(UIImage*)image;
-(void)setSelectedCase:(NSString*)folderName;

@end

@interface PGNSerializeViewViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    PGNResourceManager *resourceManager;
    NSMutableString *patientName;
    NSMutableArray *limbFolderContents;
    int mode;
    int editingMode;
    NSString *deleteFolderName;
}
-(void) setupToSelectCase;
- (void)loadData: (NSString*)data;
- (IBAction)goBack:(id)sender;
- (IBAction)closeForm:(id)sender;
- (IBAction)a_editAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *b_editButton;

@property (nonatomic, assign) id<PGNSerializeDelegate> delegate;
@property(nonatomic, retain) NSString *patientFolderName;
@property(nonatomic, retain) NSString *keepPatientName;
@property(nonatomic, retain) NSString *keepFolderName;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
