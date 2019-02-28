//
//  NSMutableDictionary+SettingOfAccount.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/28/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "NSMutableDictionary+SettingOfAccount.h"

@implementation NSMutableDictionary (SettingOfAccount)

- (NSString *) urlString {
    return self[@"urlString"];
}

- (void) setUrlString:(NSString *)urlString {
    [self setObject:urlString forKey:@"urlString"];
}

- (float) movieRate {
    NSNumber * obj = self[@"movieRate"];
    return [obj floatValue];
}

- (void) setMovieRate: (float)movieRate {
    NSNumber * n = [NSNumber numberWithFloat: movieRate];
    [self setObject:n forKey:@"movieRate"];
}

- (NSInteger) releaseYear {
    NSNumber * obj = self[@"releaseYear"];
    return [obj integerValue];
}

- (void) setReleaseYear: (NSInteger)releaseYear {
    NSNumber * n = [NSNumber numberWithInteger: releaseYear];
    [self setObject:n forKey:@"releaseYear"];
}

- (TYPE_OF_SORT) typeOfSort {
    NSNumber * obj = self[@"typeOfSort"];
    return [obj integerValue];
}

- (void) setTypeOfSort:(TYPE_OF_SORT)typeOfSort {
    NSNumber * n = [NSNumber numberWithInteger: typeOfSort];
    [self setObject:n forKey:@"typeOfSort"];
}

@end
