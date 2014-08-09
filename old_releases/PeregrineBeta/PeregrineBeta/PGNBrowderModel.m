//
//  PGNBrowderModel.m
//  PeregrineBeta
//
//  Created by James Tan on 4/7/13.
//  Copyright (c) 2013 Peregrine. All rights reserved.
//

#import "PGNBrowderModel.h"
#import <QuartzCore/QuartzCore.h>

@implementation PGNBrowderModel

-(id) init
{
    NSLog(@"Browder Model Initiated!");
    
    // Get the Data PList
    NSString *path = [[NSBundle mainBundle] pathForResource:@"limb_coordinates" ofType:@"plist"];
    NSDictionary *packed_data = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    // Unpack the data from the plist
    browder_names = [packed_data objectForKey:@"names"];
    browder_totals_front = [[packed_data objectForKey:@"totals"] objectForKey:@"front"];
    browder_totals_back = [[packed_data objectForKey:@"totals"] objectForKey:@"back"];
    
    browder_front_coordinates = [packed_data objectForKey:@"front"];
    browder_back_coordinates = [packed_data objectForKey:@"back"];
    
    browder_name_coordinates = [packed_data objectForKey:@"mappings"];
    
    browder_percentages_front = [[packed_data objectForKey:@"percentages"] objectForKey:@"front"];
    browder_percentages_back = [[packed_data objectForKey:@"percentages"] objectForKey:@"back"];

    
    // Assemble the data from the plist
    // Map limb names to their keys
    // Map the keys to their coordinates
    // Create the CGRects from the coordinates
    // Add the CGRects and map them to their key names (assign back or front where necessary)
    
    browder_rectangles_front = [[NSMutableDictionary alloc] init]; //mapping of master keys
    browder_rectangles_back = [[NSMutableDictionary alloc] init];
    
    NSLog(@"%@", browder_names);
    for (int a = 0; a < [browder_names count]; a++) {
        NSString *key = [browder_name_coordinates objectForKey:[browder_names objectAtIndex:a]];
        NSLog(@"%@ is the Key", key);
        
        NSArray *coordinate_front = [browder_front_coordinates objectForKey:key];
        
        // Front - 2
        if ([coordinate_front count] == 2) {
            CGPoint point_0 = CGPointFromString([coordinate_front objectAtIndex:0]);
            CGPoint point_1 = CGPointFromString([coordinate_front objectAtIndex:1]);
            NSString *hitbox = NSStringFromCGRect([self formCGRect:point_0 secondPoint:point_1]);
            
            NSArray *temp = [[NSArray alloc] initWithObjects:hitbox ,nil];
            [browder_rectangles_front setObject: temp forKey: key];
        }
        
        // Front - 4
        if ([coordinate_front count] == 4) {
            CGPoint point_0 = CGPointFromString([coordinate_front objectAtIndex:0]);
            CGPoint point_1 = CGPointFromString([coordinate_front objectAtIndex:1]);
            NSString *hitbox = NSStringFromCGRect([self formCGRect:point_0 secondPoint:point_1]);
            
            CGPoint point_2 = CGPointFromString([coordinate_front objectAtIndex:2]);
            CGPoint point_3 = CGPointFromString([coordinate_front objectAtIndex:3]);
            NSString *hitbox2 = NSStringFromCGRect([self formCGRect:point_2 secondPoint:point_3]);
            
            NSArray *temp = [[NSArray alloc] initWithObjects:hitbox , hitbox2, nil];
            [browder_rectangles_front setObject: temp forKey: key];

        }

        // Front - 6
        if ([coordinate_front count] == 6) {
            CGPoint point_0 = CGPointFromString([coordinate_front objectAtIndex:0]);
            CGPoint point_1 = CGPointFromString([coordinate_front objectAtIndex:1]);
            NSString *hitbox = NSStringFromCGRect([self formCGRect:point_0 secondPoint:point_1]);
            
            CGPoint point_2 = CGPointFromString([coordinate_front objectAtIndex:2]);
            CGPoint point_3 = CGPointFromString([coordinate_front objectAtIndex:3]);
            NSString *hitbox2 = NSStringFromCGRect([self formCGRect:point_2 secondPoint:point_3]);
            
            CGPoint point_4 = CGPointFromString([coordinate_front objectAtIndex:4]);
            CGPoint point_5 = CGPointFromString([coordinate_front objectAtIndex:5]);
            NSString *hitbox3 = NSStringFromCGRect([self formCGRect:point_4 secondPoint:point_5]);
            
            NSArray *temp = [[NSArray alloc] initWithObjects:hitbox , hitbox2, hitbox3, nil];
            [browder_rectangles_front setObject: temp forKey: key];

        }
        
        NSArray *coordinate_back = [browder_back_coordinates objectForKey:key];
        
        // Back - 2
        if ([coordinate_back count] == 2) {
            CGPoint point_0 = CGPointFromString([coordinate_back objectAtIndex:0]);
            CGPoint point_1 = CGPointFromString([coordinate_back objectAtIndex:1]);
            NSString *hitbox = NSStringFromCGRect([self formCGRect:point_0 secondPoint:point_1]);
            
            NSArray *temp = [[NSArray alloc] initWithObjects:hitbox ,nil];
            [browder_rectangles_back setObject: temp forKey: key];

        }

    }
    
    browder_area_front = [[NSMutableDictionary alloc] init];
    browder_area_back = [[NSMutableDictionary alloc] init];
    
    // Return Control
    
    
    
    NSLog(@"Browder Model Initiation Finished!");
    return self;
}

