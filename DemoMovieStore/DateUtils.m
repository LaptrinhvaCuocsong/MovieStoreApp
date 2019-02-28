//
//  DateUtils.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/21/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

+ (NSString *) stringFromDate: (NSDate *)date formatDate: (NSString *)formatOfDate {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatOfDate;
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    return [dateFormatter stringFromDate: date];
}

+ (NSDate *) dateFromDateString: (NSString *)dateString formatDate: (NSString *)formatOfDate {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatOfDate;
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    return [dateFormatter dateFromString: dateString];
}

+ (NSInteger) yearFromDate: (NSDate *)date {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    return [calendar component:NSCalendarUnitYear fromDate:date];
}

@end
