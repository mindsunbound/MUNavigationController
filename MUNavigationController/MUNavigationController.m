//
//  MUNavigationController.m
//  MUNavigationController
//
//  Created by Jonah Neugass on 9/12/12.
//  Copyright (c) 2012 Minds Unbound. All rights reserved.
//

#import "MUNavigationController.h"
#import "MPFoldTransition.h"
#import "MPAnimation.h"

@interface MUNavigationController ()

@end

@implementation MUNavigationController

#pragma mark - init methods
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

#pragma mark - push view controller methods
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
    customAnimationBlock(self.visibleViewController, viewController, MUNavigationActionTypePush, animationDuration);
}


-(void)pushViewController:(UIViewController *)viewController animationDuration:(CGFloat)animationDuration animationTransitionType:(MUViewAnimationTransitionType)animationTransitionType
{
    if( animationTransitionType != MUViewAnimationTransitionTypeDefault )
    {
        if ( animationTransitionType == MUViewAnimationTransitionTypeCustom && _customPushTransitionBlock == nil)
        {
            NSLog(@"There is no custom animation block set. Using standard transition");
            [super pushViewController:viewController animated:YES];
        }
        else if( animationTransitionType > MUViewAnimationTransitionTypeCustom )
        {
            MUCustomAnimationBlock animationBlock = _customAnimationDictionary[@(animationTransitionType)];
            animationBlock(self.visibleViewController, viewController, MUNavigationActionTypePush, animationDuration);
        }
        else if ( animationTransitionType == MUViewAnimationTransitionTypeCustom && _customPushTransitionBlock != nil)
        {
            _customPushTransitionBlock(self.visibleViewController, viewController, MUNavigationActionTypePush, animationDuration);
        }
        else
        {
            [self animateTransitionWithAnimationOption:self.visibleViewController nextViewController:viewController animationTransition:animationTransitionType navigationActionType:MUNavigationActionTypePush animationDuration:animationDuration];
        }
    }
    else
    {
        [super pushViewController:viewController animated:YES];
    }
    
}

#pragma mark - pop view controller methods
-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *returnController = nil;
   
    if( animated )
    {
        returnController = [self popViewController:_popTransitionAnimationDuration animationTransitionType:_popTransition];
    }
    else
    {
        returnController = [super popViewControllerAnimated:animated];
    }
    
    return returnController;
}

-(UIViewController *)popViewController:(UIViewController *)viewController animationDuration:(CGFloat)animationDuration customAnimationBlock:(MUCustomAnimationBlock)customAnimationBlock
{
    UIViewController *returnController = nil;
    customAnimationBlock(self.visibleViewController, viewController, MUNavigationActionTypePop, animationDuration);
    return returnController;
}


-(UIViewController *)popViewController:(CGFloat)animationDuration animationTransitionType:(MUViewAnimationTransitionType)animationTransitionType
{
    UIViewController *returnController = nil;
    if( animationTransitionType != MUViewAnimationTransitionTypeDefault )
    {
        NSInteger index = self.viewControllers.count - 2;
        if( index >= 0 )
        {
            returnController = self.visibleViewController;
            UIViewController *prevController = self.viewControllers[index];
            
            if ( animationTransitionType == MUViewAnimationTransitionTypeCustom && _customPopTransitionBlock == nil)
            {
                [super popViewControllerAnimated:YES];
            }
            if( animationTransitionType > MUViewAnimationTransitionTypeCustom )
            {
                MUCustomAnimationBlock animationBlock = _customAnimationDictionary[@(animationTransitionType)];
                animationBlock(self.visibleViewController, prevController, MUNavigationActionTypePop, animationDuration);
            }
            else if ( animationTransitionType == MUViewAnimationTransitionTypeCustom && _customPopTransitionBlock != nil)
            {
                _customPopTransitionBlock(self.visibleViewController, prevController, MUNavigationActionTypePop, animationDuration);
            }
            else
            {
                [self animateTransitionWithAnimationOption:self.visibleViewController nextViewController:prevController animationTransition:animationTransitionType navigationActionType:MUNavigationActionTypePop animationDuration:animationDuration];
            }
        }
    }
    else
    {
        returnController = [super popViewControllerAnimated:YES];
    }
    return returnController;
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
    //return @[@"Default", @"FlipFromLeft", @"FlipFromRight", @"CurlUp", @"CurlDown", @"CrossDissolve", @"FlipFromTop", @"FlipFromBottom", @"Custom", @"CustomFadeIn", @"ShowOrigamiFromLeft", @"ShowOrigamiFromRight"];
    return @[@"Default", @"FlipFromLeft", @"FlipFromRight", @"CurlUp", @"CurlDown", @"CrossDissolve", @"FlipFromTop", @"FlipFromBottom", @"Custom", @"CustomFadeIn", @"ShowOrigamiFromLeft", @"Fold", @"Unfold"];
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
        case MUViewAnimationTransitionTypeFold:
            returnString = @"MUViewAnimationTransitionTypeFold";
            break;
        case MUViewAnimationTransitionTypeUnfold:
            returnString = @"MUViewAnimationTransitionTypeUnfold";
            break;
        default:
            returnString = nil;
            break;
    }
    return returnString;
}

