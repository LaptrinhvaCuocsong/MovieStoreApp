//
//  NSDictionary+ImageConfiguration.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/19/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "NSDictionary+ImageConfiguration.h"

@implementation NSDictionary (ImageConfiguration)

- (NSString *) secureBaseURL {
    return self[@"secure_base_url"];
}

- (NSArray *) backdropSizes {
    return self[@"backdrop_sizes"];
}

- (NSArray *) logoSizes {
    return self[@"logo_sizes"];
}

- (NSArray *) posterSizes {
    return self[@"poster_sizes"];
}

- (NSArray *) profileSizes {
    return self[@"profile_sizes"];
}

- (NSArray *) stillSizes {
    return self[@"still_sizes"];
}

@end
