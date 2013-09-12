//
//    PlistHelper.m
//  Logger
//
/** Created by Prem on 14/03/13.
    Copyright (c) 2013 Copyright (c) 2013 Copyright NexTip Technologies Pvt Ltd 2013.
    This program is not to be copied or distributed without the express written consent of NexTip.
    No part of  this program may be used for purposes other than those intended by NexTip. All rights reserved.
*/

#import "PlistHelper.h"

@implementation PlistHelper


//Gets your application document directory
- (NSString*)docDirectoryPath
{
    NSArray *docdirarray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
    return [docdirarray objectAtIndex:0];
}


//Copy the plist file to the documents directory.
- (BOOL)copyResourceToDocDir:(NSString*)resourceName andResourceType:(NSString*)resourceType
{
    if (resourceName.length!=0 && resourceType.length!=0)
    {
        
        @try {
                        
            NSString *itemtoCopy = [[NSBundle mainBundle]pathForResource:resourceName ofType:resourceType];
            
            return  [[NSFileManager defaultManager] copyItemAtPath:itemtoCopy toPath:[[self docDirectoryPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",resourceName,resourceType]] error:nil];
        }
        @catch (NSException *exception) {
            NSLog(@"  LOGGER INITIALIZING EXCEPTION: ERROR COPYING THE CONFIG FILE TO DOC DIRECTORY");
        }
        @finally {
            
        }
        
    }
    else
    {
        NSLog(@"  LOGGER INITIALIZING ERROR: COULD NOT LOCATE THE SPECIFIED   LOGGER CONFIG FILE ");
        return NO;
    }
}

//Enter the plist file as a parameter and it will search in the doc directory and fetch the records accordingly
- (NSDictionary*)getDatafromPlist:(NSString*)theplist
{
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[self docDirectoryPath] stringByAppendingPathComponent:theplist]];
        return dict;

    }
    @catch (NSException *exception) {
        
        NSLog(@"  LOGGER INITIALIZING EXCEPTION : ERROR RETREVING DATA FROM PLIST");
    }
    @finally {
        
    }

}

@end
