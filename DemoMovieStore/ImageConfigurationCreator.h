//
//  ImageConfigurationCreator.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/19/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageConfiguration.h"

@protocol ImageConfigurationCreator <NSObject>

- (void) createImageConfiguration: (void(^ _Nonnull)(ImageConfiguration * _Nonnull imageConfiguration))success failure: (void(^ _Nonnull)(void))failure;

@end
