//
//  SpriteViewController.m
//  SpriteGame
//
//  Created by Samir Choudhary on 10/19/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import "UltimateRacerViewController.h"
#import "UltimateRacerLeftScene.h"
#import "UltimateRacerRightScene.h"
#import "StartGameVC.h"
#import "JoinGameVC.h"
#import "UltimateRacerWebSockets.h"

@interface UltimateRacerViewController ()
{
    NSString * player;
}

@end

@implementation UltimateRacerViewController

@synthesize scene;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Configure the view.
    
    SKView* skView = (SKView *)self.view;
    
    if ([[self presentingViewController] isKindOfClass:[StartGameVC class]])
    {
    // Create and configure the scene.
        scene = [UltimateRacerLeftScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
        [skView presentScene:scene];
        
        StartGameVC *vc = (StartGameVC *)[self presentingViewController];
        [vc stopMusic];
    }
    
    else {
        // Create and configure the scene.
        scene = [UltimateRacerRightScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
        
        JoinGameVC *vc = (JoinGameVC *)[self presentingViewController];
        [vc stopMusic];
    }
    UltimateRacerWebSockets *websockets = [UltimateRacerWebSockets sharedInstance];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