-(void)calculate_area: (UIImage*)image  back: (UIImage*)backImage{
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    //NSLog(@"Calculating 3rd Degree Front");
    NSArray *front_keys = [browder_rectangles_front allKeys];
    for (int a = 0; a < [front_keys count]; a++) {
        
        NSString *front_key = [front_keys objectAtIndex:a];
        NSArray *temp = [browder_rectangles_front objectForKey:front_key]; // may contain multiple CGRects, for front at least
        
        // Calculate area colored
        float subArea3rd = 0;
        float subArea2nd = 0;
        for (int b = 0; b < [temp count]; b++) {
            CGRect sub = CGRectFromString([temp objectAtIndex:b]);
            UIImage *limbImage = [self getLimbSubImage:image rectRegion:sub];
            
            NSNumber *tempNumber3 = [self getRGBAsFromImage:limbImage atX:0 andY:0 count:limbImage.size.height * limbImage.size.width degree: 3];
            NSNumber *tempNumber2 = [self getRGBAsFromImage:limbImage atX:0 andY:0 count:limbImage.size.height * limbImage.size.width degree: 2];
            
            subArea3rd += [tempNumber3 floatValue];
            subArea2nd += [tempNumber2 floatValue];
        }
        
        // Get the total area into a float
        NSString *total_string = [browder_totals_front objectForKey:front_key];
        float total_int = [total_string floatValue];
        
        float limb_area3rd = subArea3rd/total_int;
        float limb_area2nd = subArea2nd/total_int;
        
        // Get percentages multiplier
        NSString *percentage_string = [browder_percentages_front objectForKey:front_key];
        float percentage_float = [percentage_string floatValue];
        
        float limb_area_3rdfinal = round(limb_area3rd * percentage_float * 2.0) / 2.0; // round to .5 or 1
        float limb_area_2ndfinal = round(limb_area2nd * percentage_float * 2.0) / 2.0;

        // Convert to CGPoint for storages
        CGPoint point = CGPointMake(limb_area_3rdfinal, limb_area_2ndfinal);
        NSString *store = NSStringFromCGPoint(point);
        
        // Add the Key to the dictionary
        [browder_area_front setObject:store forKey:front_key];
        
        //NSLog(@"Front - Limb: %@, and area: %@", front_key, store);
        //NSLog(@"Front - Limb: %@, and area: %@", front_key, [browder_area_front objectForKey:front_key]);

        
    }
        
    //NSLog(@"\n\n\n\n\n Back \n\n\n\n\n\n");

    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    //NSLog(@"Calculating Back");
    NSArray *back_keys = [browder_rectangles_back allKeys];
    for (int a = 0; a < [back_keys count]; a++) {
        NSString *back_key = [ back_keys objectAtIndex:a ];
        NSArray *temp = [browder_rectangles_back objectForKey:back_key];
        
        float subArea3 = 0;
        float subArea2 = 0;
        
        for (int b = 0; b < [temp count]; b++) {
            CGRect sub = CGRectFromString([temp objectAtIndex:b]);
            UIImage *limbImage = [self getLimbSubImage:backImage rectRegion:sub];
            NSNumber *tempNumber3 = [self getRGBAsFromImage:limbImage atX:0 andY:0 count:limbImage.size.height * limbImage.size.width degree: 3];
            NSNumber *tempNumber2 = [self getRGBAsFromImage:limbImage atX:0 andY:0 count:limbImage.size.height * limbImage.size.width degree: 2];
            
            subArea3 += [tempNumber3 floatValue];
            subArea2 += [tempNumber2 floatValue];
        }
        
        // Get the total area into a float
        NSString *total_string = [browder_totals_back objectForKey:back_key];
        float total_int = [total_string floatValue];
        
        float limb_area3rd = subArea3/total_int;
        float limb_area2nd = subArea2/total_int;
        
        // Get percentages multiplier
        NSString *percentage_string = [browder_percentages_back objectForKey:back_key];
        float percentage_float = [percentage_string floatValue];
        
        float limb_area_3rdfinal = round(limb_area3rd * percentage_float * 2.0) / 2.0; // round to .5 or 1
        float limb_area_2ndfinal = round(limb_area2nd * percentage_float * 2.0) / 2.0;
        
        // Convert to CGPoint for storages
        CGPoint point = CGPointMake(limb_area_3rdfinal, limb_area_2ndfinal);
        NSString *store = NSStringFromCGPoint(point);
        
        // Add the Key to the dictionary
        [browder_area_back setObject:store forKey:back_key];
        
        //NSLog(@"Back - Limb: %@, and area: %@", back_key, store);

        //////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////
        
        
    }
}


