//
//    PlistHelper.h
//  Logger
//
/** Created by Prem on 14/03/13.
    Copyright (c) 2013 Copyright (c) 2013 Copyright NexTip Technologies Pvt Ltd 2013.
    This program is not to be copied or distributed without the express written consent of NexTip.
    No part of  this program may be used for purposes other than those intended by NexTip. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface PlistHelper : NSObject


//Gets your application document directory
- (NSString*)docDirectoryPath;

//This method copies the plist file or any file into the document directory where you can perform all the read and write operations
- (BOOL)copyResourceToDocDir:(NSString*)resourceName andResourceType:(NSString*)resourceType;

//Enter the plist file as a parameter and it will search in the doc directory and fetch the records accordingly
- (NSDictionary*)getDatafromPlist:(NSString*)theplist;


@end
