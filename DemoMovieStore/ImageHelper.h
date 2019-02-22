//
//  ImageHelper.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/19/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface ImageHelper : NSObject

+ (instancetype _Nonnull) getInstance;

- (void) createImageURLWithImageSize: (IMAGE_SIZE)imageSize sizeOption: (NSString * _Nullable)sizeOption posterPath: (NSString * _Nonnull)posterPath success: (void(^ _Nonnull)(NSString * _Nonnull imageURLString))success failure: (void(^ _Nonnull)())failure;

@end
