//
//  UltimateRacerRightViewController.m
//  UltimateRacer
//
//  Created by SeungWon on 2013. 11. 17..
//  Copyright (c) 2013년 Samir Choudhary. All rights reserved.
//

#import "UltimateRacerRightViewController.h"
#import "UltimateRacerRightScene.h"
#import "JoinGameVC.h"

@interface UltimateRacerRightViewController ()

@end

@implementation UltimateRacerRightViewController
@synthesize scene;


- (void)viewDidLoad
{
    [super viewDidLoad];
    SKView * skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;

    
    if (YES){
        
        // Create and configure the scene.
        scene = [UltimateRacerRightScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    JoinGameVC *vc = [self presentingViewController];
    [vc stopMusic];
}

- (BOOL)shouldAutorotate
{
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
