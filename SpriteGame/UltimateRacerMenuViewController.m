//
//  UltimateRacerMenuViewController.m
//  UltimateRacer
//
//  Created by Samir Choudhary on 11/8/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import "UltimateRacerMenuViewController.h"

@interface UltimateRacerMenuViewController ()

@end

@implementation UltimateRacerMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedJoin:(id)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"Start" forKey:PlayerType];
    [ud synchronize];
    
}

- (IBAction)clickedStart:(id)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"Join" forKey:PlayerType];
    [ud synchronize];
}
@end
