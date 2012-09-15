//
//  MUNavigationController.h
//  MUNavigationController
//
//  Created by Jonah Neugass on 9/12/12.
//  Copyright (c) 2012 Minds Unbound. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, MUViewAnimationTransitionType) {
    MUViewAnimationTransitionTypeDefault         = 0 << 20,
    MUViewAnimationTransitionTypeFlipFromLeft    = 1 << 20,
    MUViewAnimationTransitionTypeFlipFromRight   = 2 << 20,
    MUViewAnimationTransitionTypeCurlUp          = 3 << 20,
    MUViewAnimationTransitionTypeCurlDown        = 4 << 20,
    MUViewAnimationTransitionTypeCrossDissolve   = 5 << 20,
    MUViewAnimationTransitionTypeFlipFromTop     = 6 << 20,
    MUViewAnimationTransitionTypeFlipFromBottom  = 7 << 20,
    MUViewAnimationTransitionTypeCustom          = 8 << 20,
    MUViewAnimationTransitionTypeCustomFadeIn    = 9 << 20,
};



typedef void (^MUCustomAnimationBlock)(UIViewController *currentViewController, UIViewController *nextViewController, CGFloat animationDuration);
typedef void (^MUAnimationCompletionBlock)(BOOL finished);

@interface MUNavigationController : UINavigationController

@property(nonatomic) MUViewAnimationTransitionType pushTransition;
@property(nonatomic) MUViewAnimationTransitionType popTransition;

@property(nonatomic) CGFloat pushTransitionAnimationDuration;
@property(nonatomic) CGFloat popTransitionAnimationDuration;

@property(nonatomic, strong) MUCustomAnimationBlock customPushTransitionBlock;
@property(nonatomic, strong) MUCustomAnimationBlock customPopTransitionBlock;

@property(nonatomic, strong) NSMutableDictionary *customAnimationDictionary;

-(void)pushViewController:(UIViewController *)viewController animationDuration:(CGFloat)animationDuration customAnimationBlock:(MUCustomAnimationBlock)customAnimationBlock;
-(void)pushViewController:(UIViewController *)viewController animationDuration:(CGFloat)animationDuration animationTransitionType:(MUViewAnimationTransitionType)animationTransitionType;
-(NSArray *)getAnimationTypeStrings;

@end
