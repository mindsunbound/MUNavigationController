//
//  DetailViewController.h
//  UIViewControllerAnimationExtensions
//
//  Created by Jonah Neugass on 9/12/12.
//  Copyright (c) 2012 Minds Unbound. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UITableViewController

@property(nonatomic, strong) NSArray *animationTypeArray;
@property(nonatomic, weak) MUNavigationController *muNavigationController;

@end
