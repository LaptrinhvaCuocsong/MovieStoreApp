//
//  CastCollectionViewCell.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/21/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cast.h"

@interface CastCollectionViewCell : UICollectionViewCell

- (void) setCastCollectionViewCell: (Cast * _Nonnull)cast imageURLString: (NSString * _Nullable)imageURLString arrayImageURLString: (NSMutableArray * _Nonnull)arrayImageURLString;

@end
