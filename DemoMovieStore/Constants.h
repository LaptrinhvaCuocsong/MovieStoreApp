//
//  Constants.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IMAGE_SIZE) {
    BACKDROP_SIZE = 0
    , LOGO_SIZE
    , POSTER_SIZE
    , PROFILE_SIZE
    , STILL_SIZE
};

@interface Constants : NSObject

extern NSString * const MOVIE_ITEM_CELL;

extern NSString * const MOVIE_COLLECTION_VIEW_CELL;

extern NSString * const CAST_COLLECTION_VIEW_CELL;

extern NSString * const DETAIL_VIEW_CONTROLLER_MAIN_STORYBOARD;

@end
