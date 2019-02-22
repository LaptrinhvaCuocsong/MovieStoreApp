//
//  NSDictionary+Movie.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Movie)

- (NSUInteger) identifier;

- (float) voteAverage;

- ( NSString * _Nonnull ) title;

- (NSString * _Nullable) posterPath;

- (BOOL) adult;

- (NSString * _Nullable) overviews;

- (NSDate * _Nonnull) releaseDate;

@end
