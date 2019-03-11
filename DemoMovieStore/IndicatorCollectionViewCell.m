//
//  IndicatorCollectionViewCell.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 3/11/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "IndicatorCollectionViewCell.h"

@interface IndicatorCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorActivity;

@end

@implementation IndicatorCollectionViewCell

- (void) startIndicatorActivity {
    [self.indicatorActivity startAnimating];
}

@end
