//
//  Cast.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/21/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "Cast.h"

@implementation Cast

- (instancetype) initWithIdentifier: (NSUInteger)identifier name: (NSString *)name profilePath: (NSString *)profilePath {
    self = [super init];
    if(self) {
        self.identifier = identifier;
        self.name = name;
        self.profilePath = profilePath;
    }
    return self;
}

@end
