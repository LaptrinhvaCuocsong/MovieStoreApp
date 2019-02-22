//
//  UICollectionView+Extent.m
//  DemoMovieStore
//
//  Created by nguyen manh hung on 2/19/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

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
