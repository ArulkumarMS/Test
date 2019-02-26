//
//  FactsTableViewCell.h
//  Test
//
//  Created by Arulkumar on 24/02/19.
//  Copyright © 2019 Arulkumar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FactsTableViewCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel *titleLabel;
@property(nonatomic,weak) IBOutlet UILabel *desLabel;
@property(nonatomic,weak) IBOutlet UIImageView *imgView;


@end

NS_ASSUME_NONNULL_END
