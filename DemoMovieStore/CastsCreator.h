//
//  CastsCreator.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/21/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cast.h"

@protocol CastsCreator <NSObject>

- (void) createCastWithMovieId: (NSUInteger)movieId success: (void(^ _Nonnull)(NSMutableArray<Cast *> * _Nonnull casts))success failure: (void(^ _Nonnull)(void))failure;

@end
