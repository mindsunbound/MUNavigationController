//
//  MUNavigationController.m
//  MUNavigationController
//
//  Created by Jonah Neugass on 9/12/12.
//  Copyright (c) 2012 Minds Unbound. All rights reserved.
//

#import "MUNavigationController.h"

@interface MUNavigationController ()

@end

@implementation MUNavigationController

#pragma mark - public methods
-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if( self != nil )
    {
        _customAnimationDictionary = [[NSMutableDictionary alloc] init];
        [self setUpCustomAnimationBlocks];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if( self != nil )
    {
        _customAnimationDictionary = [[NSMutableDictionary alloc] init];
        [self setUpCustomAnimationBlocks];
    }
    return self;
    
}

-(id)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
{
    self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    if( self != nil )
    {
        _customAnimationDictionary = [[NSMutableDictionary alloc] init];
        [self setUpCustomAnimationBlocks];
    }
    return self;
    
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if( self != nil )
    {
        _customAnimationDictionary = [[NSMutableDictionary alloc] init];
        [self setUpCustomAnimationBlocks];
    }
    return self;
    
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *returnController = nil;
    if( animated )
    {
        NSInteger index = self.viewControllers.count - 2;
        if( index >= 0 )
        {
            returnController = self.visibleViewController;
            UIViewController *prevController = self.viewControllers[index];
            
            [prevController.view setFrame:self.visibleViewController.view.frame];
            [UIView transitionFromView:self.visibleViewController.view toView:prevController.view duration:_popTransitionAnimationDuration options:_popTransition completion:^(BOOL finished){
                [super popViewControllerAnimated:NO];
            }];
            return returnController;
        }
    }
    else
    {
        returnController = [super popViewControllerAnimated:NO];
    }
    return returnController;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if( animated )
    {
        [self pushViewController:viewController animationDuration:_pushTransitionAnimationDuration animationTransitionType:_pushTransition];
    }
    else
    {
        [super pushViewController:viewController animated:animated];
    }
}

-(void)pushViewController:(UIViewController *)viewController animationDuration:(CGFloat)animationDuration customAnimationBlock:(MUCustomAnimationBlock)customAnimationBlock
{
    customAnimationBlock(self.visibleViewController, viewController, animationDuration);
}


-(void)pushViewController:(UIViewController *)viewController animationDuration:(CGFloat)animationDuration animationTransitionType:(MUViewAnimationTransitionType)animationTransitionType
{
    if( animationTransitionType != MUViewAnimationTransitionTypeDefault )
    {
        if ( animationTransitionType == MUViewAnimationTransitionTypeCustom && _customPushTransitionBlock == nil)
        {
            [super pushViewController:viewController animated:YES];
        }
        if( animationTransitionType > MUViewAnimationTransitionTypeCustom )
        {
            MUCustomAnimationBlock animationBlock = _customAnimationDictionary[@(animationTransitionType)];
            [self animateTransitionWithAnimationOption:self.visibleViewController nextViewController:viewController animationDuration:animationDuration customAnimationBlock:animationBlock];
        }
        else if ( animationTransitionType == MUViewAnimationTransitionTypeCustom && _customPushTransitionBlock != nil)
        {
            [self animateTransitionWithAnimationOption:self.visibleViewController nextViewController:viewController animationDuration:animationDuration customAnimationBlock:_customPushTransitionBlock ];
        }
        else
        {
            [self animateTransitionWithAnimationOption:self.visibleViewController nextViewController:viewController animationTransition:animationTransitionType animationDuration:animationDuration];
        }
    }
    else
    {
        [super pushViewController:viewController animated:YES];
    }
    
}


-(NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    return [super popToRootViewControllerAnimated:animated];
}


-(NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    return [super popToViewController:viewController animated:animated];
}

-(NSArray *)getAnimationTypeStrings
{
    return @[@"Default", @"FlipFromLeft", @"FlipFromRight", @"CurlUp", @"CurlDown", @"CrossDissolve", @"FlipFromTop", @"FlipFromBottom", @"Custom", @"CustomFadeIn"];
}

