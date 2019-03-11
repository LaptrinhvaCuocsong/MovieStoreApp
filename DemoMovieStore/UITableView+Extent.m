#import "UITableView+Extent.h"

#define KEY_OF_MOVIES @"KEY_OF_MOVIES_TABLE"

#define KEY_OF_LOADING_DATA @"KEY_OF_LOADING_DATE"

@implementation UITableView (Extent)

@dynamic movies;

- (NSArray<Movie *> * _Nonnull) movies {
    return objc_getAssociatedObject(self, KEY_OF_MOVIES);
}

- (void) setMovies:(NSArray<Movie *> * _Nonnull)movies {
    objc_setAssociatedObject(self, KEY_OF_MOVIES, movies, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL) loadingData {
    NSNumber * n = objc_getAssociatedObject(self, KEY_OF_LOADING_DATA);
    return [n boolValue];
}

- (void) setLoadingData:(BOOL)loadingData {
    NSNumber * n = [NSNumber numberWithBool: loadingData];
    objc_setAssociatedObject(self, KEY_OF_LOADING_DATA, n, OBJC_ASSOCIATION_ASSIGN);
}

@end
