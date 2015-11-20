//
//  YYWDate.h
//  YYWTools
//
//  Created by yoever on 15/11/16.
//  Copyright © 2015年 yoever. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  当前时间时间戳
 */
static inline NSString *yywTimeStampNow()
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval times = [date timeIntervalSince1970];
    NSString *timeStamp = [NSString stringWithFormat:@"%f",times];
    return timeStamp;
}
/**
 *  俩时间戳时间间隔
 */
static inline NSTimeInterval yywParTimeFromTimeStamps(NSString *firstTime, NSString *secondTime)
{
    NSTimeInterval timeInterval = 0;
    NSDate *firstDate = [NSDate dateWithTimeIntervalSince1970:firstTime.floatValue];
    NSDate *secondDate = [NSDate dateWithTimeIntervalSince1970:secondTime.floatValue];
    timeInterval = [firstDate timeIntervalSinceDate:secondDate];
    timeInterval = timeInterval < 0 ? -timeInterval : timeInterval;
    return timeInterval;
}
/**
 *  时间戳转换成标准时间
 */
static inline NSString *yywTimeStandaredFromTimeStampWithFormatter(NSString *timeStamp, NSString *format)
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp.floatValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    if (format) {
        [formatter setDateFormat:format];
    }else{
        [formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    }
    return [formatter stringFromDate:date];
}
/**
 *  时间戳转换成标准时间
 */
static inline NSString *yywTimeStandaredFromTimeStamp(NSString *timeStamp)
{
    return yywTimeStandaredFromTimeStampWithFormatter(timeStamp,@"MM/dd/yyyy HH:mm");
}
