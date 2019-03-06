//
//  NSDictionary+Reminder.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 3/6/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "NSDictionary+Reminder.h"

@implementation NSDictionary (Reminder)

- (NSInteger) reminderId {
    NSNumber * n = self[@"reminderId"];
    return [n integerValue];
}

@end
