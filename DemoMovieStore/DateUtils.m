//
//  DateUtils.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/21/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

+ (NSString *) stringToReleaseDate: (NSDate *)releaseDate formatDate: (NSString *)formatOfDate {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatOfDate;
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    return [dateFormatter stringFromDate: releaseDate];
}

+ (NSDate *) dateToReleaseDateString: (NSString *)releaseDateString formatDate: (NSString *)formatOfDate {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatOfDate;
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    return [dateFormatter dateFromString: releaseDateString];
}

@end
