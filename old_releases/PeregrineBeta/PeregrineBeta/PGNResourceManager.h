//
//  PGNResourceManager.h
//  PeregrineBeta
//
//  Created by James Tan on 11/27/12.
//  Copyright (c) 2012 Peregrine. All rights reserved.
//
#import "AssetsLibrary/AssetsLibrary.h"
#import <Foundation/Foundation.h>

@interface PGNResourceManager : NSObject <UIImagePickerControllerDelegate> {
    NSFileManager *fileManager;
    NSArray *paths;
    
}
@property (strong, atomic) ALAssetsLibrary* library;

-(void)deleteFolderNamed:(NSString*)deleteFolderName;

-(BOOL)checkPatientExists:(NSString*)inputName;
-(void)copyPatientFolder: (NSString*)currentFolder newFolder:(NSString*)newFolder;
-(void)savePatient: (NSString*)patientName data:(NSArray*)data;
-(void)savePhotoToLibrary: (UIImage*)imageToSave;
-(void)savePhoto: (NSString*)patientName data:(NSArray*)data imageToSave:(UIImage*)imageToSave folderName:(NSString*)folderName;
-(void)saveFluids: (NSString*)patientName data:(NSArray*)data;

//-(void)deletePatient: (NSString*)patientName;
//-(void)deletePhoto: (NSString*)patientName imageName: (NSString*)photoName;
//-(void)deleteFluids: (NSString*)patientName fluidtitle:(NSString*)fluidTitle;

-(NSArray*)getPatientData: (NSString*)patientName;
-(NSArray*)getContentsOfMain; // gets patient folder
-(NSArray*)getContentsOfThisFolder:(NSString*)patientName; // get patient folder subfolders
-(NSArray*)getContentsOfFolder:(NSString *)patientName  subFolder:(NSString*)folderName; // gets patient subfolder contents
-(UIImage*)getImageInFolder:(NSString*)patientName subFolder:(NSString*)folderName imageName:(NSString*)imageName;

-(NSString*)formImagePath: (NSString*)patientName folderName:(NSString*)folderName imageName:(NSString*)imageName;

//-(void)getPatient;
//-(void)getPhoto;
//-(void)getBrowder;
//-(void)getFluids;

-(NSString*)getTime;
-(void)deleteAllFoldersFiles;

//-(void)getFolderContents;
//-(void)deleteAllData;

@end
