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

@property (nonatomic) Account * _Nullable account;

@property (nonatomic) NSMutableDictionary * _Nullable settingOfAccount;

+ (instancetype) getInstance;

- (void) loadAccount;

- (void) saveAccountToUserDefault;

- (void) removeAccountToUserDefault;

@end

NS_ASSUME_NONNULL_END
