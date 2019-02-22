//
//  CollectionViewCreatorDelegate.h
//  DemoMovieStore
//
//  Created by nguyen manh hung on 2/22/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CollectionViewCreatorDelegate <NSObject>

- (void) pushDetailViewController: (DetailViewController *)detailViewController;

@end

NS_ASSUME_NONNULL_END
