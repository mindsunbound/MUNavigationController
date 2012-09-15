//
//  MasterViewController.h
//  MUNavigationController
//
//  Created by Jonah Neugass on 9/15/12.
//  Copyright (c) 2012 Minds Unbound. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController

@property(nonatomic, strong) NSArray *animationTypeArray;
@property(nonatomic, weak) MUNavigationController *muNavigationController;

@end
