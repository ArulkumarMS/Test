//
//  FactSingleton.m
//  Test
//
//  Created by Arulkumar on 24/02/19.
//  Copyright © 2019 Arulkumar. All rights reserved.
//

#import "FactSingleton.h"
#import "FactsConstant.h"

@implementation FactSingleton

+ (id)sharedManager {
    static FactSingleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[FactSingleton alloc]init];
    });
    return sharedMyManager;
}

-(void)getFactsFromURL {
    
    //Here i have faced some issues so i have created the json file place in bundle and load them in tableview.
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:FACT_URL]];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:urlRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSData *data = [[NSData alloc]initWithContentsOfURL:location.absoluteURL];
        NSError *parseError;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
        NSLog(@"The response is - %@",responseDictionary);
        
        NSArray* arrData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
        NSLog(@"The new response is - %@",arrData);
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FactNotification"
         object:self];
        
    }];
    
    [downloadTask resume];
    
}

@end
