//
//  MovieItemCellDelegate.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/25/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

@protocol MovieItemCellDelegate <NSObject>

- (BOOL) isGranted;

- (void) addOrRemoveFavouriteMovie: (Movie *)movie;

@end
