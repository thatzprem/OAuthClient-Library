//
//  NSDate+NSDateUtility.m
//  OAuth2ClientApplication
//
//  Created by Prem kumar on 10/09/13.
//
//

#import "NSDate+NSDateUtility.h"

@implementation NSDate (NSDateUtility)

-(NSString *)calculateTimeDifferentinHourMinute:(NSDate *) endDate
{
    NSTimeInterval timeIntervale  = [endDate timeIntervalSinceDate:self];
    
    int minutes = floor(timeIntervale/60);
    int seconds = trunc(timeIntervale - minutes * 60);
    int hours = minutes / 60;
    NSString *timeString =@"";
    NSString *formatString=@"";
    if(hours > 0){
        formatString=hours==1?@"%d hour":@"%d hours";
        timeString = [timeString stringByAppendingString:[NSString stringWithFormat:formatString,hours]];
    }
    if(minutes > 0 || hours > 0 ){
        formatString=minutes==1?@" %d minute":@" %d minutes";
        timeString = [timeString stringByAppendingString:[NSString stringWithFormat:formatString,minutes]];
    }
    if(seconds >= 0 || hours > 0 || minutes > 0){
        formatString=seconds==1?@" %d second":@" %d seconds";
        timeString  = [timeString stringByAppendingString:[NSString stringWithFormat:formatString,seconds]];
    }
    return timeString;
}

@end
