//
//  MovieItemCell.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "MovieItemCellDelegate.h"

@interface MovieItemCell : UITableViewCell

@property (nonatomic, weak) _Nullable id<MovieItemCellDelegate> delegate;

- (void) setMovieItemCell: (Movie * _Nonnull)movie;

@end
