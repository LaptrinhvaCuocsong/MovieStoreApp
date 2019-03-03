//
//  CollectionViewCreator.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CollectionViewCreatorDelegate.h"
#import "DetailViewControllerDelegate.h"

@interface CollectionViewCreator : NSObject <UICollectionViewDelegate, UICollectionViewDataSource, DetailViewControllerDelegate>

@property (nonatomic, weak) id<CollectionViewCreatorDelegate> delegate;

- (instancetype) initWithCollectionView: (UICollectionView *)collectionView;

@end
