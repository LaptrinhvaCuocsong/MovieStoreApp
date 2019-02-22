//
//  MovieItemCell.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieItemCell : UITableViewCell

- (void) setMovieItemCell: (Movie * _Nonnull)movie imageURLString: (NSString * _Nullable)imageURLString arrayImageURLString: (NSMutableArray * _Nonnull)arrayImageURLString;

@end
