//
//  MyNetworking.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/19/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "MyNetworking.h"

@interface MyNetworking()

@property (nonatomic) AFHTTPSessionManager * afHttpSessionManager;

@end

@implementation MyNetworking

static MyNetworking * instance = nil;

+ (instancetype) getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(instance == nil) {
            instance = [[MyNetworking alloc] init];
        }
    });
    return instance;
}

- (AFHTTPSessionManager *) afHttpSessionManager: (NSURL *)baseURL {
    if(!baseURL) {
        return [AFHTTPSessionManager manager];
    }
    if(!self.afHttpSessionManager) {
        self.afHttpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    }
    else {
        if(![self.afHttpSessionManager.baseURL.path isEqualToString:baseURL.path]) {
            self.afHttpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        }
    }
    return [self.afHttpSessionManager copy];
}

@end
