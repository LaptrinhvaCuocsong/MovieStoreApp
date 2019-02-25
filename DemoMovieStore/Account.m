//
//  Account.m
//  DemoMovieStore
//
//  Created by nguyen manh hung on 2/23/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "Account.h"

@implementation Account

- (instancetype) initWithName: (NSString *)name dateOfBirth: (NSDate *)dateOfBirth email: (NSString *)email gender: (GENDER)gender avartar: (NSData *)avartar {
    self = [super init];
    if(self) {
        self.name = name;
        self.dateOfBirth = dateOfBirth;
        self.email = email;
        self.gender = gender;
        self.avartar = avartar;
    }
    return self;
}

@end
