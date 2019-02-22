//
//  MovieCollectionViewCell.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/20/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieCollectionViewCell : UICollectionViewCell

- (void) setMovieCollectionViewCell: (Movie * _Nonnull)movie imageURLString: (NSString * _Nullable)imageURLString arrayImageURLString: (NSMutableArray * _Nonnull)arrayImageURLString;

@end
