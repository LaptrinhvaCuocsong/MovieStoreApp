//
//  Constants.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString * const MOVIE_ITEM_CELL = @"MovieItemCell";

NSString * const MOVIE_COLLECTION_VIEW_CELL = @"MovieCollectionViewCell";

NSString * const CAST_COLLECTION_VIEW_CELL = @"CastCollectionViewCell";

NSString * const REMINDER_COLLECTION_VIEW_CELL = @"ReminderCollectionViewCell";

NSString * const REMINDER_TABLE_VIEW_CELL = @"ReminderTableViewCell";

NSString * const DETAIL_VIEW_CONTROLLER_MAIN_STORYBOARD = @"DetailViewController";

NSString * const REMINDER_VIEW_CONTROLLER_MAIN_STORYBOARD = @"ReminderViewController";

NSString * const API_GET_MOVIE_POPULAR_LIST = @"https://api.themoviedb.org/3/movie/popular?api_key=e7631ffcb8e766993e5ec0c1f4245f93&page=%lu";
NSString * const API_GET_MOVIE_TOP_RATE_LIST = @"https://api.themoviedb.org/3/movie/top_rated?api_key=e7631ffcb8e766993e5ec0c1f4245f93&page=%lu";
NSString * const API_GET_MOVIE_UP_COMMING_LIST = @"https://api.themoviedb.org/3/movie/upcoming?api_key=e7631ffcb8e766993e5ec0c1f4245f93&page=%lu";
NSString * const API_GET_MOVIE_NOW_PLAYING = @"https://api.themoviedb.org/3/movie/now_playing?api_key=e7631ffcb8e766993e5ec0c1f4245f93&page=%lu";

NSString * const DID_CHANGE_SETTING = @"DidChangeSetting";

NSInteger MIN_RELEASE_YEAR = 1970;

NSString * const DID_REMOVE_ACCOUNT = @"DID_REMOVE_ACCOUNT";

@end