-(NSString*)calculate_area_totals {
    
    NSMutableArray *totals = [[NSMutableArray alloc] init];
    
    NSString *header = [[NSString alloc] initWithFormat:@"Limb Name --- 3rd Degree --- 2nd Degree --- Total \n"];
    [totals addObject:header];
    
    float running_3rd = 0;
    float running_2nd = 0;
    float running_total = 0;
    
    for (int a=0; a < [browder_names count]; a++) {
        
        NSString *full_name = [browder_names objectAtIndex:a];
        NSString *key_name = [browder_name_coordinates objectForKey:full_name];
        
//        NSLog(@"Names -- %@, key - %@", full_name, key_name);
        
        NSString *point_front = [browder_area_front objectForKey:key_name];
        NSString *point_back = [browder_area_back objectForKey:key_name];
        
//        NSLog(@"Points -- %@, back - %@", point_front, point_back);

        
        if ((point_back != nil) && (point_front != nil)) { //back and front exist
            CGPoint frontPoint = CGPointFromString(point_front);
            CGPoint backPoint = CGPointFromString(point_back);
            CGPoint total = CGPointMake(frontPoint.x + backPoint.x,frontPoint.y + backPoint.y);
            
            NSString *line_display = [[NSString alloc] initWithFormat:@"%@ --- %3.1f --- %3.1f --- %3.1f", full_name, total.x, total.y, total.x + total.y];
            [totals addObject:line_display];
            
            running_2nd += total.y;
            running_3rd += total.x;
            running_total += total.x + total.y;
            
        } else if ((point_back != nil) &&  (point_front == nil)) { //back exists
            CGPoint backPoint = CGPointFromString(point_back);
            NSString *line_display = [[NSString alloc] initWithFormat:@"%@ --- %3.1f --- %3.1f --- %3.1f", full_name, backPoint.x, backPoint.y, backPoint.x + backPoint.y];
            [totals addObject:line_display];
            
            running_2nd += backPoint.y;
            running_3rd += backPoint.x;
            running_total += backPoint.x + backPoint.y;

        } else if ((point_back == nil) && (point_front != nil)) { //front exists
            CGPoint frontPoint = CGPointFromString(point_front);
            NSString *line_display = [[NSString alloc] initWithFormat:@"%@ --- %3.1f --- %3.1f --- %3.1f", full_name, frontPoint.x, frontPoint.y, frontPoint.x + frontPoint.y];
            [totals addObject:line_display];
            
            running_2nd += frontPoint.y;
            running_3rd += frontPoint.x;
            running_total += frontPoint.x + frontPoint.y;
            
        } else { // neither exists (CANNOT HAPPEN!)
            NSLog(@"Both Cannot be nil!");
        }
        
        
    }
    
    NSString *footer = [[NSString alloc] initWithFormat:@"\n 3rd Degree Total Burn: %3.2f \n 2ndDegree Total Burn: %3.2f \n Total Burn SurfaceArea: %3.2f \n",running_3rd, running_2nd, running_total];
    
    [totals addObject:footer];
    
    NSString *final = [totals componentsJoinedByString:@"\n"];
    
    // Set the TBSA;
    TBSA = [[[NSNumber alloc] initWithFloat:running_total] stringValue];
    return final;
}

-(NSString*)getTBSA {
    return TBSA;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Calculating

- (NSNumber*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count degree: (int)deg
{
    // Check if Image is Empty.
    CGImageRef cgref = [image CGImage];
    CIImage *cim = [image CIImage];
    if (cim == nil && cgref == NULL) {
        // No Data Found.
        return [[NSNumber alloc] initWithInt:0];
    }

    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    NSMutableArray *something = [[NSMutableArray alloc] init];
    NSString *red_s = [[NSString alloc] initWithFormat:@"something"];
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0 ; ii < count ; ++ii)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        if ((red == 1) && (deg == 3)) {
            [something addObject:red_s];
        }
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;        
        if ((blue == 1) && (deg == 2)) {
            [something addObject:red_s];
        }
        
        if ((blue == 1) && (red==1) && (green == 1)) {
            // if red, green, and blue are 1, then remove it cause we have 'white'
            [something removeLastObject];
        }
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
    
    free(rawData);
    
    NSNumber *anumber = [[NSNumber alloc] initWithInt:[something count]];
    return anumber;
    //return result;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Utility Functions

-(CGRect)formCGRect: (CGPoint)upperLeft secondPoint: (CGPoint) lowerRight {
    // formCGRect
    // Create CGRects from coordinates fed to it.
    
    return CGRectMake(upperLeft.x, upperLeft.y , abs(lowerRight.x - upperLeft.x), abs(lowerRight.y-upperLeft.y));
}

- (UIImage*)getLimbSubImage: (UIImage*)image rectRegion: (CGRect)rectangle
{
    CGImageRef smallSection = CGImageCreateWithImageInRect([image CGImage], rectangle);
    UIImage *smallImage = [UIImage imageWithCGImage:smallSection];
    return smallImage;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
