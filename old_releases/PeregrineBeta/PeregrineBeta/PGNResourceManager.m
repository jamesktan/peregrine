//
//  PGNResourceManager.m
//  PeregrineBeta
//
//  Created by James Tan on 11/27/12.
//  Copyright (c) 2012 Peregrine. All rights reserved.
//

#import "PGNResourceManager.h"

//#import "ALAssetsLibrary+CustomPhotoAlbum.h" //not working yet

@implementation PGNResourceManager
@synthesize library; //not working yet

-(id)init
{
    self = [super init];
    if (self) {
        fileManager = [[NSFileManager alloc] init];
        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES );
        self.library = [[ALAssetsLibrary alloc] init];

    }
    return self;
}
-(void)copyPatientFolder:(NSString *)currentFolder newFolder:(NSString *)newFolder{
    NSLog(@"Copying folder!");
    NSString *newDirectoryName = newFolder;
    NSString *oldPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:currentFolder];
    NSString *newPath = [[oldPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newDirectoryName];
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:&error];
    if (error) {
        NSLog(@"%@",error.localizedDescription);
        // handle error
    }
}
-(BOOL)checkPatientExists:(NSString*)inputName {
    NSString *patientFolderPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:inputName];

    BOOL Value = [[NSFileManager defaultManager] fileExistsAtPath: patientFolderPath isDirectory:(BOOL*)TRUE];
    if (Value) {
        return TRUE;
    }
    return FALSE;
}
-(NSString*)formImagePath: (NSString*)patientName folderName:(NSString*)folderName imageName:(NSString*)imageName {
    return [[[[paths objectAtIndex:0] stringByAppendingPathComponent:patientName] stringByAppendingPathComponent:folderName]stringByAppendingPathComponent:imageName];
}

-(NSString*)getTime {
    // Get the Time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMM dd yyyy HH:mm:ss" options:0 locale:[NSLocale currentLocale]]];
    NSString *theTime = [dateFormatter stringFromDate:[NSDate date]];
    
    return theTime;
}

-(NSArray*)getPatientData: (NSString*)patientName {
    NSString*patientInfoPath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:patientName] stringByAppendingPathComponent:@"patientInformation.plist"];
    NSArray *patientArray = [[NSArray alloc] initWithContentsOfFile:patientInfoPath];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:patientInfoPath];
    NSLog(fileExists ? @"Yes" : @"No");
    
    NSLog(@"Getting Patient Information");
    NSLog(@"%@", patientInfoPath);
    NSLog(@"%@", patientArray);
    
    return patientArray;
}
-(NSArray*)getContentsOfMain {
    return [fileManager contentsOfDirectoryAtPath:[paths objectAtIndex:0] error: nil];
}
-(NSArray*)getContentsOfThisFolder:(NSString*)patientName {
    NSString *patientFolderPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:patientName];
    NSLog(@"hell!");
    NSLog(@"%@", patientName);
    NSLog(@"%@", patientFolderPath);
    return [fileManager contentsOfDirectoryAtPath: patientFolderPath error: nil];
}

-(NSArray*)getContentsOfFolder:(NSString *)patientName  subFolder:(NSString*)folderName {
    NSString *patientSubFolderPath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:patientName] stringByAppendingPathComponent:folderName];
    return [fileManager contentsOfDirectoryAtPath: patientSubFolderPath error: nil];


}
-(UIImage*)getImageInFolder:(NSString*)patientName subFolder:(NSString*)folderName imageName:(NSString*)imageName {
    NSString *patientSubFolderPath = [[[[paths objectAtIndex:0] stringByAppendingPathComponent:patientName] stringByAppendingPathComponent:folderName] stringByAppendingPathComponent:imageName];
    UIImage *imageReturn = [UIImage imageWithContentsOfFile:patientSubFolderPath];
    NSLog(@"%@", imageReturn);
    return imageReturn;
}

-(void)savePatient: (NSString*)patientName data:(NSArray*)data {
    NSMutableArray *dataFixed = [[NSMutableArray alloc] init];
    for (int a = 0; a < [data count]; a++) {
        UITextField *temp = (UITextField*)[data objectAtIndex:a];
        NSString *tempString = temp.text;
        [dataFixed addObject: tempString];
    }
    
    // Create the Case Folder
    NSString *patientFolderPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:patientName];
    [fileManager createDirectoryAtPath:patientFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    // Save The Array To File
    NSString *patientInfoName = [[NSString alloc] initWithFormat:@"patientInformation.plist"];
    NSString *filePath = [patientFolderPath stringByAppendingPathComponent: patientInfoName];
    [dataFixed writeToFile: filePath atomically:YES];
    NSLog(@"Saving The Patient");
    NSLog(@"%@", filePath);

    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    //BOOL fileExists = [[NSFileManager defaultManager] isWritableFileAtPath:filePath];
    NSLog(fileExists ? @"Yes" : @"No");


}

-(void)savePhotoToLibrary: (UIImage*)imageToSave {
    UIImageWriteToSavedPhotosAlbum(imageToSave,nil,NULL,NULL);
    //[self.library addAssetsGroupAlbumWithName:@"Peregrine" resultBlock:nil failureBlock:nil];
    
    //Does not yet save to proper album..
    //[self.library saveImage:imageToSave toAlbum:@"Peregrine" withCompletionBlock:^(NSError *error) {
    //    if (error!=nil) {
    //        NSLog(@"Big error: %@", [error description]);
    //    }
    //}];

}


-(void)savePhoto:(NSString *)patientName data:(NSArray *)data imageToSave:(UIImage *)imageToSave folderName:(NSString*)folderName {
    NSString *podDay = [[data objectAtIndex:5] stringByAppendingString:@" - "]; //might not be 5
    NSString *theTime = [self getTime];
    
    // Create the Case Folder and/or the Limb Folder
    NSString *patientFolderPath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:patientName] stringByAppendingPathComponent:folderName];
    [fileManager createDirectoryAtPath:patientFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    // Save the data to the folder
    NSString *dataString = [patientFolderPath stringByAppendingPathComponent:[[podDay stringByAppendingString:theTime]stringByAppendingString:@".plist"]];
    [data writeToFile:dataString atomically:NO];
    
    // Save the photo to the folder
    NSString *photoString = [patientFolderPath stringByAppendingPathComponent:[[podDay stringByAppendingString:theTime]stringByAppendingString:@".png"]];
    NSData *image = UIImagePNGRepresentation(imageToSave);
    [image writeToFile:photoString atomically:NO];
    
    //

}

-(void)saveFluids:(NSString *)patientName data:(NSArray *)data {
    NSString *identifier = [[[[data objectAtIndex:0] stringByAppendingString:@" - "]stringByAppendingString:[self getTime]] stringByAppendingString:@".plist"];
    
    NSString *patientFolderPath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:patientName] stringByAppendingPathComponent:@"Fluids"];
    
    [data writeToFile:[patientFolderPath stringByAppendingPathComponent:identifier] atomically:NO];
}

-(void)deleteFolderNamed:(NSString*)deleteFolderName {
    NSString *deletePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:deleteFolderName];
    [fileManager removeItemAtPath:deletePath error:nil];

}


-(void)deleteAllFoldersFiles
{
    NSString* workingDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"Deleting directory");
    //NSLog(workingDirectoryPath);
    [fileManager removeItemAtPath:workingDirectoryPath error:nil];
}

@end
