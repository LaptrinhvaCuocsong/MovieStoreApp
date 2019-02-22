//
//  NSDictionary+ImageConfiguration.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/19/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ImageConfiguration)

- (NSString *) secureBaseURL;

- (NSArray *) backdropSizes;

- (NSArray *) logoSizes;

- (NSArray *) posterSizes;

- (NSArray *) profileSizes;

- (NSArray *) stillSizes;

@end