#pragma mark - private methods
-(void)animateTransitionWithAnimationOption:(UIViewController *)currentViewController nextViewController:(UIViewController *)nextViewController animationTransition:(MUViewAnimationTransitionType)animationTransition navigationActionType:(MUNavigationActionType)navigationActionType animationDuration:(CGFloat)animationDuration
{
    MUCustomAnimationBlock animationBlock = ^void(UIViewController *currentViewController, UIViewController *nextViewController, MUNavigationActionType navigationActionType, CGFloat animationDuration)
    {
        [nextViewController.view setFrame:currentViewController.view.frame];
        [UIView transitionFromView:currentViewController.view toView:nextViewController.view duration:animationDuration options:animationTransition completion:^(BOOL finished){
            [nextViewController.view removeFromSuperview];
            if( navigationActionType == MUNavigationActionTypePush )
            {
                [super pushViewController:nextViewController animated:NO];
            }
            else if ( navigationActionType == MUNavigationActionTypePop )
            {
                [super popViewControllerAnimated:NO];
            }
        }];
    };
    animationBlock(currentViewController, nextViewController, navigationActionType, animationDuration);
}


-(void)setUpCustomAnimationBlocks
{
    
    MUCustomAnimationBlock customBlock = ^void(UIViewController *currentViewController, UIViewController *nextViewController, MUNavigationActionType navigationActionType, CGFloat animationDuration)
    {
        nextViewController.view.alpha = 0;
        
        CGRect adjFrame = currentViewController.view.frame;
        adjFrame.origin.y = 64;
        [nextViewController.view setFrame:adjFrame];
        nextViewController.view.alpha = 0;
        [self.view addSubview:nextViewController.view];
        [UIView transitionWithView:[self view]
                          duration:animationDuration
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            nextViewController.view.alpha = 1;
                        }
                        completion:^(BOOL finished){
                            [nextViewController.view removeFromSuperview];
                            [self pushViewController:nextViewController animated:NO];
                        }
         ];
    };
    _customAnimationDictionary[@(MUViewAnimationTransitionTypeCustomFadeIn)] = customBlock;
    
    
    customBlock = ^void(UIViewController *currentViewController, UIViewController *nextViewController, MUNavigationActionType navigationActionType, CGFloat animationDuration)
    {
        [currentViewController.view showOrigamiTransitionWith:nextViewController.view NumberOfFolds:3 Duration:animationDuration Direction:XYOrigamiDirectionFromLeft completion:^(BOOL finished) {
            [nextViewController.view removeFromSuperview];
            [currentViewController.view setTransitionState:XYOrigamiTransitionStateIdle];
            
            if( navigationActionType == MUNavigationActionTypePush )
            {
                [super pushViewController:nextViewController animated:NO];
            }
            else if ( navigationActionType == MUNavigationActionTypePop )
            {
                [super popViewControllerAnimated:NO];
            }
        }];
    };
    
    _customAnimationDictionary[@(MUViewAnimationTransitionTypeShowOrigamiFromLeft)] = customBlock;
    
    //add fold transitions
    customBlock = ^void(UIViewController *currentViewController, UIViewController *nextViewController, MUNavigationActionType navigationActionType, CGFloat animationDuration)
    {
        if( navigationActionType == MUNavigationActionTypePush )
        {
            [self pushViewController:nextViewController foldStyle:MPFoldStyleCubic];
        }
        else if ( navigationActionType == MUNavigationActionTypePop )
        {
            [self popToRootViewControllerWithFoldStyle:MPFoldStyleUnfold];
        }        
    };
    
    _customAnimationDictionary[@(MUViewAnimationTransitionTypeFold)] = customBlock;

    customBlock = ^void(UIViewController *currentViewController, UIViewController *nextViewController, MUNavigationActionType navigationActionType, CGFloat animationDuration)
    {
        if( navigationActionType == MUNavigationActionTypePush )
        {
            [self pushViewController:nextViewController foldStyle:MPFoldStyleCubic];
        }
        else if ( navigationActionType == MUNavigationActionTypePop )
        {
            [self popToRootViewControllerWithFoldStyle:MPFoldStyleUnfold];
        }
    };
    
    _customAnimationDictionary[@(MUViewAnimationTransitionTypeUnfold)] = customBlock;
    
    
  /*  customBlock = ^void(UIViewController *currentViewController, UIViewController *nextViewController, MUNavigationActionType navigationActionType, CGFloat animationDuration)
    {
        [currentViewController.view showOrigamiTransitionWith:nextViewController.view NumberOfFolds:3 Duration:animationDuration Direction:XYOrigamiDirectionFromRight completion:^(BOOL finished) {
            [nextViewController.view removeFromSuperview];
            [currentViewController.view setTransitionState:XYOrigamiTransitionStateIdle];
            if( navigationActionType == MUNavigationActionTypePush )
            {
                [super pushViewController:nextViewController animated:NO];
            }
            else if ( navigationActionType == MUNavigationActionTypePop )
            {
                [super popViewControllerAnimated:NO];
            }
        }];
    };
    
    _customAnimationDictionary[@(MUViewAnimationTransitionTypeShowOrigamiFromRight)] = customBlock;*/
    
}

@end
