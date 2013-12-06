//
//  UltimateRacerGameFinishViewController.m
//  UltimateRacer
//
//  Created by Sagar Patel on 12/5/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import "UltimateRacerGameFinishViewController.h"

#define HEIGHT 100
#define WIDTH 100

@interface UltimateRacerGameFinishViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation UltimateRacerGameFinishViewController

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
	// Do any additional setup after loading the view.
    [_label setText:_message];
    [_label setFont:[UIFont systemFontOfSize:10]];
    [_label setFont:[UIFont fontWithName:@"SubatomicTsoonami" size:70]];
    if([_message rangeOfString:@"Try Again"].location != NSNotFound)
        [_label setTextColor:[UIColor colorWithRed:180.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0]];
    else
        [_label setTextColor:[UIColor colorWithRed:100.0/255.0 green:180.0/255.0 blue:100.0/255.0 alpha:1.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
