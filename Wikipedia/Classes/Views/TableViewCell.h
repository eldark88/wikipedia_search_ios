//
//  TableViewCell.h
//  Wikipedia
//
//  Created by eldark88 on 9/3/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
