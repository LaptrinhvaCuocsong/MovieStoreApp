//
//  AccountManager.h
//  DemoMovieStore
//
//  Created by nguyen manh hung on 2/23/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountManager : NSObject

@property (nonatomic) Account * account;

+ (instancetype) getInstance;

- (void) loadAccount;

- (void) saveAccountToUserDefault;

@end

NS_ASSUME_NONNULL_END
