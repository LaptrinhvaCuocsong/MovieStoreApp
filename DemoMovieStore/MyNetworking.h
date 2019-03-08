#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface MyNetworking : NSObject

+ (instancetype) getInstance;

- (AFHTTPSessionManager *) afHttpSessionManager: (NSURL *)baseURL;

@end
