//
//  SpriteViewController.m
//  SpriteGame
//
//  Created by Samir Choudhary on 10/19/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import "UltimateRacerLeftViewController.h"
#import "UltimateRacerLeftScene.h"
#import "UltimateRacerRightScene.h"
#import "StartGameVC.h"

@implementation UltimateRacerViewController
{
    NSString * player;
}
@synthesize scene;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    player = [ud objectForKey:PlayerType];
    
    if (YES){
    
    // Create and configure the scene.
    scene = [UltimateRacerLeftScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    }
    
    else {
        // Create and configure the scene.
        scene = [UltimateRacerRightScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
        
    }
    
    StartGameVC *vc = [self presentingViewController];
    [vc stopMusic];
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
