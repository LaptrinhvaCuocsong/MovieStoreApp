#import "NSDictionary+Cast.h"

@implementation NSDictionary (Cast)

- (NSUInteger) identifier {
    NSNumber * iden = self[@"id"];
    return [iden unsignedIntegerValue];
}

- (NSString *) name {
    return self[@"name"];
}

- (NSString *) profilePath {
    return self[@"profile_path"];
}

@end
