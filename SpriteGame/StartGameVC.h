//
//  StartGameVC.h
//  UltimateRacer
//
//  Created by Samir Choudhary on 11/9/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface StartGameVC : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
@property (nonatomic, strong) SKScene * leftScene;
- (IBAction)goBack:(id)sender;

@end
