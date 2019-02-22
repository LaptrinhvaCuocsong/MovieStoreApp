//
//  NSDictionary+Cast.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/21/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

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
