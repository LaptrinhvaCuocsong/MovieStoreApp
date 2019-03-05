//
//  RearViewController.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditProfileViewControllerDelegate.h"

@interface RearViewController : UIViewController <EditProfileViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UIViewController * frontViewController;

@end
