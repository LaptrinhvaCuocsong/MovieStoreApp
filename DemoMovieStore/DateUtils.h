//
//  DateUtils.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/21/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

+ (NSString *) stringToReleaseDate: (NSDate *)releaseDate formatDate: (NSString *)formatOfDate;

+ (NSDate *) dateToReleaseDateString: (NSString *)releaseDateString formatDate: (NSString *)formatOfDate;

@end
