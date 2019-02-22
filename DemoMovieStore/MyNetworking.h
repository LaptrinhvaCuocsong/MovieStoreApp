//
//  MyNetworking.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/19/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface MyNetworking : NSObject

+ (instancetype) getInstance;

- (AFHTTPSessionManager *) afHttpSessionManager: (NSURL *)baseURL;

@end
