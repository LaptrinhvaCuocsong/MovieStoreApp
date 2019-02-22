//
//  MovieListViewController.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabItemViewController.h"
#import "TableViewCreatorDelegate.h"
#import "CollectionViewCreatorDelegate.h"

@interface MovieListViewController : TabItemViewController <TableViewCreatorDelegate, CollectionViewCreatorDelegate>

@end