-(NSString *)getAnimationTranstionNameFromType:(MUViewAnimationTransitionType)transitionType
{
    NSString *returnString;
    switch (transitionType)
    {
        case MUViewAnimationTransitionTypeCrossDissolve:
            returnString = @"MUViewAnimationTransitionTypeCrossDissolve";
            break;
        case MUViewAnimationTransitionTypeCurlDown:
            returnString = @"MUViewAnimationTransitionTypeCurlDown";
            break;
        case MUViewAnimationTransitionTypeCurlUp:
            returnString = @"MUViewAnimationTransitionTypeCurlUp";
            break;
        case MUViewAnimationTransitionTypeCustom:
            returnString = @"MUViewAnimationTransitionTypeCustom";
            break;
        case MUViewAnimationTransitionTypeCustomFadeIn:
            returnString = @"MUViewAnimationTransitionTypeCustomFadeIn";
            break;
        case MUViewAnimationTransitionTypeDefault:
            returnString = @"MUViewAnimationTransitionTypeDefault";
            break;
        case MUViewAnimationTransitionTypeFlipFromBottom:
            returnString = @"MUViewAnimationTransitionTypeFlipFromBottom";
            break;
        case MUViewAnimationTransitionTypeFlipFromLeft:
            returnString = @"MUViewAnimationTransitionTypeFlipFromLeft";
            break;
        case MUViewAnimationTransitionTypeFlipFromRight:
            returnString = @"MUViewAnimationTransitionTypeFlipFromRight";
            break;
        case MUViewAnimationTransitionTypeFlipFromTop:
            returnString = @"MUViewAnimationTransitionTypeFlipFromTop";
            break;
        default:
            returnString = nil;
            break;
    }
    return returnString;
}

#pragma mark - private methods
-(void)animateTransitionWithAnimationOption:(UIViewController *)currentViewController nextViewController:(UIViewController *)nextViewController animationTransition:(MUViewAnimationTransitionType)animationTransition animationDuration:(CGFloat)animationDuration
{
    MUCustomAnimationBlock animationBlock = ^void(UIViewController *currentViewController, UIViewController *nextViewController, CGFloat animationDuration)
    {
        [nextViewController.view setFrame:currentViewController.view.frame];
        [UIView transitionFromView:currentViewController.view toView:nextViewController.view duration:animationDuration options:animationTransition completion:^(BOOL finished){
            [nextViewController.view removeFromSuperview];
            [super pushViewController:nextViewController animated:NO];
        }];
    };
    animationBlock(currentViewController, nextViewController, animationDuration);
}

-(void)animateTransitionWithAnimationOption:(UIViewController *)currentViewController nextViewController:(UIViewController *)nextViewController animationDuration:(CGFloat)animationDuration customAnimationBlock:(MUCustomAnimationBlock)animationBlock
{
    animationBlock(currentViewController, nextViewController, animationDuration);
}


-(void)setUpCustomAnimationBlocks
{
    MUCustomAnimationBlock customBlock = ^void(UIViewController *currentViewController, UIViewController *nextViewController, CGFloat animationDuration)
    {
        nextViewController.view.alpha = 0;
        [currentViewController.view addSubview:nextViewController.view];
        [nextViewController.view setFrame:currentViewController.view.frame];
        MUCustomAnimationBlock animationBlock = ^void (UIViewController *currentViewController, UIViewController *nextViewController, CGFloat animationDuration)
        {
            nextViewController.view.alpha = 1;
            
        };
        
        MUAnimationCompletionBlock completionBlock = ^(BOOL finished){
            [nextViewController.view removeFromSuperview];
            [super pushViewController:nextViewController animated:NO];
        };
        
        [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            animationBlock(currentViewController, nextViewController, animationDuration);
            
        }
                         completion:completionBlock];
    };
    _customAnimationDictionary[@(MUViewAnimationTransitionTypeCustomFadeIn)] = customBlock;
    
}

@end
