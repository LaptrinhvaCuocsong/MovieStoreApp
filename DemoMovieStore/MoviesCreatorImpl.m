//
//  MoviesCreatorImpl.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "MoviesCreatorImpl.h"
#import <AFNetworking.h>
#import "NSDictionary+Movie.h"
#import "Constants.h"
#import "MyNetworking.h"

@interface MoviesCreatorImpl()

@end

@implementation MoviesCreatorImpl

static NSString * const API_GET_MOVIE_LIST = @"https://api.themoviedb.org/3/movie/popular?api_key=e7631ffcb8e766993e5ec0c1f4245f93&page=%lu";

- (void) createMoviesWithPageNumber: (NSUInteger) pageNumber success: (void(^)(NSMutableArray<Movie *> *))success failure: (void(^)(void))failure {
    NSMutableArray * movies = [[NSMutableArray alloc] init];
    NSString * urlString = [NSString stringWithFormat:API_GET_MOVIE_LIST, pageNumber];
    AFHTTPSessionManager * manager = [[MyNetworking getInstance] afHttpSessionManager: nil];
    NSURLSessionDataTask * dataTask = [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject) {
            NSMutableDictionary * dictionary = (NSMutableDictionary *)responseObject;
            NSMutableArray * results = dictionary[@"results"];
            for(NSMutableDictionary * item in results) {
                NSUInteger identifier = [item identifier];
                float voteAverage = [item voteAverage];
                NSString * title = [item title];
                NSString * posterPath = [item posterPath];
                BOOL adult = [item adult];
                NSString * overviews = [item overviews];
                NSDate * releaseDate = [item releaseDate];
                Movie * movie = [[Movie alloc] initWithIdentifier:identifier voteAverage:voteAverage title:title posterPath:posterPath adult:adult overview:overviews releaseDate:releaseDate];
                [movies addObject: movie];
            }
            success(movies);
        }
        else {
            NSLog(@"responseObject is nil");
            failure();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        failure();
    }];
    [dataTask resume];
}

@end
