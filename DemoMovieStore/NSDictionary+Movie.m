#import "NSDictionary+Movie.h"
#import "DateUtils.h"

@implementation NSDictionary (Movie)

static NSString * const formatOfReleaseDate = @"yyyy-MM-dd";

- (NSUInteger) identifier {
    NSNumber * iden = self[@"id"];
    return [iden integerValue];
}

- (float) voteAverage {
    NSNumber * average = self[@"vote_average"];
    return [average floatValue];
}

- ( NSString * _Nonnull ) title {
    NSString * title = self[@"title"];
    return title;
}

- (NSString * _Nullable) posterPath {
    NSString * poster = self[@"poster_path"];
    return poster;
}

- (BOOL) adult {
    NSNumber * adult = self[@"adult"];
    return [adult boolValue];
}

- (NSString * _Nullable) overviews {
    NSString * overviews = self[@"overview"];
    return overviews;
}

- (NSDate * _Nonnull) releaseDate {
    NSString * strDate = self[@"release_date"];
    return [DateUtils dateFromDateString:strDate formatDate:formatOfReleaseDate];
}

@end
