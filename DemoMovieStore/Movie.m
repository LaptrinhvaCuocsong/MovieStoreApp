#import "Movie.h"

@implementation Movie

- (instancetype _Nullable) initWithIdentifier: (NSUInteger)identifier voteAverage: (float)voteAverage title: (NSString * _Nonnull)title posterPath: (NSString * _Nullable)posterPath adult: (BOOL)adult overview: (NSString * _Nullable)overview releaseDate: (NSDate * _Nonnull)releaseDate {
    self = [super init];
    if(self) {
        self.identifier = identifier;
        self.voteAverage = voteAverage;
        self.title = title;
        self.posterPath = posterPath;
        self.adult = adult;
        self.overview = overview;
        self.releaseDate = releaseDate;
    }
    return self;
}

@end
