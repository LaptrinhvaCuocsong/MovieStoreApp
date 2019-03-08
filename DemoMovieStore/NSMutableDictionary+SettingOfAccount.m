#import "NSMutableDictionary+SettingOfAccount.h"
#import "Constants.h"

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
    NSInteger releaseYear = [obj integerValue];
    if(releaseYear == 0) {
        return MIN_RELEASE_YEAR;
    }
    return releaseYear;
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
