//
//  ImageHelper.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/19/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "ImageHelper.h"
#import "ImageConfiguration.h"
#import "ImageConfigurationCreator.h"
#import "ImageConfigurationCreatorImpl.h"

@interface ImageHelper()

@property (nonatomic) id<ImageConfigurationCreator> imageConfigurationCreator;

@end

@implementation ImageHelper

static ImageHelper * instance = nil;

+ (instancetype) getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!instance) {
            instance = [[ImageHelper alloc] init];
        }
    });
    return instance;
}

- (instancetype) init {
    self = [super init];
    if(self) {
        self.imageConfigurationCreator = [[ImageConfigurationCreatorImpl alloc] init];
    }
    return self;
}

static ImageConfiguration * imageConfig;

- (void) createImageURLWithImageSize: (IMAGE_SIZE)imageSize sizeOption: (NSString *)sizeOption posterPath: (NSString * _Nonnull)posterPath success: (void(^)(NSString *))success failure: (void(^)())failure {
    __weak ImageHelper * weakSelf = self;
    if(!imageConfig) {
        [self.imageConfigurationCreator createImageConfiguration:^(ImageConfiguration * _Nonnull imageConfiguration) {
            imageConfig = imageConfiguration;
            NSString * urlString = [weakSelf createImageURLWithImageSize:imageSize sizeOption:sizeOption posterPath:posterPath];
            [weakSelf executeBlockWithImageURLString:urlString success:success failure:failure];
        } failure:^{
            failure();
        }];
    }
    else {
        NSString * urlString = [weakSelf createImageURLWithImageSize:imageSize sizeOption:sizeOption posterPath:posterPath];
        [self executeBlockWithImageURLString:urlString success:success failure:failure];
    }
}

- (void) executeBlockWithImageURLString: (NSString *)imageURLString success: (void(^)(NSString *))success failure: (void(^)())failure {
    if(imageURLString) {
        success(imageURLString);
    }
    else {
        failure();
    }
}

- (NSString *) createImageURLWithImageSize: (IMAGE_SIZE)imageSize sizeOption: (NSString *)sizeOption posterPath: (NSString * _Nonnull)posterPath {
    NSMutableString * urlString = nil;
    NSString * secureBaseURL = imageConfig.secureBaseURL;
    if(secureBaseURL) {
        urlString = [[NSMutableString alloc] initWithString: secureBaseURL];
        NSArray * imageSizes = [self getImageSizes:imageSize imageConfiguration: imageConfig];
        if(imageSizes) {
            if(!sizeOption) {
                [urlString appendString:[NSString stringWithFormat:@"%@%@", @"original", posterPath]];
                return urlString;
            }
            else {
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF LIKE[c] %@", sizeOption];
                NSArray * filterArray = [imageSizes filteredArrayUsingPredicate: predicate];
                if(!filterArray || filterArray.count == 0) {
                    return nil;
                }
                else {
                    [urlString appendString: [NSString stringWithFormat:@"%@%@", sizeOption, posterPath]];
                }
            }
        }
        else {
            return nil;
        }
    }
    return urlString;
}

- (NSArray *) getImageSizes: (IMAGE_SIZE)imageSize imageConfiguration: (ImageConfiguration *)imageConfiguration {
    switch (imageSize) {
        case BACKDROP_SIZE:
            return imageConfiguration.backdropSizes;
        case LOGO_SIZE:
            return imageConfiguration.logoSizes;
        case POSTER_SIZE:
            return imageConfiguration.posterSizes;
        case PROFILE_SIZE:
            return imageConfiguration.profileSizes;
        case STILL_SIZE:
            return imageConfiguration.stillSizes;
        default:
            return nil;
    }
}

@end
