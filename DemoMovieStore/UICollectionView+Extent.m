#import "UICollectionView+Extent.h"

#define KEY_OF_MOVIES @"KEY_OF_MOVIES_COLLECTIONVIEW"

@implementation UICollectionView (Extent)

@dynamic movies;

- (NSArray<Movie *> *) movies {
    return objc_getAssociatedObject(self, KEY_OF_MOVIES);
}

- (void) setMovies:(NSArray<Movie *> *)movies {
    objc_setAssociatedObject(self, KEY_OF_MOVIES, movies, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
