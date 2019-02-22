//
//  UICollectionView+Extent.h
//  DemoMovieStore
//
//  Created by nguyen manh hung on 2/19/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "objc/message.h"
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (Extent)

@property (nonatomic) NSArray<Movie *> * movies;

@end

NS_ASSUME_NONNULL_END
