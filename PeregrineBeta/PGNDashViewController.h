//
//  PGNDashViewController.h
//  PeregrineBeta
//
//  Created by James Tan on 11/23/12.
//  Copyright (c) 2012 Peregrine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGNDashCollectionViewCell.h"
#import "PGNResourceManager.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@protocol PGNDashDelegate <NSObject>
-(void)goHome;
@end

@interface PGNDashViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TheDelegate, MFMailComposeViewControllerDelegate, UIPrintInteractionControllerDelegate> {
    PGNResourceManager *resourceManager;
    
    int mode;
}
@property (strong, nonatomic) IBOutlet UIView *ed;
@property (strong, nonatomic) MFMailComposeViewController *mailViewCont;


@property (nonatomic, assign) id<PGNDashDelegate> delegate;

@property(nonatomic, strong) NSArray *patientFolders;
@property(nonatomic, strong) NSArray *patientSubFolderNames;

@property(nonatomic, strong) NSMutableDictionary *patientSubFolders;

@property(nonatomic, strong) NSMutableDictionary *patientSubFolderContents;
@property(nonatomic, strong) NSString *patientFolderName;
@property(nonatomic, strong) NSString *patientSubFolderName;

@property(nonatomic, strong) NSString *subFolderContentsKey;

@property(nonatomic, strong) NSMutableDictionary *searchResults;
@property(nonatomic, strong) NSMutableArray *searches;

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;


- (IBAction)executeHome:(id)sender;

- (IBAction)moveBackInTree:(id)sender;


@end
