//
//  ViewController.h
//  Test
//
//  Created by Arulkumar on 22/02/19.
//  Copyright © 2019 Arulkumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UITableView *factTableView;
}

@property(nonatomic,strong) NSMutableArray *factsArray;

@end

