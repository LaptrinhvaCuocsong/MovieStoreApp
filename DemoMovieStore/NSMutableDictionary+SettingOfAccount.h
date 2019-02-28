//
//  NSMutableDictionary+SettingOfAccount.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/28/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface NSMutableDictionary (SettingOfAccount)

- (NSString *) urlString;

- (void) setUrlString: (NSString *)urlString;

- (float) movieRate;

- (void) setMovieRate: (float)movieRate;

- (NSInteger) releaseYear;

- (void) setReleaseYear: (NSInteger)releaseYear;

- (TYPE_OF_SORT) typeOfSort;

- (void) setTypeOfSort: (TYPE_OF_SORT)typeOfSort;

@end
