//
//  DetailViewController.h
//  MUNavigationController
//
//  Created by Jonah Neugass on 9/15/12.
//  Copyright (c) 2012 Minds Unbound. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
