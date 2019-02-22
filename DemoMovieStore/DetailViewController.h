//
//  DetailViewController.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/20/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "TabItemViewController.h"

@interface DetailViewController : TabItemViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) Movie * movie;

@property (nonatomic) CGRect frameOfDetailView;

@end
