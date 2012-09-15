//
//  DetailViewController.m
//  UIViewControllerAnimationExtensions
//
//  Created by Jonah Neugass on 9/12/12.
//  Copyright (c) 2012 Minds Unbound. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

#pragma mark - Managing the detail item


							
- (IBAction)popView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
