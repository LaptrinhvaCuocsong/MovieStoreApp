#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IMAGE_SIZE) {
    BACKDROP_SIZE = 0
    , LOGO_SIZE
    , POSTER_SIZE
    , PROFILE_SIZE
    , STILL_SIZE
};

typedef NS_ENUM(NSInteger, TYPE_OF_SORT) {
    DEFAULT = 0
    , RATING_SORT
    , RELEASE_DATE_SORT
};

@interface Constants : NSObject

extern NSString * const MOVIE_ITEM_CELL;

extern NSString * const MOVIE_COLLECTION_VIEW_CELL;

extern NSString * const CAST_COLLECTION_VIEW_CELL;

extern NSString * const REMINDER_COLLECTION_VIEW_CELL;

extern NSString * const REMINDER_TABLE_VIEW_CELL;

extern NSString * const DETAIL_VIEW_CONTROLLER_MAIN_STORYBOARD;

extern NSString * const REMINDER_VIEW_CONTROLLER_MAIN_STORYBOARD;

extern NSString * const EDIT_PROFILE_VIEW_CONTROLLER_MAIN_STORYBOARD;

extern NSString * const API_GET_MOVIE_POPULAR_LIST;
extern NSString * const API_GET_MOVIE_TOP_RATE_LIST;
extern NSString * const API_GET_MOVIE_UP_COMMING_LIST;
extern NSString * const API_GET_MOVIE_NOW_PLAYING;

extern NSString * const DID_CHANGE_SETTING;

extern NSInteger MIN_RELEASE_YEAR;

extern NSString * const DID_SAVE_ACCOUNT;

extern NSString * const DID_REMOVE_ACCOUNT;

extern NSString * const DID_REMOVE_REMINDER;

@end
