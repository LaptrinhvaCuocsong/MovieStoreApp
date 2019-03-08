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
