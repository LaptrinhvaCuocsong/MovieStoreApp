//
//  Account.h
//  DemoMovieStore
//
//  Created by nguyen manh hung on 2/23/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GENDER) {
    MALE = 0
    , FEMALE
};

@interface Account : NSObject

@property (nonatomic) NSInteger indentifier;

@property (nonatomic) NSString * name;

@property (nonatomic) NSDate * dateOfBirth;

@property (nonatomic) NSString * email;

@property (nonatomic) GENDER gender;

@property (nonatomic) NSData * avartar;

@property (nonatomic) NSMutableSet<Movie *> * favouriteMovies;

- (instancetype) initWithName: (NSString *)name dateOfBirth: (NSDate *)dateOfBirth email: (NSString *)email gender: (GENDER)gender avartar: (NSData *)avartar;

@end

NS_ASSUME_NONNULL_END
