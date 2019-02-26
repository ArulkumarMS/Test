//
//  FactSingleton.h
//  Test
//
//  Created by Arulkumar on 24/02/19.
//  Copyright © 2019 Arulkumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FactsVO.h"

NS_ASSUME_NONNULL_BEGIN

@interface FactSingleton : NSObject

+ (id)sharedManager;
- (void)getFactsFromURL;

@end

NS_ASSUME_NONNULL_END
