//
//  PGNBrowderModel.h
//  PeregrineBeta
//
//  Created by James Tan on 4/7/13.
//  Copyright (c) 2013 Peregrine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGNBrowderModel : NSObject {
    
    NSDictionary *browder_back_coordinates; // store the back coordinates
    NSDictionary *browder_front_coordinates; // store the front coordinates
    
    NSArray *browder_names; // store names
    NSDictionary *browder_name_coordinates; // name to key mappings
    NSDictionary *browder_totals_front; // store limb totals
    NSDictionary *browder_totals_back;
    
    NSMutableDictionary *browder_rectangles_front; // map names to rectangles
    NSMutableDictionary *browder_rectangles_back;
    
    NSMutableDictionary *browder_percentages_front;
    NSMutableDictionary *browder_percentages_back;
    
    NSMutableDictionary *browder_area_front; //map keys to colored areas
    NSMutableDictionary *browder_area_back;
    
    NSMutableDictionary *final_totals;
    
    NSString *TBSA;
}

-(void)calculate_area: (UIImage*)image  back: (UIImage*)backImage;
-(NSString*)calculate_area_totals;
-(NSString*)getTBSA;

@end
