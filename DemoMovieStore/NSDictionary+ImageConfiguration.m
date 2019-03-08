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
