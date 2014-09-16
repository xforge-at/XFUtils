//
//  NSDate+Additions.m
//  XFUtils
//
//  Created by Manu Wallner on 02/08/13.
//  Copyright (c) 2013 XForge Software Development GmbH. All rights reserved.
//

#import "NSDate+Additions.h"

typedef struct date_time { uint16_t year, month, day, hour, minute, second, millisecond; } date_time;

@implementation NSDate (Additions)

uint str_to_uint(const char *str, int number_of_chars) {
    uint result = 0;
    int idx = number_of_chars - 1;
    uint power = 1;
    while (idx >= 0) {
        result += ((str[idx] - '0') * power);
        idx--;
        power *= 10;
    }
    return result;
}

void convert_str_to_date(const char *date, date_time *dt) {
    //"%4u.%2u.%2u %2u:%2u:%2u.%3u"
    // Unrolled etc. to be as fast as possible
    dt->year = str_to_uint(date, 4);
    dt->month = str_to_uint(date + 5, 2);
    dt->day = str_to_uint(date + 8, 2);
    dt->hour = str_to_uint(date + 11, 2);
    dt->minute = str_to_uint(date + 14, 2);
    dt->second = str_to_uint(date + 17, 2);
    dt->millisecond = str_to_uint(date + 20, 3);
}

time_t date_time_to_unix(const date_time *dt) {
    // Precalculated list of the number of days since the beginning of the year for each month
    static const uint sum_days[] = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};

    uint total_days, leap_days, relevant_years;

    // We want years from 1970
    relevant_years = dt->year - 70;

    // Calculate the amount of leap years between 1970 and target year
    // then subtract one if the target date is a leap year itself and the date is before end of february
    // Unsafe for dates before 1970 and after 2100!!!
    // Make sure to update the code before 2100 or if traveling with time machine
    leap_days = (relevant_years + 2) / 4 - ((((dt->year) & 3) == 0) && dt->month <= 1);

    // Sum the amount of days since the year has started + the days of the month that have already passed
    // + the number of days in the years since 1970 + the amount of leap days
    total_days = sum_days[dt->month] + dt->day - 1 + (relevant_years * 365) + leap_days;

    // Convert everything to seconds and return
    return (total_days * 86400) + (dt->hour * 3600) + (dt->minute * 60) + dt->second;
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    if (!dateString) return nil;
    if ([dateString length] != 23) {
        return nil;
    }

    const char *date = [dateString cStringUsingEncoding:NSUTF8StringEncoding];

    date_time dt;
    convert_str_to_date(date, &dt);
    dt.year -= 1900;
    dt.month--;

    time_t t = date_time_to_unix(&dt);
    NSTimeInterval timeInterval = t;
    timeInterval += (dt.millisecond / 1000.0f) - [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *returnDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];

    return returnDate;
}

@end
