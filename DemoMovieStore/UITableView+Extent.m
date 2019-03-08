#import "UITableView+Extent.h"

#define KEY_OF_MOVIES @"KEY_OF_MOVIES_TABLE"

@implementation UITableView (Extent)

@dynamic movies;

- (NSArray<Movie *> * _Nonnull) movies {
    return objc_getAssociatedObject(self, KEY_OF_MOVIES);
}

- (void) setMovies:(NSArray<Movie *> * _Nonnull)movies {
    objc_setAssociatedObject(self, KEY_OF_MOVIES, movies, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
