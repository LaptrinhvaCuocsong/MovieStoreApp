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
