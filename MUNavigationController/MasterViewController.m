//

//  MasterViewController.m
//  MUNavigationController
//
//  Created by Jonah Neugass on 9/15/12.
//  Copyright (c) 2012 Minds Unbound. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _muNavigationController = (MUNavigationController *)self.navigationController;
    _muNavigationController.popTransition = MUViewAnimationTransitionTypeUnfold;
    _animationTypeArray = [_muNavigationController getAnimationTypeStrings];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    DetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
    detailView.muNavigationController = _muNavigationController;
    [_muNavigationController pushViewController:detailView animationDuration:0.5 animationTransitionType:transtion];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
 //  [self.view showOrigamiTransitionWith:detailView.view NumberOfFolds:3 Duration:1 Direction:XYOrigamiDirectionFromLeft completion:^(BOOL finished) {

   //}];
   
}

@end
