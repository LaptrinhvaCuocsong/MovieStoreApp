//
//  MoviesCreator.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

@protocol MoviesCreator <NSObject>

- (void) createMoviesWithPageNumber: (NSUInteger) pageNumber success: (void(^ _Nonnull)(NSMutableArray<Movie *> * _Nonnull movies))success failure: (void(^ _Nonnull)(void))failure;

@end
