//
//  ViewController.m
//  Test
//
//  Created by Arulkumar on 24/02/19.
//  Copyright © 2019 Arulkumar. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"
#import "FactSingleton.h"
#import "FactsVO.h"
#import "FactsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@interface ViewController ()

@end

@implementation ViewController

//NOTE : WITHOUT XIB AN STORYBOARD I HAVE FACED PROBLEMS ON SATURDAY SO FINALLY AM MOVED TO STORYBOARD AND COMPLETED THE ASSIGNMENT

@synthesize factsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.factsArray = [[NSMutableArray alloc]init];
    [factTableView registerNib:[UINib nibWithNibName:@"FactsTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"cell"];
    factTableView.dataSource = self;
    factTableView.delegate  = self;
    factTableView.estimatedRowHeight = 80.0;
    factTableView.rowHeight = UITableViewAutomaticDimension;
    factTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self getFacts];
}

#pragma - CHECK FOR INTERNET CONNECTION

-(BOOL)checkForInternetConnection{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==kNetworkStatusNotReachable)
    {
        return false;
    }
    
    return true;
}

-(void)getFacts{
    
    if (![self checkForInternetConnection]){
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                       message:@"Please check your internet connection."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        
        [[FactSingleton sharedManager]getFactsFromURL];
        
        [self doSomethingWithTheJson];
    }
}


- (NSDictionary *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"facts" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}


- (void)doSomethingWithTheJson
{
    NSDictionary *dict = [self JSONFromFile];
    
    NSArray *rows = [dict objectForKey:@"rows"];
    
    self.title = [dict objectForKey:@"title"];
    
    self.factsArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dictionary in rows) {
        
        FactsVO *factVO = [[FactsVO alloc]init];
        
        NSString *title = [dictionary objectForKey:@"title"];
        if (![title isKindOfClass:[NSNull class]]) {
            factVO.fact_Title = title;
        } else{
            factVO.fact_Title = @"";
        }
        
        NSString *des = [dictionary objectForKey:@"description"];
        if (![des isKindOfClass:[NSNull class]]) {
            factVO.fact_Description = des;
        } else{
            factVO.fact_Description = @"";
        }
        
        NSString *imgref = [dictionary objectForKey:@"imageHref"];
        if (![imgref isKindOfClass:[NSNull class]]) {
            factVO.fact_ImageHref = imgref;
        } else{
            factVO.fact_ImageHref = @"";
        }
        
         [self.factsArray addObject:factVO];
    }
    
    [factTableView reloadData];
    
}

#pragma MARK - UITABLEVIEW DATA SOURCE METHDS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.factsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"cell";
    FactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    FactsVO *factsVO = [self.factsArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = factsVO.fact_Title;
    cell.desLabel.text = factsVO.fact_Description;
    
    if (![factsVO.fact_ImageHref isKindOfClass:[NSNull class]]){
    UIImage *image = [[SDImageCache sharedImageCache]imageFromCacheForKey:factsVO.fact_ImageHref];
    if (image != nil) {
       cell.imgView.image = image;
    } else {
        
        if ([self checkForInternetConnection]){
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:factsVO.fact_ImageHref]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imgView.image = image;
                    [[SDImageCache sharedImageCache] storeImage:image forKey:factsVO.fact_ImageHref completion:^{
                    }];
                });
            });
        } else {
        }
      }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


@end
