//
//  MasterViewController.m
//  MUNavigationController
//
//  Created by Jonah Neugass on 9/15/12.
//  Copyright (c) 2012 Minds Unbound. All rights reserved.
//

#import "DetailViewController.h"


@implementation DetailViewController

- (void)viewDidLoad
{
    self.title = @"Detail";
    [super viewDidLoad];
    if( _muNavigationController == nil )
    {
        _muNavigationController = (MUNavigationController *)self.navigationController;
    }
    _animationTypeArray = [_muNavigationController getAnimationTypeStrings];
}
/*
 - (void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:animated];
 _muNavigationController = (MUNavigationController *)self.navigationController;
 _animationTypeArray = [_muNavigationController getAnimationTypeStrings];
 [self.tableView reloadData];
 }*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _animationTypeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AnimationListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = _animationTypeArray[indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MUViewAnimationTransitionType transtion = indexPath.row << 20;
    
    [_muNavigationController popViewController:0.5 animationTransitionType:transtion];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
