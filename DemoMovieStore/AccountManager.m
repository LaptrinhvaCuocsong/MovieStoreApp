//
//  AccountManager.m
//  DemoMovieStore
//
//  Created by nguyen manh hung on 2/23/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "AccountManager.h"
#import "AccountMO+CoreDataClass.h"

@interface AccountManager()

@end

@implementation AccountManager

static AccountManager * instance = nil;

static NSString * const KEY_OF_ACCOUNT = @"KEY_OF_ACCOUNT";

+ (instancetype) getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!instance) {
            instance = [[AccountManager alloc] init];
        }
    });
    return instance;
}

- (void) loadAccount {
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger accountId = [userDefault integerForKey: KEY_OF_ACCOUNT];
    if(accountId) {
        self.account = [AccountMO fetchAccountWithIdentifier: (int32_t)accountId];
    }
}

- (void) saveAccountToUserDefault {
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    if(self.account) {
        [userDefault setInteger:self.account.indentifier forKey:KEY_OF_ACCOUNT];
    }
}

- (void) removeAccountToUserDefault {
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    if(self.account) {
        [userDefault removeObjectForKey: KEY_OF_ACCOUNT];
        self.account = nil;
    }
}

@end
