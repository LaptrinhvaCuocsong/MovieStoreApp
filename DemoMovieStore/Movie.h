//
//  Movie.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reminder;

@interface Movie : NSObject

@property (nonatomic) NSUInteger identifier;

@property (nonatomic) float voteAverage;

@property (nonatomic)  NSString * _Nonnull title;

@property (nonatomic) NSString * _Nullable posterPath;

@property (nonatomic) BOOL adult;

@property (nonatomic) NSString * _Nullable overview;

@property (nonatomic) NSDate * _Nonnull releaseDate;

@property (nonatomic) BOOL isFavouriteMovie;

@property (nonatomic) Reminder * reminder;

- (instancetype _Nullable) initWithIdentifier: (NSUInteger)identifier voteAverage: (float)voteAverage title: (NSString * _Nonnull)title posterPath: (NSString * _Nullable)posterPath adult: (BOOL)adult overview: (NSString * _Nullable)overview releaseDate: (NSDate * _Nonnull)releaseDate;

@end
